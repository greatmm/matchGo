//
//  KKUpdownBtn.m
//  game
//
//  Created by GKK on 2018/10/23.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKUpdownBtn.h"

@interface KKUpdownBtn ()

@end
@implementation KKUpdownBtn
-(UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:11];
        _textLabel.textColor = [UIColor whiteColor];
        [self addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
        }];
    }
    return _textLabel;
}
- (UILabel *)numberLabel
{
    if (_numberLabel == nil) {
        _numberLabel = [UILabel new];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont fontWithName:@"bahnschrift" size:18];
        [self addSubview:_numberLabel];
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.textLabel.mas_top).offset(-2);
            make.centerX.mas_equalTo(self);
        }];
    }
    return _numberLabel;
}
//- (UILabel *)hintLabel
//{
//    if (_hintLabel == nil) {
//        _hintLabel = [UILabel new];
//        _hintLabel.textColor = [UIColor whiteColor];
//        _hintLabel.font = [UIFont systemFontOfSize:8];
//        _hintLabel.textAlignment = NSTextAlignmentCenter;
//        _hintLabel.layer.cornerRadius = 2;
//        _hintLabel.layer.masksToBounds = YES;
//        [self addSubview:_hintLabel];
//        [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.mas_centerX).offset(2);
//            make.bottom.mas_equalTo(self.numberLabel.mas_top);
//            make.width.mas_equalTo(38);
//            make.height.mas_equalTo(14);
//        }];
//    }
//    return _hintLabel;
//}
@end
