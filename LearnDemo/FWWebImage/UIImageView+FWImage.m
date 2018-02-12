//
//  UIImageView+FWImage.m
//  LearnDemo
//
//  Created by Lizhi on 2018/2/12.
//  Copyright © 2018年 WSX. All rights reserved.
//

#import "UIImageView+FWImage.h"

@implementation UIImageView (FWImage)

-(void)setImageWithURL:(NSURL*)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

-(void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage*)image
{
    [self setImageWithURL:url placeholderImage:image completed:nil];
}

-(void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage*)image completed:(FWDownLoaderCompletedBlock)completedBlock
{
    self.image = image;
    [[FWImageManager sharedInstance]downLoadWithURL:url progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        self.image = image;
        if(completedBlock){
            completedBlock(image,data,error,finished);
        }
    }];
}

@end
