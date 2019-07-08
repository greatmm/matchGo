//
//  BZSafeManager.h
//  EyeStock
//
//  Created by linsheng on 2018/11/5.
//  Copyright © 2018年 NiuBang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTKSafeManager : NSObject
//缓存 类对象 防止多线程调用该对象
@property (nonatomic,strong) NSMutableDictionary *dictClassStore;

+(instancetype)sharedManager;
@end

NS_ASSUME_NONNULL_END
