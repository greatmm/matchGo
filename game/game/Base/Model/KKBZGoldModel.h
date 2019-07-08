//
//  KKBZGoldModel.h
//  game
//
//  Created by linsheng on 2018/12/24.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol KKBZGoldModel <NSObject>

@end
@interface KKBZGoldModel : MTKJsonModel
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, assign) NSInteger minPoints;
@property (nonatomic, assign) NSInteger maxPoints;
@end

NS_ASSUME_NONNULL_END
