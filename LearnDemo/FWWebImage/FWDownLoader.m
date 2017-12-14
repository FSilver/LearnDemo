//
//  FWDownLoader.m
//  LearnDemo
//
//  Created by silver on 2017/12/9.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import "FWDownLoader.h"

@implementation FWDownLoader

+(instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
    return nil;
}


@end
