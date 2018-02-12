//
//  FWImageManager.h
//  LearnDemo
//
//  Created by Lizhi on 2018/2/12.
//  Copyright © 2018年 WSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWDownLoader.h"

@interface FWImageManager : NSObject

+(instancetype)sharedInstance;

-(void)downLoadWithURL:(NSURL*)url progress:(FWDownLoaderProgressBlock)progressBlock completed:(FWDownLoaderCompletedBlock)completedBlock;




@end
