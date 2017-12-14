//
//  LZMonitorCore.h
//  LizhiFM
//
//  Created by lijianyun on 2017/10/26.
//  Copyright © 2017年 yibasan. All rights reserved.
//  统一的性能监控中心，目前支持CPU、内存、FPS、卡顿等监控

#import <Foundation/Foundation.h>
#import "LZPerformanceData.h"

//控制性能监控浮窗开关，1：显示，0：关闭
#define kShowMonitorSwitch 1
#define kCheckANREnabled  1

static const NSUInteger M_Data_Hex = 1024 * 1024;
static NSTimeInterval lz_default_time_out_interval = 0.1;

typedef void (^UpdatePerformanceBlock)(LZPerformanceData *);

#if DEBUG
//记录启动的起点时间
CFAbsoluteTime gAppStartLauchTime;
#endif

@interface LZMonitorCore : NSObject

//获取性能数据
@property (nonatomic, strong, readonly) LZPerformanceData *performanceData;
//ANR堆栈信息列表
@property (nonatomic, strong, readonly) NSMutableArray *anrThreadInfos;
//Error堆栈信息表
@property (nonatomic, strong, readonly) NSMutableArray *errorThreadInfos;

@property (nonatomic, assign) double appStartCostTime; //记录启动进入到首页 总共花的时间

@property (nonatomic, copy) UpdatePerformanceBlock updateBlock;

@property (nonatomic, assign) BOOL isWriteEnabled; //性能数据写入文件*_monitor.txt，仅当次生效



+ (LZMonitorCore *)instance;

- (void)start;
- (void)stop;

/**
 清空ANR堆栈信息表
 */
- (void)cleanAnrInfos;
/**
 清空Error堆栈信息表
 */
- (void)cleanErrorInfos;

/**
 插入错误信息

 @param info 错误信息
 */
- (void)insertErrorInfo:(NSString *)info;

//记录当次启动时间
- (void)recordCurrentAppStartTime;


@end
