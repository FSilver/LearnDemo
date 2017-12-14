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
#import <WebKit/WebKit.h>

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate>
{
    UIImageView *_imageView;
    dispatch_queue_t _queue;
    
    UILabel *_label;
    
    id _webView;
    
    
    
    UIButton *_button;
}
@end

@implementation ViewController

//-(void)loadView {
//
////    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
////    self.view.backgroundColor = [UIColor redColor];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.backgroundColor = [UIColor yellowColor];
    [btn1 setTitle:@"Tes" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(100, 100, 200, 100);
    [btn1 addTarget:self action:@selector(hello) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    _button = btn1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //[WKWebView new];
    });
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
//        [WKWebView new];
//        NSLog(@"_initWKWebView first excuteTime: %f ms",(CFAbsoluteTimeGetCurrent() - start)*1000);
//    });
    
}


-(void)hello {
    
    if(_webView){
        [_webView removeFromSuperview];
        _webView = nil;
    }
    [self _initWKWebView];
    
}


-(void)_initUIWebView
{
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    _webView = webView;
    NSLog(@"_initWKWebView config excuteTime: %f ms",(CFAbsoluteTimeGetCurrent() - start)*1000);
}

- (void)_initWKWebView
{
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//    configuration.preferences = [WKPreferences new];
//    // 这个必须设置为YES, 否则网页端调用 window.open() 会没有任何反应，同时也必须实现 WKUIDelegate 代理方法进行拦截处理
//    configuration.preferences.javaScriptCanOpenWindowsAutomatically = YES;
//    configuration.userContentController = [WKUserContentController new];
//   // configuration.processPool = [WKProcessPool shareProcessPool];
//   configuration.mediaPlaybackRequiresUserAction = NO;
    
    NSLog(@"_initWKWebView config excuteTime: %f ms",(CFAbsoluteTimeGetCurrent() - start)*1000);
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    
//    webView.navigationDelegate = self;
//    webView.UIDelegate = self;
//
//    webView.opaque = YES;
    
    // 监听进度值
   /// [webView addObserver:self forKeyPath:kEstimatedProgressKVOKey options:NSKeyValueObservingOptionNew context:nil];
   
    _webView = webView;
    [self.view addSubview:_webView];
    
    NSLog(@"_initWKWebView init excuteTime: %f ms",(CFAbsoluteTimeGetCurrent() - start)*1000);
    
    [self.view addSubview:_button];
}




@end
