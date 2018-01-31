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
#import "QiniuSDK.h"

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

__weak NSString *string_weak_ = nil;
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
    
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
    imageView.image = [UIImage imageNamed:@"myImg"];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = imageView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    [self.view addSubview:imageView];
    
    
//    UIImageView *panelView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, 150, 100)];
//    panelView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:panelView];
//
//    UIGraphicsBeginImageContextWithOptions(panelView.bounds.size,NO,1.0);
//    //使用贝塞尔曲线画出一个圆形图
//    [[UIBezierPath bezierPathWithRoundedRect:panelView.bounds cornerRadius:panelView.frame.size.width]addClip];
//    [panelView drawRect:panelView.bounds];
//    panelView.image =UIGraphicsGetImageFromCurrentImageContext();
//    //结束画图
//    UIGraphicsEndImageContext();
    
    //master 1
    //master 2
}



-(void)hello:(UIButton*)btn {
    //This is master  by  only.
    
}



- (void)uploadImageToQNFilePath:(NSString *)filePath {
    NSString *token = @"RIAkhLz5PTc04rfZ1-90UlboNBPm-xQZAl7CvchM:Qrypl0QNMpKFk9TV7Ywy0auMuJo=:eyJzY29wZSI6ImxpemhpLWZtLWFwcC11cGxvYWRlciIsImRlYWRsaW5lIjoxNTE0OTYyMDAwfQ==";
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    NSLog(@"putFile ");
    [upManager putFile:filePath key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
    }
                option:uploadOption];
    NSLog(@"上传完毕？");
}




@end
