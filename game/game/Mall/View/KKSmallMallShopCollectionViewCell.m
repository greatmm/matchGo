//
//  KKSmallMallShopCollectionViewCell.m
//  game
//
//  Created by GKK on 2018/9/7.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKSmallMallShopCollectionViewCell.h"
#import "Masonry.h"
@implementation KKSmallMallShopCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgView];
        [self addSubview:self.desLabel];
        [self addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-10);
            make.centerX.mas_equalTo(self);
        }];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self.priceLabel.mas_top);
            
        }];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self.desLabel.mas_top).offset(-10);
        }];
    }
    return self;
}
-(void)setShowRight:(BOOL)showRight
{
    _showRight = showRight;
    if (_showRight) {
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-10);
            make.left.mas_equalTo(self);
        }];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.bottom.mas_equalTo(self.priceLabel.mas_top);
        }];
        self.desLabel.textAlignment = NSTextAlignmentLeft;
    }
}
-(UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [UIImageView new];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.image = [UIImage imageNamed:@"shopsmall"];
    }
    return _imgView;
}
-(UILabel *)desLabel
{
    if (_desLabel == nil) {
        _desLabel = [UILabel new];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.font = [UIFont boldSystemFontOfSize:12];
        _desLabel.textColor = [UIColor blackColor];
        _desLabel.numberOfLines = 0;
        _desLabel.text = @"鹿晗\n签名照片";
    }
    return _desLabel;
}
-(UILabel *)priceLabel
{
    if (_priceLabel == nil) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont boldSystemFontOfSize:14];
        _priceLabel.textColor = kOrangeColor;
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.text = @"45000";
    }
    return _priceLabel;
}
@end
