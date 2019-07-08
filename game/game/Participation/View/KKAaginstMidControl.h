//
//  KKAaginstMidControl.h
//  game
//
//  Created by GKK on 2018/10/11.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKAaginstMidControl : UIControl
@property (nonatomic,strong) UILabel * textLabel;//标题：KDA最高
@property (nonatomic,strong) UILabel * subtitleLabel;//前边的提示标题如：名称：，内容：
@property (nonatomic,strong) UIView * rightView;//右侧的图标，箭头或开关
@end

NS_ASSUME_NONNULL_END
