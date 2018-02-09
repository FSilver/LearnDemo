//
//  Test.m
//  LearnDemo
//
//  Created by silver on 2018/2/8.
//  Copyright © 2018年 WSX. All rights reserved.
//

#import "Test.h"

@implementation Test

@synthesize flag = _flag;



/*
 key = isFlag 所有外面只能监听 isFlag .  但保证self.isFlag有效，所有设置 getter = isFlag.
 */
-(void)setFlag:(BOOL)flag
{
    [self willChangeValueForKey:@"isFlag"];
    _flag = flag;
    [self didChangeValueForKey:@"isFlag"]; 
}

-(BOOL)isFlag
{
    return _flag;
}

@end
