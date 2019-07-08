//
//  KKUpgradesView.h
//  game
//
//  Created by greatkk on 2018/12/20.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKUpgradesView : UIView
//更新提示框
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;//关闭按钮
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;//副标题
@property (strong,nonatomic) void(^upgradesBlock)(void);//点击立即更新
+(instancetype)shareUpgradesView;
@end

NS_ASSUME_NONNULL_END
