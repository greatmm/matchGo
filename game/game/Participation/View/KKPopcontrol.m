//
//  KKPopcontrol.m
//  game
//
//  Created by GKK on 2018/10/9.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKPopcontrol.h"

@interface KKPopcontrol ()


@end

@implementation KKPopcontrol
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.titleLabel];
}

//标题
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = kTitleColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    }
    return _titleLabel;
}
- (void)setShowArrow:(BOOL)showArrow
{
    _showArrow = showArrow;
    if (showArrow) {
        [self addSubview:self.arrowImageView];
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.titleLabel);
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        }];
    }
}
- (void)setArrowImageName:(NSString *)arrowImageName
{
    if (_arrowImageName != arrowImageName) {
        _arrowImageName = arrowImageName;
        self.arrowImageView.image = [UIImage imageNamed:_arrowImageName];
    }
}
//右边箭头
- (UIImageView *)arrowImageView
{
    if (_arrowImageView == nil) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"arrowDown_gray"];
    }
    return _arrowImageView;
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (self.selected) {
        self.titleLabel.textColor = kThemeColor;
    } else {
        self.titleLabel.textColor = kTitleColor;
    }
}

@end
