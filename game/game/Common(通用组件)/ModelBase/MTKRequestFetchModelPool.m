//
//  MTKRequestFetchModelPool.m
//  MaiTalk
//
//  Created by Joy on 16/2/29.
//  Copyright © 2016年 duomai. All rights reserved.
//

#import "MTKRequestFetchModelPool.h"

@interface MTKRequestFetchModelPool ()

@property (nonatomic,strong) NSMutableSet *requestModelPoolSet;

@end

@implementation MTKRequestFetchModelPool

+(instancetype)sharedRequestPool
{
    static MTKRequestFetchModelPool *pool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pool = [[MTKRequestFetchModelPool alloc]init];
    });
    return pool;
}

-(instancetype)init
{
    if (self = [super init]) {
        _requestModelPoolSet = [NSMutableSet set];
    }
    return self;
}

-(void)retainRequetModel:(MTKFetchModel *)model
{
    if (model) {
        [_requestModelPoolSet addObject:model];
    }
}

-(void)releaseRequestModel:(MTKFetchModel *)model
{
    if (model) {
        [_requestModelPoolSet removeObject:model];
    }
}

-(void)drainRequestPool
{
    [_requestModelPoolSet removeAllObjects];
}

@end
