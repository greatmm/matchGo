//
//  KKPartedHomeControl.m
//  game
//
//  Created by GKK on 2018/10/11.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKPartedHomeControl.h"
@interface KKPartedHomeControl()

@end
@implementation KKPartedHomeControl
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(16);
        make.width.height.mas_equalTo(18);
    }];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.imgView.mas_right).offset(10);
        make.right.mas_equalTo(self).offset(-5);
    }];
}
-(UIImageView *)imgView
{
    if (_imgView == nil) {
        _imgView = [UIImageView new];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"KDA最高";
        _titleLabel.textColor = kTitleColor;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _titleLabel;
}
- (UILabel *)hintLabel
{
    if (_hintLabel == nil) {
        _hintLabel = [UILabel new];
        _hintLabel.text = @" 热门 ";
        _hintLabel.textColor = [UIColor whiteColor];
        _hintLabel.font = [UIFont systemFontOfSize:8];
        _hintLabel.layer.cornerRadius = 3;
        _hintLabel.layer.masksToBounds = YES;
        [self addSubview:_hintLabel];
        [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(12);
        }];
    }
    return _hintLabel;
}
//-(UIImageView *)backImgView
//{
//    if (_backImgView) {
//        return _backImgView;
//    }
//    _backImgView = [UIImageView new];
//    self.imgView.hidden = YES;
//    self.titleLabel.hidden = YES;
//    [self addSubview:_backImgView];
//    [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.mas_equalTo(self);
//    }];
//    _backImgView.image = [UIImage imageNamed:@"chiceBack"];
//    return _backImgView;
//}
@end
