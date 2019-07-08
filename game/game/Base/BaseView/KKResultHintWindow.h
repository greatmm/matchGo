//
//  KKResultHintWindow.h
//  game
//
//  Created by greatkk on 2018/12/4.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKResultHintWindow : UIWindow
@property (strong,nonatomic) NSDictionary * resultDic;
@property (strong,nonatomic) NSDictionary * beginDic;
@property (strong,nonatomic) NSDictionary * endDic;
@property (strong,nonatomic) void(^closeBlock)(void);
@property (strong,nonatomic) void(^clickBlock)(void);
@end

NS_ASSUME_NONNULL_END
