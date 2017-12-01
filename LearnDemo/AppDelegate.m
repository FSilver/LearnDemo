//
//  AppDelegate.m
//  LearnDemo
//
//  Created by Lizhi on 2017/11/22.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    UIBackgroundTaskIdentifier _backgroundTask;
    NSTimer *_timer;
    int _count;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
//    NSLog(@"后台任务执行开始");
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(go:) userInfo:nil repeats:YES];
//    //额外有，执行3分钟
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
//
//    NSLog(@"task id = %ld",_backgroundTask);
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

-(void)go:(NSTimer *)tim
{
    NSLog(@"%@ == %d ",[NSDate date],_count);
    _count++;
    if(_count == 5){
        [[UIApplication sharedApplication] endBackgroundTask:_backgroundTask];
        _backgroundTask = UIBackgroundTaskInvalid;
    }
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
