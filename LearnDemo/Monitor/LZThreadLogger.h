//
//  LZThreadLogger.h
//  LizhiFM
//
//  Created by lijianyun on 2017/10/30.
//  Copyright © 2017年 yibasan. All rights reserved.
//  线程堆栈信息收集

#import <Foundation/Foundation.h>

@interface LZThreadLogger : NSObject

+ (NSString *)lz_logAllThread;
+ (NSString *)lz_logOfMainThread;
+ (NSString *)lz_backtraceOfCurrentThread;
+ (NSString *)lz_logOfNSThread:(NSThread *)thread;


@end
