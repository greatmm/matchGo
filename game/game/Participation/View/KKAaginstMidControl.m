//
//  KKAaginstMidControl.m
//  game
//
//  Created by GKK on 2018/10/11.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKAaginstMidControl.h"

@interface KKAaginstMidControl()

@end
@implementation KKAaginstMidControl
-(void)awakeFromNib
{
    [super awakeFromNib];
    UIView * dot = [UIView new];
    dot.layer.cornerRadius = 2;
    dot.layer.masksToBounds = YES;
    dot.backgroundColor = kThemeColor;
    [self addSubview:dot];
    [dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(10);
        make.width.height.mas_equalTo(4);
    }];
    [self addSubview:self.subtitleLabel];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(dot.mas_right).offset(10);
    }];
    [self addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.subtitleLabel.mas_right).offset(10);
    }];
    UIImageView * line = [UIImageView new];
    line.image = [UIImage imageNamed:@"line"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(24);
        make.right.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self);
    }];
}
- (UILabel *)subtitleLabel
{
    if (_subtitleLabel == nil) {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.text = @"名称：";
        _subtitleLabel.textColor = kSubtitleColor;
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subtitleLabel;
}
-(UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = kTitleColor;
        _textLabel.text = @"";
    }
    return _textLabel;
}
@end
