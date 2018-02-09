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


static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"complete";
typedef NSMutableDictionary<NSString* ,id> FWCallbacksDictionary;

@interface FWDownLoadToken : NSObject

@property(nonatomic,strong)NSURL *url;
@property(nonatomic,strong)FWCallbacksDictionary *downLoadTokenDict;

@end


@interface FWDownLoader : NSObject

+(instancetype)sharedInstance;

-(FWDownLoadToken*)downLoadWithURL:(NSURL*)url progress:(FWDownLoaderProgressBlock)progressBlock completed:(FWDownLoaderCompletedBlock)completedBlock;

-(void)cancel:(FWDownLoadToken*)token;

-(void)cacelAllDownLoads;

@end
