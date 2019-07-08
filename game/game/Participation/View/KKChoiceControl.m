//
//  KKChoiceControl.m
//  game
//
//  Created by GKK on 2018/10/17.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKChoiceControl.h"
@implementation KKChoiceControl
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.centerY.mas_equalTo(self).offset(-10);
    }];
    [self addSubview:self.subtitleLabel];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.titleLabel);
    }];
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = kThemeColor.CGColor;
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.layer.borderWidth = 0;
        self.backgroundColor = [UIColor colorWithWhite:249/255.0 alpha:1];
    }
}
-(UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [UIImageView new];
        if (self.tag == 0) {
            _imgView.image = [UIImage imageNamed:@"jingjiIcon"];
        } else {
            _imgView.image = [UIImage imageNamed:@"yuleIcon"];
        }
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = kTitleColor;
        _titleLabel.text = self.tag == 0? @"竞技模式":@"娱乐模式";
    }
    return _titleLabel;
}
- (UILabel *)subtitleLabel
{
    if (_subtitleLabel == nil) {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [UIColor colorWithWhite:153/255.0 alpha:1];
        _subtitleLabel.font = [UIFont systemFontOfSize:10];
        _subtitleLabel.text = self.tag == 0? @"更专业的父子局":@"各种搞怪各种High";
    }
    return _subtitleLabel;
}
@end
