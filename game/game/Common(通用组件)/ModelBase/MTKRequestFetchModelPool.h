//
//  MTKRequestFetchModelPool.h
//  MaiTalk
//
//  Created by Joy on 16/2/29.
//  Copyright © 2016年 duomai. All rights reserved.
// 扩展池 自动持有对象内存

#import <Foundation/Foundation.h>

@interface MTKRequestFetchModelPool : NSObject

+(instancetype)sharedRequestPool;

-(void)retainRequetModel:(MTKFetchModel*)model;

-(void)releaseRequestModel:(MTKFetchModel*)model;

-(void)drainRequestPool;

@end
