//
//  KKSelectPaytypeView.m
//  game
//
//  Created by greatkk on 2019/1/8.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKSelectPaytypeView.h"

@implementation KKSelectPaytypeView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubView];
        [self addTarget:self action:@selector(clickSelControl) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)clickSelControl
{
    if (self.selectImgView.highlighted) {
        return;
    }
    self.selectImgView.highlighted = YES;
    if (self.clickBlock) {
        self.clickBlock();
    }
}
- (void)initSubView
{
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
    [self addSubview:self.selectImgView];
}
-(UIImageView *)imageView
{
    if (_imageView) {
        return _imageView;
    }
    _imageView = [UIImageView new];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(22);
    }];
    return _imageView;
}
-(UILabel *)textLabel
{
    if (_textLabel) {
        return _textLabel;
    }
    _textLabel = [UILabel new];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = kTitleColor;
    [self addSubview:_textLabel];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.imageView.mas_right).offset(8);
    }];
    return _textLabel;
}
- (UIImageView *)selectImgView
{
    if (_selectImgView) {
        return _selectImgView;
    }
    _selectImgView = [UIImageView new];
    _selectImgView.image = [UIImage imageNamed:@"checkBoxNormal"];
    _selectImgView.highlightedImage = [UIImage imageNamed:@"checkBoxSel"];
    [self addSubview:_selectImgView];
    [_selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(16);
    }];
    return _selectImgView;
}
@end
