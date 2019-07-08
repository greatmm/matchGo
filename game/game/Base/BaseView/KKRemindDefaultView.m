//
//  KKRemindDefaultView.m
//  game
//
//  Created by linsheng on 2018/12/25.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKRemindDefaultView.h"
@interface KKRemindDefaultView()
@property (nonatomic ,strong) UIImageView *imagevDefault;
@property (nonatomic ,strong) UILabel *labelMain;
@property (nonatomic ,strong) UIButton *buttonMain;
@end
@implementation KKRemindDefaultView

- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.imagevDefault];
        [self addSubview:self.labelMain];
        [self addSubview:self.buttonMain];
        [self setConstraints];
    }
    return self;
}
- (id)init
{
    if (self=[super init]) {
        [self addSubview:self.imagevDefault];
        [self addSubview:self.labelMain];
        [self addSubview:self.buttonMain];
        [self setConstraints];
    }
    return self;
}
#pragma mark set/get
- (UIImageView *)imagevDefault
{
    if (!_imagevDefault) {
        _imagevDefault=[[UIImageView alloc] initWithFrame:CGRectZero];
        
        _imagevDefault.image=MTKImageNamed(@"noTop");
    }
    return _imagevDefault;
}
- (UILabel *)labelMain
{
    if (!_labelMain) {
        _labelMain=[[UILabel alloc] initWithText:@"暂无数据" color:[UIColor grayColor] fontSize:15 forFrame:CGRectZero];
        _labelMain.textAlignment=NSTextAlignmentCenter;
    }
    return _labelMain;
}
- (UIButton *)buttonMain
{
    if (!_buttonMain) {
        _buttonMain=[UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonMain addTarget:self action:@selector(touchWithButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonMain;
}
#pragma mark constraints
- (void)setConstraints
{
    hnuSetWeakSelf;
    [_imagevDefault mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY).offset(-W(150));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.height.mas_equalTo(101);
        make.width.mas_equalTo(114);
        
        
    }];
    [_labelMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY).offset(-W(80));
        make.height.mas_equalTo(50);
        make.width.equalTo(weakSelf.mas_width);
        make.left.mas_equalTo(0);
    }];
    [_buttonMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY).offset(0);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(83);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
}
- (void)resetToNeedLoginView
{
    _labelMain.text=@"您还未登录，请登录后查看更多";
    _imagevDefault.image=MTKImageNamed(@"loginIcon");
    [_buttonMain setTitle:@"登录" forState:UIControlStateNormal];
    _buttonMain.hidden=false;
    [_buttonMain setBackgroundColor:MTK16RGBCOLOR(0x29C29E)];
    hnuSetWeakSelf;
    self.backgroundColor=[UIColor whiteColor];
    [_imagevDefault mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY).offset(-W(150));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.height.mas_equalTo(105);
        make.width.mas_equalTo(140);
        
        
    }];
//    [_labelMain mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.mas_centerY).offset(-W(80));
//        make.height.mas_equalTo(50);
//        make.width.equalTo(weakSelf.mas_width);
//        make.left.mas_equalTo(0);
//    }];
//    [_buttonMain mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.mas_centerY).offset(50);
//        make.height.mas_equalTo(50);
//        make.width.mas_equalTo(100);
//        make.centerX.equalTo(weakSelf.mas_centerX);
//    }];
}
#pragma mark Method
- (void)touchWithButton:(UIButton *)button
{
    if (_remindDefaultViewButtonBlock) {
        _remindDefaultViewButtonBlock(_buttonMain.titleLabel.text);
    }
}
@end
