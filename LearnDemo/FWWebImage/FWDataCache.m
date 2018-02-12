//
//  FWDataCache.m
//  LearnDemo
//
//  Created by Lizhi on 2018/2/12.
//  Copyright © 2018年 WSX. All rights reserved.
//

#import "FWDataCache.h"
#import <CommonCrypto/CommonCrypto.h>

static NSString *FWNSStringMD5(NSString *string) {
    if (!string) return nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],  result[1],  result[2],  result[3],
            result[4],  result[5],  result[6],  result[7],
            result[8],  result[9],  result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@interface FWDataCache()
{
    NSMutableDictionary *_cacheDict;
    NSString *_path;
}


@end

@implementation FWDataCache

+(instancetype)sharedInstance {
    
    static FWDataCache *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FWDataCache alloc]init];
    });
    return _instance;
}

-(id)init
{
    self = [super init];
    if(self){
        _cacheDict = [NSMutableDictionary dictionary];
        _path = [self getPath];
    }
    return self;
}

-(void)storeImage:(UIImage*)image data:(NSData*)data  key:(NSString*)key
{
    key = FWNSStringMD5(key);
    
    if(!key){
        return;
    }
    
    if(image){
        [_cacheDict setObject:image forKey:key];
    }
    
    if(data){
        NSLog(@"write data length = %ld",data.length);
        BOOL result = [data writeToFile:[self pathWithKey:key] atomically:YES];
        
        
        if(result){
            NSLog(@"write YES: %d",result);
        }else{
            NSLog(@"write NO: %d",result);
        }
    }
}


-(UIImage*)imageForKey:(NSString*)key
{
    key = FWNSStringMD5(key);
    
    if(!key){
        return nil;
    }
    UIImage *image = [_cacheDict objectForKey:key];
    if(image){
        return image;
    }
    NSData *data = [[NSData alloc]initWithContentsOfFile:[self pathWithKey:key]];
    image = [UIImage imageWithData:data];
    if(image){
        [_cacheDict setObject:image forKey:key];
    }
    return image;
}



-(NSString*)pathWithKey:(NSString*)key
{
    NSString *filePath = [_path stringByAppendingPathComponent:key];
    NSLog(@"filePath = %@  key= %@",filePath,key);
    return filePath;
}

-(NSString*)getPath{
    
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cacheFolder stringByAppendingPathComponent:@"FWWebImage"];
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:path]){
        [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:NULL error:NULL];
    }
    return path;
}

@end
