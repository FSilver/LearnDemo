//
//  FWMonitorMgr.h
//  LearnDemo
//
//  Created by Lizhi on 2017/12/14.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <mach/mach.h>
#include <mach/task_info.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@interface FWMonitorMgr : NSObject

+(instancetype)sharedInstance;




@end
