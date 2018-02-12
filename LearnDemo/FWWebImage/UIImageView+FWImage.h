//
//  UIImageView+FWImage.h
//  LearnDemo
//
//  Created by Lizhi on 2018/2/12.
//  Copyright © 2018年 WSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWImageManager.h"

@interface UIImageView (FWImage)

-(void)setImageWithURL:(NSURL*)url;

-(void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage*)image;

-(void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage*)image completed:(FWDownLoaderCompletedBlock)completedBlock;

@end
