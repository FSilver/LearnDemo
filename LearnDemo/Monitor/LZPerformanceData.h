//
//  LZPerformaceData.h
//  LizhiFM
//
//  Created by lijianyun on 2017/10/26.
//  Copyright © 2017年 yibasan. All rights reserved.
//  性能数据

#import <Foundation/Foundation.h>

@interface LZPerformanceData : NSObject

/**
 *  获取应用当前的刷新帧率，为 0 到 60 之间的数
 */
@property (nonatomic, assign) CGFloat fps;

/**
 *  获取当前应用的 CPU 占用率
 */
@property (nonatomic, assign) CGFloat usedCpu;

/**
 *  获取当前应用使用的内存值，单位为字节
 */
@property (nonatomic, assign) CGFloat usedMemory;



@end
