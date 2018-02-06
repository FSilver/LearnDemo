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
    
    
    
    dispatch_queue_t queue = dispatch_queue_create("thread", DISPATCH_QUEUE_CONCURRENT);  
    dispatch_async(queue, ^{  
        sleep(3);  
        NSLog(@"test1");  
    });  
    dispatch_async(queue, ^{  
        NSLog(@"test2");  
    });  
    dispatch_sync(queue, ^{  
        NSLog(@"test3");  
    });  
    dispatch_barrier_async(queue, ^{      ///分界线在这里 请注意是同步的  
        sleep(1);  
        for (int i = 0; i<50; i++) {  
            if (i == 10 ) {  
                NSLog(@"point1");  
            }else if(i == 20){  
                NSLog(@"point2");  
            }else if(i == 40){  
                NSLog(@"point3");  
            }  
        }  
    });  
    NSLog(@"hello");  
    dispatch_async(queue, ^{  
        NSLog(@"test4");  
    });  
    NSLog(@"world");  
    dispatch_async(queue, ^{  
        NSLog(@"test5");  
    });  
    dispatch_async(queue, ^{  
        NSLog(@"test6");  
    });  
    
    
    
    
    return;
   
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 336, 210)];
        [self.view addSubview:_imageView];
    }
   //[_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://47.88.148.22/car.jpg"] placeholderImage:[UIImage imageNamed:@"1.png"]];
    
    
    [[FWDownLoader sharedInstance]downLoadWithURL:[NSURL URLWithString:url1] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
        NSLog(@"progress: %f",receivedSize*1.0/expectedSize * 100);
    } completed:^(NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
             _imageView.image = [[UIImage alloc]initWithData:data];
        });
       
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
