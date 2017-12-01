//
//  UIApplication+Hook.m
//  LearnDemo
//
//  Created by Lizhi on 2017/11/30.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import "UIApplication+Hook.h"
#import <objc/runtime.h>

@implementation UIApplication (Hook)

void exchangeMethod(Class aClass, SEL oldSEL, SEL newSEL)
{
    Method oldMethod = class_getInstanceMethod(aClass, oldSEL);
    assert(oldMethod);
    Method newMethod = class_getInstanceMethod(aClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
}

+ (void)hook
{
    exchangeMethod([UIApplication class],
                   @selector(beginBackgroundTaskWithExpirationHandler:),
                   @selector(hook_beginBackgroundTaskWithExpirationHandler:));
}

-(UIBackgroundTaskIdentifier)hook_beginBackgroundTaskWithExpirationHandler:(void(^ __nullable)(void))handler
{
    
    UIBackgroundTaskIdentifier taskId = [self hook_beginBackgroundTaskWithExpirationHandler:handler];
    NSLog(@"hook taskID = %ld",taskId);
    return taskId;
}


@end
