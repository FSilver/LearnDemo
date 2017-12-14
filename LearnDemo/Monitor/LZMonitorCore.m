//
//  LZMonitorCore.m
//  LizhiFM
//
//  Created by lijianyun on 2017/10/26.
//  Copyright © 2017年 yibasan. All rights reserved.
//  

#import "LZMonitorCore.h"
#include <mach/mach.h>
#include <mach/task_info.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import "LZThreadLogger.h"
#import "NSDate+Common.h"

@interface LZMonitorCore ()

@property (nonatomic, assign) BOOL isMonitoring;
@property (nonatomic, strong) dispatch_semaphore_t semphore;
//ANR堆栈信息列表
@property (nonatomic, strong) NSMutableArray *anrThreadInfos;

//Error堆栈信息表
@property (nonatomic, strong) NSMutableArray *errorThreadInfos;


@end



@implementation LZMonitorCore {
    LZPerformanceData *_performanceData;
    
    //FPS
    CADisplayLink *_fpsLink;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    
    //update timer
    dispatch_source_t _updateTimer;
}

#pragma mark - life cycle
- (void)dealloc {
    [self stopFpsDisplayLink];
    
    [self cancelUpdateTimer];
}

- (instancetype)init
{
    if (self = [super init]) {
        _isWriteEnabled = NO;
        _performanceData = [[LZPerformanceData alloc] init];
        self.anrThreadInfos = [NSMutableArray arrayWithCapacity:0];
        self.errorThreadInfos = [NSMutableArray arrayWithCapacity:0];
        _appStartCostTime = 0;
        
        self.semphore = dispatch_semaphore_create(0);
    }
    return self;
}

static LZMonitorCore *gLZMonitorCore = nil;
+ (LZMonitorCore *)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gLZMonitorCore = [[LZMonitorCore alloc] init];
    });
    return gLZMonitorCore;
}



#pragma mark - Error info

/**
 清空Error堆栈信息表
 */
- (void)cleanErrorInfos
{
    [self.errorThreadInfos removeAllObjects];
}

/**
 插入错误信息
 
 @param info 错误信息
 */
- (void)insertErrorInfo:(NSString *)info
{
#if DEBUG
    CHECK(info);
    
    NSString *errorInfo = [NSString stringWithFormat:@">>Monitor error: %@", info];
    [_errorThreadInfos addObject:errorInfo];
    LZLOGFILE_MONITOR(@"%@", errorInfo);
#endif
}


#pragma mark - logic

- (void)start
{
#if DEBUG
    if (_isMonitoring) {
        return;
    }
    _isMonitoring = YES;
#if kCheckANREnabled
    [self startWatchANR];
#endif
    
    [self startFpsDisplayLink];
    
    [self startUpdateTimer];
#endif
}

- (void)stop
{
    if (NO == _isMonitoring) {
        return;
    }
    _isMonitoring = NO;
    //清理ANR堆栈信息
    [self cleanAnrInfos];
    //清理Error堆栈信息
    [self cleanErrorInfos];

    [self cancelUpdateTimer];
    [self stopFpsDisplayLink];
}

//记录当次启动时间
- (void)recordCurrentAppStartTime
{
#if DEBUG
    dispatch_async(dispatch_get_main_queue(), ^{
       //在主线程记录准确，比如，主线程卡顿，使用dispatch_get_main_queue也能反馈出这种卡顿的时间
        _appStartCostTime = CFAbsoluteTimeGetCurrent() - gAppStartLauchTime;
        
        //输出到控制台
        NSString *startTimeStr = [NSString stringWithFormat:@"AppStartCostTime: %0.3f", _appStartCostTime];
        LZLOG(@"%@",startTimeStr);
        //输出到文件日志
        LZLOGFILE_MONITOR(@"%@",startTimeStr);

    });
#endif
}

#pragma mark - ANR 卡顿检测


/**
 清空ANR堆栈信息表
 */
- (void)cleanAnrInfos
{
    [self.anrThreadInfos removeAllObjects];
}

static inline dispatch_queue_t lz_event_monitor_queue() {
    static dispatch_queue_t lz_event_monitor_queue;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        lz_event_monitor_queue = dispatch_queue_create("com.lizhi.fm.lz_event_monitor_queue", NULL);
        dispatch_set_target_queue(lz_event_monitor_queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    });
    return lz_event_monitor_queue;
}

