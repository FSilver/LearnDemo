//
//  ViewController.m
//  LearnDemo
//
//  Created by Lizhi on 2017/11/22.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import "ViewController.h"
#import "UIApplication+Hook.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import "UIView+WebCache.h"

@interface ViewController ()
{
    UIImageView *_imageView;
    dispatch_queue_t _queue;
    
    NSTimer *_timer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *titleArr = @[@"down",@"cancel"];
    for (int i = 0; i<titleArr.count; i++) {
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn1 setTitle:titleArr[i] forState:UIControlStateNormal];
        btn1.frame = CGRectMake(100, 64+50*i, 100, 30);
        btn1.tag = i;
        [btn1 addTarget:self action:@selector(hello:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn1];
    }
    
    NSString *path = NSTemporaryDirectory();
    NSLog(@"path = %@",path);
}



-(void)hello:(UIButton*)btn {
    
//    switch (btn.tag) {
//        case 0:
//        {
//            [self down];
//        }
//            break;
//        case 1:
//        {
//            [self cancel];
//        }
//            break;
//            
//        default:
//            break;
//    }
    
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 250, 336, 210)];
        [self.view addSubview:_imageView];
    }
    
    
//    [_imageView sd_internalSetImageWithURL:[NSURL URLWithString:@"http://47.88.148.22/car.jpg"] placeholderImage:[UIImage imageNamed:@"1.png"] options:SDWebImageLowPriority operationKey:nil setImageBlock:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
//        
//    } progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        
//    }];
//    
    
   [_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://47.88.148.22/car.jpg"] placeholderImage:[UIImage imageNamed:@"1.png"]];
}

-(void)down{
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:@"http://47.88.148.22/car.jpg"] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        NSLog(@"第%ld",receivedSize,expectedSize);
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        //只调用了一次
        
        //_imageView.image = image;
    }];
}

-(void)cancel{
   
   
    
    for(int i=0; i < 2; i++) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           
            [[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:@"http://47.88.148.22/car.jpg"] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                NSLog(@"webManager%d: %ld,%ld",i,receivedSize,expectedSize);
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                NSLog(@"第%d次， 只调用了一次",i);
                //_imageView.image = image;
            }];
            sleep(2);
        });
    }
  
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
