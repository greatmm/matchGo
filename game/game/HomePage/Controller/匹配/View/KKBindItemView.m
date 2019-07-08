//
//  KKBindItemView.m
//  game
//
//  Created by greatkk on 2019/1/8.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKBindItemView.h"

@implementation KKBindItemView
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initSubView];
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView
{
    UIView * dotView = [UIView new];
    [self addSubview:dotView];
    dotView.backgroundColor = kThemeColor;
    dotView.layer.cornerRadius = 3;
    dotView.layer.masksToBounds = true;
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(10);
        make.width.height.mas_equalTo(6);
    }];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.contentLabel];
}
-(UILabel *)tipsLabel
{
    if (_tipsLabel) {
        return _tipsLabel;
    }
    _tipsLabel = [UILabel new];
    _tipsLabel.text = @"设备";
    _tipsLabel.font = [UIFont systemFontOfSize:13];
    _tipsLabel.textColor = [UIColor colorWithWhite:153/255.0 alpha:1];
    [self addSubview:_tipsLabel];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(26);
        make.width.mas_equalTo(48);
    }];
    return _tipsLabel;
}
-(UILabel *)contentLabel
{
    if (_contentLabel) {
        return _contentLabel;
    }
    _contentLabel = [UILabel new];
    _contentLabel.textColor = kTitleColor;
    _contentLabel.font = [UIFont boldSystemFontOfSize:13];
    _contentLabel.text = @"安卓";
    [self addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipsLabel.mas_right).offset(12);
        make.centerY.mas_equalTo(self);
    }];
    return _contentLabel;
}
@end
