//
//  KKBZChoicesModel.h
//  game
//
//  Created by linsheng on 2018/12/24.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "MTKJsonModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol KKBZChoicesModel <NSObject>

@end
@interface KKBZChoicesModel : MTKJsonModel
@property (nonatomic, strong) NSString *code;
//@property (nonatomic, strong) NSString *choice;
@property (nonatomic, strong) NSString *choicetype;
@property (nonatomic, strong) NSString *icon;
@end

NS_ASSUME_NONNULL_END
