//
//  FWDownLoader.m
//  LearnDemo
//
//  Created by silver on 2017/12/9.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import "FWDownLoader.h"
#import "FWDownLoadOperation.h"

@interface FWDownLoader()<NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property(nonatomic,strong)NSURLSession *session;
@property(nonatomic,strong)NSOperationQueue *downLoadQueue;
@property(nonatomic,strong)NSMutableDictionary<NSURL * ,FWDownLoadOperation *> *urlOpertaionDict;

@end

@implementation FWDownLoader

+(instancetype)sharedInstance {
    
    static FWDownLoader *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FWDownLoader alloc]init];
    });
    return _instance;
}

-(id)init{
    self = [super init];
    if(self){
        
        _downLoadQueue = [[NSOperationQueue alloc]init];
        _downLoadQueue.name = @"com.fw.download";
        _downLoadQueue.maxConcurrentOperationCount = 10;
        
        _urlOpertaionDict = [NSMutableDictionary dictionary];
        
       NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
       configuration.timeoutIntervalForRequest = 15.0;
       _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    return self;
}

-(void)downLoadWithURL:(NSURL*)url progress:(FWDownLoaderProgressBlock)progressBlock completed:(FWDownLoaderCompletedBlock)completedBlock
{
    if(!url){
        return;
    }
    
    FWDownLoadOperation *operation =  _urlOpertaionDict[url];
    if(!operation){
        NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        operation = [[FWDownLoadOperation alloc]initWithRequest:urlRequest inSession:_session];
        [self.downLoadQueue addOperation:operation];
        _urlOpertaionDict[url] = operation;
        
    }
    [operation addHandlerForProgress:progressBlock completed:completedBlock];
}

#pragma mark Helper methods

-(FWDownLoadOperation*)operationWithTask:(NSURLSessionTask *)task {
    
    FWDownLoadOperation *returnOperation = nil;
    for (FWDownLoadOperation  *operation in self.downLoadQueue.operations) {
        if(operation.dataTask.taskIdentifier == task.taskIdentifier){
            returnOperation = operation;
            break;
        }
    }
    return returnOperation;
}


#pragma mark -NSURLSessionDataDelegate

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    FWDownLoadOperation *dataOperation = [self operationWithTask:dataTask];
    [dataOperation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    FWDownLoadOperation *dataOperation = [self operationWithTask:dataTask];
    [dataOperation URLSession:session dataTask:dataTask didReceiveData:data];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    FWDownLoadOperation *dataOperation = [self operationWithTask:dataTask];
    [dataOperation URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
}

#pragma mark NSURLSessionTaskDelegate

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    FWDownLoadOperation *dataOperation = [self operationWithTask:task];
    [dataOperation URLSession:session task:task didCompleteWithError:error];
}




@end
