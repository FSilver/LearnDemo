//
//  FWDownLoadOperation.m
//  LearnDemo
//
//  Created by silver on 2017/12/9.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import "FWDownLoadOperation.h"



@interface FWDownLoadOperation()

@property(nonatomic,strong)NSURLRequest *request;
@property(nonatomic,weak)NSURLSession *session;
@property (strong, nonatomic) NSMutableData *loadData;
@property (nonatomic,assign)NSInteger expectedSize;
@property(nonatomic,strong)NSMutableArray<FWCallbacksDictionary*> *callbackBlockArray;
@property(nonatomic,strong)dispatch_queue_t  barrierQueue;


@property (nonatomic, assign,getter=isExecuting) BOOL executing;
@property (assign,nonatomic ,getter=isFinished) BOOL finished;


@end

@implementation FWDownLoadOperation

//Xcode4.4之前，@synthesize executing; 会生成一个 _executing私有变量。和setter 和 getter方法
//Xcode4.4之后，@synthesize  executing = _executing; 告诉编译器 属性executing 为_executing的getter和setter方法的实现

@synthesize executing = _executing;
@synthesize finished = _finished;

-( id)initWithRequest:(NSURLRequest*)request inSession:(NSURLSession*)session
{
    self = [super init];
    if(self){
        
        _request = request;
        _session = session;
        _callbackBlockArray = [NSMutableArray array];
        _barrierQueue = dispatch_queue_create("com.FWDownLoadOperation.barrierQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}


//start 和 main同时写，只会执行start
//不写start那么执行main
-(void)start
{
    NSLog(@"start");
    
    _dataTask = [_session dataTaskWithRequest:_request];
    self.executing = YES;
    [self.dataTask resume];
}

-(void)main
{
    NSLog(@"main");
}

-(FWCallbacksDictionary*)addHandlerForProgress:(FWDownLoaderProgressBlock)progressBlock completed:(FWDownLoaderCompletedBlock)completeBlock
{
    FWCallbacksDictionary *callbackDict = [NSMutableDictionary dictionary];
    if(progressBlock){
        callbackDict[kProgressCallbackKey] = [progressBlock copy];
    }
    if(completeBlock){
        callbackDict[kCompletedCallbackKey] = [completeBlock copy];
    }
    [self.callbackBlockArray addObject:callbackDict];
    return callbackDict;
}


-(BOOL)cancel:(FWCallbacksDictionary*)token
{
    BOOL shouldCancel = NO;
    [self.callbackBlockArray removeObjectIdenticalTo:token];
    if(self.callbackBlockArray.count == 0){
        shouldCancel = YES;
    }
    if(shouldCancel){
        [self cancel];
    }
    return shouldCancel;
}


- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{

    NSInteger expected = (NSInteger)response.expectedContentLength;
    self.expectedSize = expected;
    self.loadData = [[NSMutableData alloc]initWithCapacity:expected];
    if(completionHandler){
        completionHandler(NSURLSessionResponseAllow);
    }
    
}


-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.loadData appendData:data];
    
    for (FWCallbacksDictionary  *dict  in self.callbackBlockArray) {
        FWDownLoaderProgressBlock progressBlock = dict[kProgressCallbackKey];
        progressBlock(self.loadData.length,self.expectedSize,self.request.URL);
    }
    
    const NSInteger totalSize = self.loadData.length;
    BOOL finished = (totalSize >= self.expectedSize);
    if(finished){
        [self callCompletionBlockWithData:data error:nil finished:YES];
        self.finished = YES;
    }
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    
    
//    if(completionHandler){
//        completionHandler(cachedResponse);
//    }
    NSLog(@"completionHandler");
}


#pragma mark NSURLSessionTaskDelegate

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [self callCompletionBlockWithError:error];
}


#pragma mark -Helper methods

-(void)callCompletionBlockWithError:(NSError*)error
{
    [self callCompletionBlockWithData:nil error:error finished:NO];
}

-(void)callCompletionBlockWithData:(NSData*)data  error:(NSError*)error  finished:(BOOL)finished
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (FWCallbacksDictionary  *dict  in self.callbackBlockArray) {
            FWDownLoaderCompletedBlock completedBlock = dict[kCompletedCallbackKey];
            completedBlock(data,error,finished);
        }
    });
}




@end





































