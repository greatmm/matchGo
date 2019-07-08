//
//  KKSelectPaytypeView.h
//  game
//
//  Created by greatkk on 2019/1/8.
//  Copyright © 2019 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKSelectPaytypeView : UIControl
@property (strong,nonatomic) UIImageView * imageView;//左边的图片
@property (strong,nonatomic) UILabel * textLabel;//微信，支付宝
@property (strong,nonatomic) UIImageView * selectImgView;//是否选中
@property (strong,nonatomic) void(^clickBlock)(void);
@end

NS_ASSUME_NONNULL_END
