//
//  HNUPushModel.h
//  HeiNiu
//
//  Created by 卢晓琼 on 16/7/9.
//  Copyright © 2016年 niubang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTKJsonModel.h"



@interface HNUPushModel : MTKJsonModel
@property (nonatomic, assign) KKMatchType matchType;
//比赛id
@property (nonatomic, strong) NSNumber *matchid;
//锦标赛id
@property (nonatomic, strong) NSNumber *championid;
@end
