//
//  KKPopcontrol.h
//  game
//
//  Created by GKK on 2018/10/9.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKPopcontrol : UIControl

@property (nonatomic,strong) UILabel * titleLabel;//标题
@property (nonatomic,assign) BOOL showArrow;//是否显示右边的箭头
@property (nonatomic,strong) UIImageView * arrowImageView;
@property (nonatomic,strong) NSString * arrowImageName;//右侧图片名称
@end

NS_ASSUME_NONNULL_END
