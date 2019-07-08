//
//  KKBottomButton.m
//  game
//
//  Created by greatkk on 2018/11/27.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBottomButton.h"
//如果不是刘海屏放在底部，是的话距离左右16，底部有阴影，阴影颜色为主题色
@implementation KKBottomButton
- (void)awakeFromNib {
    [super awakeFromNib];
    if (isIphoneX) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.superview).offset(16);
            make.width.mas_equalTo(self.superview).offset(-32);
            if (@available(iOS 11.0, *)) {
                make.bottom.mas_equalTo(self.superview.mas_safeAreaLayoutGuideBottom);
            }
            make.height.mas_equalTo(49);
        }];
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        self.layer.shadowColor = kThemeColor.CGColor;
        self.layer.shadowOpacity = 0.15;
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, 3);
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}
-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    if (userInteractionEnabled) {
        self.backgroundColor = kThemeColor;
    } else {
        self.backgroundColor = kThemeColorTranslucence;
    }
}

@end
