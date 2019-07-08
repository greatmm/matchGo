//
//  KKMallItemCollectionViewCell.m
//  game
//
//  Created by GKK on 2018/9/6.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKMallItemCollectionViewCell.h"
#import "Masonry.h"
@implementation KKMallItemCollectionViewCell
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(20);
        make.centerX.mas_equalTo(self);
        make.width.height.mas_equalTo(44);
    }];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imgView.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self);
    }];
}
-(UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorWithWhite:126/255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.text = @"打卡签名";
    }
    return _titleLabel;
}
@end