- (void)startWatchANR
{
    dispatch_async(lz_event_monitor_queue(), ^{
        while ([LZMonitorCore instance].isMonitoring) {
            __block BOOL timeOut = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                timeOut = NO;
                dispatch_semaphore_signal([LZMonitorCore instance].semphore);
            });
            [NSThread sleepForTimeInterval: lz_default_time_out_interval];
            if (timeOut) {
                @autoreleasepool {
                    NSString *mainThreadStr = [LZThreadLogger lz_logOfMainThread];
                    NSString *allThreadStr = [LZThreadLogger lz_logAllThread];
                    
                    [[LZMonitorCore instance] updatePerformanceData];
                    LZPerformanceData *data = [[LZMonitorCore instance] performanceData];
                    NSString *monitorInfoStr = [NSString stringWithFormat:@" FPS:  %d, CPU:  %3.1f%%, MEM:  %4.1fm\n", (int)round(data.fps), data.usedCpu, data.usedMemory / M_Data_Hex];
                    
                    NSDate *date = [NSDate date];
                    NSString *dateStr = [date stringOfDateWithFormatYYYYMMddHHmmssSSS];

                    //打印线程堆栈信息
                    NSMutableString *threadStr = [[NSMutableString alloc] initWithFormat:@"%@:[LZMonitorCore:ANR]\n", dateStr];
                    [threadStr appendString:@"-------------------- ANR Begin ----------------------\n"];
                    [threadStr appendString:monitorInfoStr];
                    [threadStr appendFormat:@"==========================\nMain Thread: \n%@\n", mainThreadStr];
                    [threadStr appendFormat:@"==========================\nAll Thread: \n%@\n", allThreadStr];
                    [threadStr appendString:@"------------------- ANR End -------------------------\n[ANR]"];
                    
                    //输出到控制台
                    LZLOG(@"%@", threadStr);
                    //输出到文件日志
                    LZLOGFILE_MONITOR(@"%@", threadStr);
                    
                    [[LZMonitorCore instance].anrThreadInfos addObject:threadStr];
                }
            }
            dispatch_wait([LZMonitorCore instance].semphore, DISPATCH_TIME_FOREVER);
        }
    });
}



#pragma mark - update timer

- (void)cancelUpdateTimer
{
    if (_updateTimer) {
        dispatch_source_cancel(_updateTimer);
        //dispatch_release(_updateTimer);
        _updateTimer = nil;
    }
}

- (void)startUpdateTimer
{
    [self cancelUpdateTimer];
    
    if (nil == _updateTimer) {
        
        __weak typeof(self) wSelf = self;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _updateTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_updateTimer, dispatch_walltime(NULL, 0.5f * NSEC_PER_SEC), 0.5f * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(_updateTimer, ^{
            
            @autoreleasepool {
                __strong typeof(wSelf) strongSelf = wSelf;
                [strongSelf updatePerformanceData];
                
                //输出到文件日志
                NSDate *date = [NSDate date];
                NSString *dateStr = [date stringOfDateWithFormatYYYYMMddHHmmssSSS];
                
                LZPerformanceData *data = [strongSelf performanceData];
                NSString *monitorInfoStr = [NSString stringWithFormat:@"%@: FPS:  %d, CPU:  %3.1f%%, MEM:  %4.1fm\n", dateStr, (int)round(data.fps), data.usedCpu, data.usedMemory / M_Data_Hex];
                if (strongSelf.isWriteEnabled) {
                    //输出到文件日志
                    LZLOGFILE_MONITOR(@"%@", monitorInfoStr);
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    // 通知 刷新UI
                    if (strongSelf.updateBlock) {
                        strongSelf.updateBlock(strongSelf.performanceData);
                    }
                });
            }
        });
        
        dispatch_resume(_updateTimer);
    }
}

- (void)updatePerformanceData
{
    _performanceData.usedCpu = [self usedCPU];
    _performanceData.usedMemory = [self usedMemory];
}


#pragma mark - Performance 性能信息提取
#pragma mark - CPU 信息获取

- (float)usedCPU
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

#pragma mark - memory 信息获取
- (vm_size_t)usedMemory
{
    struct mach_task_basic_info info;
    mach_msg_type_number_t size = MACH_TASK_BASIC_INFO_COUNT;
    kern_return_t kerr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

#pragma mark - fps 信息获取

- (void)tick:(CADisplayLink *)displayLink
{
    if (0 == _lastTime) {
        _lastTime = displayLink.timestamp;
        return;
    }
    
    _count ++;
    NSTimeInterval delta = displayLink.timestamp - _lastTime;
    if (1 > delta) {
        return;
    }
    
    _lastTime = displayLink.timestamp;
    _performanceData.fps = _count / delta;
    _count = 0;
}

- (void)startFpsDisplayLink
{
    if (nil == _fpsLink) {
        _fpsLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [_fpsLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopFpsDisplayLink
{
    [_fpsLink invalidate];
    _fpsLink = nil;
}

@end
