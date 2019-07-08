//
//  KKFreeMatchChoiceView.m
//  game
//
//  Created by greatkk on 2019/1/15.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKFreeMatchChoiceView.h"

@implementation KKFreeMatchChoiceView
- (id)initWithDelegate:(id<HNUBZChoiceViewDelegate>)delegate
{
    if (self=[self initWithDeault:@[@"我的邀请",@"奖励规则",@"排行榜"] frame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*214/375 + 21 + W(44)) delegate:delegate]) {
        [self insertSubview:self.topView atIndex:0];
    }
    return self;
}
- (id)initWithDeault:(NSArray *)titles frame:(CGRect)frame delegate:(id<HNUBZChoiceViewDelegate>)delegate
{
    if (self=[self initWithFrame:frame]) {
        self.delegate = delegate;
        [self addDefaultSelectView:titles];
    }
    return self;
}
- (void)addDefaultSelectView:(NSArray *)titles
{
    if (self.selectView == nil) {
        self.selectView = [[HNUSelectView alloc] initWithTitles:titles titleColor:[UIColor colorWithWhite:153/255.0 alpha:1.0] bgColor:[UIColor colorWithWhite:252/255.0 alpha:1] selectColor:[UIColor colorWithRed:16/255.0 green:29/255.0 blue:5/255.0 alpha:1] selectBgColor:[UIColor whiteColor]];
        self.selectView.frame=CGRectMake(0, self.height-W(44), kScreenWidth, W(44));
        ((HNUSelectView *)self.selectView).delegate = self.delegate;
        self.selectView.lineView.hidden = true;
        self.selectView.viewBG.hidden = true;
        [self addSubview:self.selectView];
        [self.arrayTouchControl addObject:self.selectView];

        //        [((HNUSelectView *)_selectView) addLineWithColor:MTK16RGBCOLOR(0xDDDADA)];
    }
}
-(UIView *)topView
{
    if (_topView) {
        return _topView;
    }
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*214/375 + 21)];
    _topView.backgroundColor = [UIColor whiteColor];
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myInviteBanner"]];
    imgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*214/375);
    [_topView addSubview:imgView];
    UIView * backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(16, ScreenWidth * 139/375, ScreenWidth - 32, ScreenWidth * 75/375 + 21);
    [_topView addSubview:backView];
    self.inviteCountLabel = [UILabel new];
    self.inviteCountLabel.text = @"";
    self.inviteCountLabel.textColor = kTitleColor;
    self.inviteCountLabel.font = [UIFont fontWithName:@"bahnschrift" size:32];
    self.inviteCountLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.inviteCountLabel];
    [self.inviteCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backView).offset(-7);
        make.width.mas_equalTo(CGRectGetWidth(backView.bounds) * 0.5);
        make.left.mas_equalTo(backView);
    }];
    UILabel * l = [UILabel new];
    l.textColor = k153Color;
    l.font = [UIFont systemFontOfSize:12];
    l.text = @"成功邀请(人)";
    [backView addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.inviteCountLabel);
        make.top.mas_equalTo(self.inviteCountLabel.mas_bottom).offset(0);
    }];
    self.ticketLabel = [UILabel new];
    self.ticketLabel.text = @"";
    self.ticketLabel.textColor = kTitleColor;
    self.ticketLabel.font = [UIFont fontWithName:@"bahnschrift" size:32];
    self.ticketLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.ticketLabel];
    [self.ticketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backView).offset(-7);
        make.width.mas_equalTo(CGRectGetWidth(backView.bounds) * 0.5);
        make.right.mas_equalTo(backView);
    }];
    UILabel * l1 = [UILabel new];
    l1.textColor = k153Color;
    l1.font = [UIFont systemFontOfSize:12];
    l1.text = @"累计入场券(张)";
    [backView addSubview:l1];
    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ticketLabel);
        make.top.mas_equalTo(self.ticketLabel.mas_bottom).offset(0);
    }];
    return _topView;
}
-(UIView *)moreView
{
    if (_moreView) {
        return _moreView;
    }
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenWidth*214/375 + 21 + W(44), kScreenWidth, W(44))];
    _moreView.hidden=true;
    _moreView.backgroundColor = [UIColor whiteColor];
    UILabel * l = [UILabel new];
    l.text = @"排行";
    l.font = [UIFont systemFontOfSize:11];
    l.textColor = kTitleColor;
    l.textAlignment = NSTextAlignmentCenter;
    [_moreView addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_moreView);
        make.left.mas_equalTo(self->_moreView);
        make.width.mas_equalTo(54);
    }];
    UILabel * l1 = [UILabel new];
    l1.text = @"昵称";
    l1.font = [UIFont systemFontOfSize:11];
    l1.textColor = kTitleColor;
    [_moreView addSubview:l1];
    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_moreView);
        make.left.mas_equalTo(self->_moreView).offset(86);
    }];
    UILabel * l3 = [UILabel new];
    l3.text = @"邀请人数";
    l3.textAlignment = NSTextAlignmentCenter;
    l3.font = [UIFont systemFontOfSize:11];
    l3.textColor = kTitleColor;
    [_moreView addSubview:l3];
    [l3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_moreView);
        make.right.mas_equalTo(self->_moreView);
        make.width.mas_equalTo(76);
    }];
    UILabel * l2 = [UILabel new];
    l2.text = @"已获奖励";
    l2.font = [UIFont systemFontOfSize:12];
    l2.textColor = kTitleColor;
    l2.textAlignment = NSTextAlignmentCenter;
    [_moreView addSubview:l2];
    [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_moreView);
        make.left.mas_equalTo(self->_moreView).offset(ScreenWidth * 0.5);
        make.right.mas_equalTo(l3.mas_left);
    }];
    [self addSubview:_moreView];
    return _moreView;
}
- (void)resetAllInfo
{
    [super resetAllInfo];
    
}
//- (float)fSelectHeight
//{
//
//    if (self.selectView.index==1) {
//        _moreView.hidden=false;
//        self.height=kScreenWidth+46+_moreView.height;
//        return kNavigationAllHeight+_moreView.height;
//    }
//    _moreView.hidden=true;
//    self.height=kScreenWidth+46;
//    return kNavigationAllHeight;
//}
- (void)uploadInfo
{
    if (self.selectView.index==2) {
        if (_moreView == nil) {
            self.moreView.height = W(44);
        }
        self.moreView.hidden=false;
        self.height=kScreenWidth*214/375 + 21 + W(44)+_moreView.height;
        self.fSelectHeight= kNavigationAllHeight+_moreView.height;
    }
    else
    {
        _moreView.hidden = true;
        self.height = kScreenWidth*214/375 + 21 + W(44);
        self.fSelectHeight= kNavigationAllHeight;
    }
}
@end
