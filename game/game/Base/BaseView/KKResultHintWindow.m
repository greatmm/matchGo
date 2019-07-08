//
//  KKResultHintWindow.m
//  game
//
//  Created by greatkk on 2018/12/4.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKResultHintWindow.h"

@interface KKResultHintWindow ()
@property (strong,nonatomic) UIImageView * backImgView;//背景图
@property (strong,nonatomic) UIImageView * gameIcon;//游戏图标
@property (strong,nonatomic) UILabel * titleLabel;//标题
@property (strong,nonatomic) UILabel * resultLabel;//结果label
@property (strong,nonatomic) UILabel * goldLabel;//输赢多少金币
@end
@implementation KKResultHintWindow

-(UIImageView *)backImgView
{
    if (_backImgView) {
        return _backImgView;
    }
    _backImgView = [UIImageView new];
    _backImgView.frame = CGRectMake(0, 0, ScreenWidth - 16, kSmallHouseHeight);
    [self addSubview:_backImgView];
//    [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.left.right.mas_equalTo(self);
//    }];
    return _backImgView;
}
-(UIImageView *)gameIcon
{
    if (_gameIcon) {
        return _gameIcon;
    }
    _gameIcon = [UIImageView new];
    _gameIcon.frame = CGRectMake(10, 10, 36, 36);
    [self addSubview:_gameIcon];
//    [_gameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self).offset(10);
//        make.centerY.mas_equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(36, 36));
//    }];
    _gameIcon.layer.cornerRadius = 6;
    _gameIcon.layer.masksToBounds = YES;
    return _gameIcon;
}
-(UILabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:10];
    _titleLabel.textColor = [UIColor colorWithWhite:153/255.0 alpha:1];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameIcon.mas_right).offset(8);
        make.bottom.mas_equalTo(self.gameIcon);
    }];
    return _titleLabel;
}
-(UILabel *)resultLabel
{
    if (_resultLabel) {
        return _resultLabel;
    }
    _resultLabel = [UILabel new];
    _resultLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_resultLabel];
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameIcon.mas_right).offset(8);
        make.top.mas_equalTo(self.gameIcon);
    }];
    return _resultLabel;
}
-(UILabel *)goldLabel
{
    if (_goldLabel) {
        return _goldLabel;
    }
    _goldLabel = [UILabel new];
    _goldLabel.textColor = [UIColor colorWithWhite:153/255.0 alpha:1.0];
    _goldLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:_goldLabel];
    return _goldLabel;
}
-(void)setResultDic:(NSDictionary *)resultDic
{
    _resultDic = resultDic;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    NSNumber * result = _resultDic[@"result"];
    NSInteger r = result.integerValue;
    switch (r) {
        case 2:
        {
            //失败
            self.backImgView.image = [UIImage imageNamed:@"result_lose"];
            self.resultLabel.text = @"遗憾惜败";
            self.resultLabel.textColor = kTitleColor;
        }
            break;
        case 4:
        {
            //流局
            self.backImgView.image = [UIImage imageNamed:@"result_liuju"];
            self.resultLabel.text = @"流局";
            self.resultLabel.textColor = [UIColor colorWithWhite:102/255.0 alpha:1];
            self.goldLabel.text = @"金币已退回";
        }
            break;
        default:
        {
            self.backImgView.image = [UIImage imageNamed:@"result_win"];
            self.resultLabel.text = @"恭喜获胜";
            self.resultLabel.textColor = kThemeColor;
            NSString * string = [NSString stringWithFormat:@"+%@",_resultDic[@"award"]];
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Bahnschrift" size:14],NSForegroundColorAttributeName:kThemeColor} range:NSMakeRange(0, string.length)];
            NSTextAttachment * attchment = [NSTextAttachment new];
            attchment.bounds = CGRectMake(0, 0, 12, 12);
            attchment.image = [UIImage imageNamed:@"coin"];
            NSAttributedString * s = [NSAttributedString attributedStringWithAttachment:attchment];
            [str appendAttributedString:s];
            self.goldLabel.attributedText = str;
        }
            break;
    }
    NSArray * gameIconImgs = @[@"PUBGIcon",@"GKIcon",@"ZCIcon",@"LOLIcon"];
    NSNumber * gameId = _resultDic[@"game"];
    if (gameId.integerValue > 0 && gameId.integerValue < 5) {
        self.gameIcon.image = [UIImage imageNamed:gameIconImgs[gameId.integerValue - 1]];
    }
    NSString * titleStr = _resultDic[@"title"];
    self.titleLabel.text = titleStr;
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"closeSmall"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(ScreenWidth - 16 - 40, 13, 30, 30);
    [self addSubview:closeBtn];
    [_goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(closeBtn);
        make.right.mas_equalTo(closeBtn.mas_left).offset(-10);
    }];
//    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self).offset(-10);
//        make.centerY.mas_equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
}
-(void)setEndDic:(NSDictionary *)endDic
{
    //{"id":%d,"name":%s,"win_user":%d,"user_total":%d,"win_match":%d,"match_total":%d}
    _endDic = endDic;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.backImgView.image = [UIImage imageNamed:@"result_liuju"];
    self.resultLabel.text = @"锦标赛已结束";
    self.resultLabel.textColor = kThemeColor;
    self.goldLabel.text = @"查看";
    self.goldLabel.textColor = kThemeColor;
    if (_beginDic[@"name"]) {
        self.titleLabel.text = _endDic[@"name"];
    } else {
        self.titleLabel.text = @"  ";
    }
    NSArray * gameIconImgs = @[@"PUBGIcon",@"GKIcon",@"ZCIcon",@"LOLIcon"];
    NSNumber * gameId = _endDic[@"game"];
    if (gameId.integerValue > 0 && gameId.integerValue < 5) {
        self.gameIcon.image = [UIImage imageNamed:gameIconImgs[gameId.integerValue - 1]];
    }
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"closeSmall"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(ScreenWidth - 16 - 40, 13, 30, 30);
    [self addSubview:closeBtn];
    [_goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(closeBtn);
        make.right.mas_equalTo(closeBtn.mas_left).offset(-10);
    }];
}
-(void)setBeginDic:(NSDictionary *)beginDic
{
    _beginDic = beginDic;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.backImgView.image = [UIImage imageNamed:@"result_liuju"];
    self.resultLabel.text = @"锦标赛已开始";
    self.resultLabel.textColor = kThemeColor;
    self.goldLabel.text = @"立即比赛";
    self.goldLabel.textColor = kThemeColor;
    if (_beginDic[@"name"]) {
        self.titleLabel.text = _beginDic[@"name"];
    } else {
        self.titleLabel.text = @"  ";
    }
    NSArray * gameIconImgs = @[@"PUBGIcon",@"GKIcon",@"ZCIcon",@"LOLIcon"];
    NSNumber * gameId = _beginDic[@"game"];
    if (gameId.integerValue > 0 && gameId.integerValue < 5) {
        self.gameIcon.image = [UIImage imageNamed:gameIconImgs[gameId.integerValue - 1]];
    }
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"closeSmall"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(ScreenWidth - 16 - 40, 13, 30, 30);
    [self addSubview:closeBtn];
    [_goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(closeBtn);
        make.right.mas_equalTo(closeBtn.mas_left).offset(-10);
    }];
//    {"id":%d,"name":%s,"start":%d,"end":%d}
}
- (void)clickCloseBtn
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}
@end
