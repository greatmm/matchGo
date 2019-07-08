//
//  KKChampionRankinglistHeadView.m
//  game
//
//  Created by linsheng on 2019/1/16.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionRankinglistHeadView.h"
@interface KKChampionRankinglistHeadView()
@property (nonatomic, strong) UILabel *labelTitleAmount;
@end
@implementation KKChampionRankinglistHeadView

- (id)init
{
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, kScreenWidth, 44);
        self.backgroundColor = [UIColor whiteColor];
        [self addViews];
        
    }
    return self;
}
- (void)addViews
{
    UILabel * l = [UILabel new];
    l.text = @"排名";
    l.font = [UIFont systemFontOfSize:12];
    l.textColor = kTitleColor;
    [self addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
    }];
    UILabel * l1 = [UILabel new];
    l1.text = @"玩家";
    l1.font = [UIFont systemFontOfSize:12];
    l1.textColor = kTitleColor;
    [self addSubview:l1];
    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(85);
    }];
    UILabel * l2 = [UILabel new];
    l2.text = @"胜利次数";
    _labelTitleAmount=l2;
    l2.font = [UIFont systemFontOfSize:12];
    l2.textColor = kTitleColor;
    [self addSubview:l2];
    [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(ScreenWidth * 0.5 + 25);
    }];
    UILabel * l3 = [UILabel new];
    l3.text = @"获得金币";
    l3.font = [UIFont systemFontOfSize:12];
    l3.textColor = kTitleColor;
    [self addSubview:l3];
    [l3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-15);
    }];
}
- (void)setType:(KKChampionshipsType)type
{
    if (type==KKChampionshipsTypeLadder) {
        _labelTitleAmount.text=@"累计得分";
    }
    else _labelTitleAmount.text=@"胜利次数";
}
@end
