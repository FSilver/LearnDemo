//
//  ViewController.m
//  LearnDemo
//
//  Created by Lizhi on 2017/11/22.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "FWImageManager.h"
#import "UIImageView+FWImage.h"

static NSString  *const url1 = @"http://47.88.148.22/car.jpg";
static NSString  *const url2 = @"https://cdn2.51julebu.com/club/img/160512153943/f0b31ff20a03490881723e4b50a65e97.png_160x160.jpeg";

@interface ViewController ()
{
    UIImageView *_imageView;
}
@property(nonatomic,strong)NSOperationQueue *downLoadQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(100, 400, 100, 30);
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hello) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    

    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 336, 210)];
        _imageView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_imageView];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
     NSLog(@"key: %@   change : %@",keyPath, change);
}


-(void)hello {
  
 
    [_imageView setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@"de"] completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        NSLog(@"finished: %d",finished);
    }];
    
//    [[FWImageManager sharedInstance]downLoadWithURL:[NSURL URLWithString:url1] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
//         NSLog(@"progress: %f",receivedSize*1.0/expectedSize * 100);
//    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        _imageView.image = image;
//    }];
    
    

//    FWDownLoadToken *token2 =  [[FWDownLoader sharedInstance]downLoadWithURL:[NSURL URLWithString:url1] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
//        NSLog(@"progress >>>>>>: %f",receivedSize*1.0/expectedSize * 100);
//    } completed:^(NSData *data, NSError *error, BOOL finished) {
//        
//         NSLog(@"2 data = %@ error = %@  ,finished = %d",data,error,finished);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"2 下载完毕");
//            _imageView.image = [[UIImage alloc]initWithData:data];
//        });
//    }];
//    
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        sleep(1);
//        NSLog(@"1 开始取消");
//        [[FWDownLoader sharedInstance]cancel:token1];
//        [[FWDownLoader sharedInstance]cancel:token2];
//        NSLog(@"2 已经取消");
//    });

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
