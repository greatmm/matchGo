//
//  KKBZChoiceTypes.h
//  game
//
//  Created by linsheng on 2018/12/24.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol KKBZChoiceTypes <NSObject>

@end
@interface KKBZChoiceTypes : MTKJsonModel
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *name;
@end

NS_ASSUME_NONNULL_END
