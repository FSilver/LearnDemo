//
//  FWDownLoader.h
//  LearnDemo
//
//  Created by silver on 2017/12/9.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void  (^FWDownLoaderProgressBlock)(NSInteger receivedSize,NSInteger expectedSize, NSURL *targetURL);
typedef void (^FWDownLoaderCompletedBlock)(NSData *data ,NSError *error ,BOOL finished);


@interface FWDownLoader : NSObject

+(instancetype)sharedInstance;

-(void)downLoadWithURL:(NSURL*)url progress:(FWDownLoaderProgressBlock)progressBlock completed:(FWDownLoaderCompletedBlock)completedBlock;

@end
