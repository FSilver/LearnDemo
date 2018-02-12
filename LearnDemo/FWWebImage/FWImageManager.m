//
//  FWImageManager.m
//  LearnDemo
//
//  Created by Lizhi on 2018/2/12.
//  Copyright © 2018年 WSX. All rights reserved.
//

#import "FWImageManager.h"
#import "FWDataCache.h"

@interface FWImageManager()
{
    dispatch_queue_t _queue;
}
@property(nonatomic,strong)FWDownLoader *downLoader;

@end

@implementation FWImageManager

+(instancetype)sharedInstance {
    
    static FWImageManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FWImageManager alloc]init];
    });
    return _instance;
}

-(id)init
{
    self = [super init];
    if(self){
        _downLoader = [FWDownLoader sharedInstance];
        _queue = dispatch_queue_create("com.fw.managerQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}


#pragma mark - public

-(void)downLoadWithURL:(NSURL*)url progress:(FWDownLoaderProgressBlock)progressBlock completed:(FWDownLoaderCompletedBlock)completedBlock
{
    dispatch_async(_queue, ^{
       
        UIImage *image = [[FWDataCache sharedInstance]imageForKey:url.absoluteString];
        if(image){
            if(completedBlock){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completedBlock(image,nil,nil,YES);
                });
            }
        }else{
            [_downLoader downLoadWithURL:url progress:progressBlock completed:completedBlock];
        }
    });
}

#pragma mark - private



@end
