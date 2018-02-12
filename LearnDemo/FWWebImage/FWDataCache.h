//
//  FWDataCache.h
//  LearnDemo
//
//  Created by Lizhi on 2018/2/12.
//  Copyright © 2018年 WSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FWDataCache : NSObject

+(instancetype)sharedInstance;

-(void)storeImage:(UIImage*)image data:(NSData*)data  key:(NSString*)key;

-(UIImage*)imageForKey:(NSString*)key;

//-(void)saveData:(NSData*)image forKey:(NSString*)key;
//-(UIImage*)imageWithKey:(NSString*)key;

@end
