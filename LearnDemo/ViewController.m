//
//  ViewController.m
//  LearnDemo
//
//  Created by Lizhi on 2017/11/22.
//  Copyright © 2017年 WSX. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "FWDownLoader.h"

static NSString  *const url1 = @"http://47.88.148.22/car.jpg";
static NSString  *const url2 = @"https://cdn2.51julebu.com/club/img/160512153943/f0b31ff20a03490881723e4b50a65e97.png_160x160.jpeg";

@interface ViewController ()
{
    UIImageView *_imageView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(100, 400, 100, 30);
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hello) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)hello {
    

    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 336, 210)];
        [self.view addSubview:_imageView];
    }
   //[_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://47.88.148.22/car.jpg"] placeholderImage:[UIImage imageNamed:@"1.png"]];
    
    
    FWDownLoadToken *token1 =  [[FWDownLoader sharedInstance]downLoadWithURL:[NSURL URLWithString:url1] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {

        //NSLog(@"progress: %f",receivedSize*1.0/expectedSize * 100);

    } completed:^(NSData *data, NSError *error, BOOL finished) {
        
       // NSLog(@"data = %@ error = %@  ,finished = %d",data,error,finished);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"1 下载完毕");
             _imageView.image = [[UIImage alloc]initWithData:data];
        });
       
    }];
    
    
    
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
