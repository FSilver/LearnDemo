//
//  FWDownLoadOperation.h
//  LearnDemo
//
//  Created by silver on 2017/12/9.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWDownLoader.h"

@interface FWDownLoadOperation : NSOperation<NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property(nonatomic,readonly,strong)NSURLSessionDataTask *dataTask;

-( id)initWithRequest:(NSURLRequest*)request inSession:(NSURLSession*)session;

-(void)addHandlerForProgress:(FWDownLoaderProgressBlock)progressBlock completed:(FWDownLoaderCompletedBlock)completeBlock;

@end
