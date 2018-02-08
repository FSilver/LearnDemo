//
//  FWDownLoader.m
//  LearnDemo
//
//  Created by silver on 2017/12/9.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import "FWDownLoader.h"
#import "FWDownLoadOperation.h"

@implementation FWDownLoadToken
@end
//dispatch_barrier_sync 等待队列中早期任务完成，才开始执行后面的

@interface FWDownLoader()<NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property(nonatomic,strong)NSURLSession *session;
@property(nonatomic,strong)NSOperationQueue *downLoadQueue;
@property(nonatomic,strong)NSMutableDictionary<NSURL * ,FWDownLoadOperation *> *urlOpertaionDict;
@property(nonatomic,strong)dispatch_queue_t  barrierQueue;

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
        _downLoadQueue.name = @"com.FWDownLoader.download";
        _downLoadQueue.maxConcurrentOperationCount = 10;
        
        _urlOpertaionDict = [NSMutableDictionary dictionary];
        _barrierQueue = dispatch_queue_create("com.fw.barrierQueue", DISPATCH_QUEUE_CONCURRENT);
        
       NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
       configuration.timeoutIntervalForRequest = 15.0;
       _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    }
    return self;
}

-(FWDownLoadToken*)downLoadWithURL:(NSURL*)url progress:(FWDownLoaderProgressBlock)progressBlock completed:(FWDownLoaderCompletedBlock)completedBlock
{
    if(!url){
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completedBlock != nil){
                completedBlock(nil,nil,NO);
            }
        });
        return nil;
    }
    
    __block  FWDownLoadToken *token = nil;
    
    //意思是，把barrierQueue中的，前的任务执行完，才执行这个block
    dispatch_barrier_sync(self.barrierQueue, ^{
        
        FWDownLoadOperation *operation =  _urlOpertaionDict[url];
        if(!operation){
            NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
            operation = [[FWDownLoadOperation alloc]initWithRequest:urlRequest inSession:_session];
            operation.completionBlock = ^{
                [self.urlOpertaionDict removeObjectForKey:url];
            };
            [self.downLoadQueue addOperation:operation];
            _urlOpertaionDict[url] = operation;
        }
        FWCallbacksDictionary *callBackDict = [operation addHandlerForProgress:progressBlock completed:completedBlock];
        token = [[FWDownLoadToken alloc]init];
        token.url = url;
        token.downLoadTokenDict = callBackDict;
    });
    return token;
}

-(void)cancel:(FWDownLoadToken*)token
{
    dispatch_barrier_async(self.barrierQueue, ^{
        FWDownLoadOperation *operation = self.urlOpertaionDict[token.url];
        BOOL canceled =  [operation cancel:token.downLoadTokenDict];
        if(canceled){
            [self.urlOpertaionDict removeObjectForKey:token.url];
        }
    });
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

-(void)printCurentThread:(NSString*)str
{
    NSThread *thread = [NSThread currentThread];
    NSLog(@"%@ thread : %@",str,thread);
}

#pragma mark -NSURLSessionDataDelegate
//这些回调方法虽然都在不同的线程上，但是他们的顺序是按照预期的

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //这个是number = 4
    [self printCurentThread:@"response"];
    FWDownLoadOperation *dataOperation = [self operationWithTask:dataTask];
    [dataOperation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    //统一下载任务，在这个方法里可以出现不同的线程 如 number = 4,number = 5,number = 6
    [self printCurentThread:@"receiveData"];
    FWDownLoadOperation *dataOperation = [self operationWithTask:dataTask];
    [dataOperation URLSession:session dataTask:dataTask didReceiveData:data];
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    //这个是number = 6
    [self printCurentThread:@"willCache"];
    FWDownLoadOperation *dataOperation = [self operationWithTask:dataTask];
    [dataOperation URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
}

#pragma mark NSURLSessionTaskDelegate

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [self printCurentThread:@"error"];
    FWDownLoadOperation *dataOperation = [self operationWithTask:task];
    [dataOperation URLSession:session task:task didCompleteWithError:error];
}




@end
