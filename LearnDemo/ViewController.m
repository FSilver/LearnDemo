//
//  ViewController.m
//  LearnDemo
//
//  Created by Lizhi on 2017/11/22.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import "ViewController.h"
#import "UIApplication+Hook.h"

static NSThread *g_pGlobalThread = nil;
static int count = 0;
@interface ViewController ()
{
    dispatch_queue_t _queue;
    NSTimer *_timer;
    int _count;
    
    UIBackgroundTaskIdentifier _backgroundTask;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self threadForGlobal];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(go:) userInfo:nil repeats:YES];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setTitle:@"Tes" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(100, 100, 200, 100);
    [btn1 addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Stop" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 300, 200, 100);
    [btn addTarget:self action:@selector(stopBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
//    _backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        // Synchronize the cleanup call on the main thread in case
//        // the task actually finishes at around the same time.
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (_backgroundTask != UIBackgroundTaskInvalid)
//            {
//                NSLog(@"后台任务执行完毕！");
//                [[UIApplication sharedApplication] endBackgroundTask:_backgroundTask];
//                _backgroundTask = UIBackgroundTaskInvalid;
//            }
//        });
//    }];
    
    
    [UIApplication hook];
    
   
    for(int i = 0;i < 10; i++) {
        
        UIBackgroundTaskIdentifier task2 = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
           
        }];
        NSLog(@"task = %ld",task2);
    }
    
    for (int i = 1; i<=20; i++) {
        
        [[UIApplication sharedApplication]endBackgroundTask:i];
        
    }
    

    // Do any additional setup after loading the view, typically from a nib.
}

-(void)go:(NSTimer *)tim
{
    NSLog(@"View == %d ",_count);
    _count++;
    
    
//    if(_count == 15){
//        [[UIApplication sharedApplication] endBackgroundTask:_backgroundTask];
//        _backgroundTask = UIBackgroundTaskInvalid;
//    }
}

-(void)clickBtn {
    
    [self performSelector:@selector(hello:) onThread:g_pGlobalThread withObject:@"FangWei" waitUntilDone:NO];
}

-(void)stopBtn {
    
    [self performSelector:@selector(_stop) onThread:[self threadForGlobal] withObject:nil waitUntilDone:NO];
}



-(void)hello:(NSString*)text {

    NSLog(@"hello: %@",text);
}


- (NSThread *)threadForGlobal
{
    if (g_pGlobalThread == nil) {
        g_pGlobalThread = [[NSThread alloc] initWithTarget:self selector:@selector(runGlobalFunc) object:nil];
        [g_pGlobalThread setName:@"GlobalThread"];
        [g_pGlobalThread start];
    }
    return g_pGlobalThread;
}

- (void)runGlobalFunc
{
    // Should keep the runloop from exiting
    CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRunLoopRun();
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
    NSLog(@"go2");
}

- (void)_stop
{
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
