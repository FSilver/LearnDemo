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

@interface ViewController ()
{
    UIImageView *_imageView;
    dispatch_queue_t _queue;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setTitle:@"Tes" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(100, 100, 200, 100);
    [btn1 addTarget:self action:@selector(hello) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    NSString *path = NSTemporaryDirectory();
    NSLog(@"path = %@",path);
}



-(void)hello {
    
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 336, 210)];
        [self.view addSubview:_imageView];
    }
   [_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://47.88.148.22/car.jpg"] placeholderImage:[UIImage imageNamed:@"1.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
