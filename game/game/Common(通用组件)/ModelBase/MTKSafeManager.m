//
//  BZSafeManager.m
//  EyeStock
//
//  Created by linsheng on 2018/11/5.
//  Copyright © 2018年 NiuBang. All rights reserved.
//

#import "MTKSafeManager.h"

@implementation MTKSafeManager
+(instancetype)sharedManager
{
    static MTKSafeManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MTKSafeManager alloc]init];
    });
    return manager;
}
- (id)init
{
    if (self=[super init]) {
        _dictClassStore=[@{} mutableCopy];
    }
    return self;
}
@end
