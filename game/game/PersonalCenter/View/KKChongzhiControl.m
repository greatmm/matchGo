//
//  KKChongzhiControl.m
//  game
//
//  Created by GKK on 2018/8/24.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKChongzhiControl.h"
#import "Masonry.h"
@interface KKChongzhiControl()
@property (nonatomic,strong) UILabel * coinLabel;
@property (nonatomic,strong) UILabel * priceLabel;
@property (strong,nonatomic) UIImageView * icon;//钻石还是金币图片
@end
@implementation KKChongzhiControl
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.coinLabel];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).offset(-10);
        make.top.mas_equalTo(self).offset(10);
    }];
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coinLabel.mas_right);
        make.centerY.mas_equalTo(self.coinLabel);
        make.width.height.mas_equalTo(18);
    }];
    [self addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.coinLabel.mas_bottom).offset(4);
    }];
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
        self.coinLabel.text = _dataDic[@"coin"];
        self.priceLabel.text = _dataDic[@"price"];
        self.selected = NO;
        if ([self.priceLabel.text containsString:@"钻"]) {
            self.icon.image = [UIImage imageNamed:@"coin_big"];
        } else {
            self.icon.image = [UIImage imageNamed:@"zuan"];
        }
    }
}
-(UILabel *)coinLabel
{
    if (_coinLabel == nil) {
        _coinLabel = [UILabel new];
        _coinLabel.font = [UIFont boldSystemFontOfSize:24];
        _coinLabel.textColor = kTitleColor;
    }
    return _coinLabel;
}
-(UILabel *)priceLabel
{
    if (_priceLabel == nil) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont boldSystemFontOfSize:10];
        _priceLabel.textColor = kTitleColor;
    }
    return _priceLabel;
}
-(UIImageView *)icon
{
    if (_icon) {
        return _icon;
    }
    _icon = [UIImageView new];
    _icon.contentMode = UIViewContentModeScaleAspectFit;
    return _icon;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.priceLabel.textColor = [UIColor whiteColor];
        self.coinLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = kThemeColor;
        self.layer.borderWidth = 0;
    } else {
        self.priceLabel.textColor = kThemeColor;
        self.coinLabel.textColor = kThemeColor;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
    }
}
@end
