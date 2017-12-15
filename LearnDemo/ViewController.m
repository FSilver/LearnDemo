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
#import <WebKit/WebKit.h>
#import "FWMonitorView.h"


@interface ViewController ()<WKNavigationDelegate,WKUIDelegate>
{
    UIImageView *_imageView;
    dispatch_queue_t _queue;
    NSTimer *_timer;
    UILabel *_label;
    id _webView;
    UIButton *_button;
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
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.backgroundColor = [UIColor yellowColor];
    [btn1 setTitle:@"Tes" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(100, 100, 200, 100);
    [btn1 addTarget:self action:@selector(hello) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    _button = btn1;


    
    FWMonitorView *view = [FWMonitorView monitor];
    [self.view addSubview:view];
}


-(void)hello:(UIButton*)btn {
    

    
  
    
}


@end
