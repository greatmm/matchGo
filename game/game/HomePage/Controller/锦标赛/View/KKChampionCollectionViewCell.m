//
//  KKChampionCollectionViewCell.m
//  game
//
//  Created by greatkk on 2018/12/27.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKChampionCollectionViewCell.h"

@interface KKChampionCollectionViewCell ()
@property (strong,nonatomic) UIImageView * gameIcon;//游戏图标
@property (strong,nonatomic) UILabel * matchTitleLabel;//锦标赛名称
@property (strong,nonatomic) UIImageView * matchBackImageView;//锦标赛背景大图
@property (strong,nonatomic) UILabel * dateLabel;//锦标赛开始结束时间
@property (strong,nonatomic) UILabel * awardLabel;//锦标赛总奖励
@property (strong,nonatomic) UIImageView * clockIcon;//闹钟图标
@property (strong,nonatomic) UIImageView * goldIcon;//金币图标
@property (strong,nonatomic) UIImageView * stateImageView;//锦标赛状态图标，比赛中，报名中，已结束
@end
@implementation KKChampionCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.matchBackImageView];
        [self.contentView addSubview:self.gameIcon];
        [self.contentView addSubview:self.matchTitleLabel];
        [self.contentView addSubview:self.clockIcon];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.goldIcon];
        [self.contentView addSubview:self.awardLabel];
        [self.contentView addSubview:self.stateImageView];
        [self layoutIfNeeded];
    }
    return self;
}
-(void)assignWithItem:(KKChampionListModel *)item
{
    [self.matchBackImageView sd_setImageWithURL:[NSURL URLWithString:item.banner] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    NSInteger startTime = item.starttime.integerValue;
    NSInteger endTime = item.endtime.integerValue;
    if (startTime == 0 || endTime == 0) {
        self.dateLabel.text = @"";
    }
    NSInteger todayLastTime = [KKDataTool timeStampFromDate:[self todayZero]] + 24 * 3600 - 1;//今天的时间戳
    NSInteger nowTime = [[KKDataTool shareTools] getDateStamp];//当前时间戳
    NSString * sub = self.isBig?@"Big":@"Small";
    NSString * su;
    if (nowTime > endTime) {
        //现在已经结束
        su = @"championEnd";
        self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",[KKDataTool timeStrWithTimeStamp:startTime],[KKDataTool timeStrWithTimeStamp:endTime]];
    } else if (todayLastTime < startTime) {
        //明天或之后开始,暂时只算明天，计算时分
        //未开始
        su = @"championBeign";
        self.dateLabel.text = [KKDataTool timeStrWithTimeStamp:startTime withTimeFormate:@"明天HH:mm开始"];
    } else  {
      //没有结束，今天24点之前开始
        if (nowTime < startTime) {
            //当前尚未开始
            su = @"championBeign";
            self.dateLabel.text = [self dateStrWithTimeStamp:startTime - nowTime];
        } else {
            //进行中
            self.dateLabel.text = @"已开始";
            su = @"championGoing";
        }
    }
//    NSInteger stauts = item.status.integerValue;
//    if (stauts == 1) {
//        //未开始
//        su = @"championBeign";
//    } else if (stauts == 2) {
//        //进行中
//        su = @"championGoing";
//    } else if (stauts == 3) {
//        //已结束
//        su = @"championEnd";
//    }
    self.stateImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",su,sub]];
    self.gameIcon.image = [KKDataTool gameIconWithGameId:item.game.integerValue];
    self.matchTitleLabel.text = item.name;
    if (self.isBig) {
        self.clockIcon.image = [UIImage imageNamed:@"clockBlack"];
        self.goldIcon.image = [UIImage imageNamed:@"goldBlack"];
    }
    
//    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",[KKDataTool timeStrWithTimeStamp:item.starttime.integerValue],[KKDataTool timeStrWithTimeStamp:item.endtime.integerValue]];
    self.awardLabel.text = [NSString stringWithFormat:@"%@",item.showaward_total];
}
- (NSDate *)todayZero
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSDate *zeroDate = [calendar dateFromComponents:components];
    return zeroDate;
}
- (NSString *)dateStrWithTimeStamp:(NSInteger)seconds
{
//    NSInteger d = seconds/(60 * 60 * 24);//几天
    NSInteger t = seconds%(60 * 60 * 24);
    NSInteger h = t/(60 * 60);//几小时
    t = t%(60 * 60);
    NSInteger m = t/60;//几分钟
//    NSInteger s = t%60;//秒数
    if (h > 0) {
        return [NSString stringWithFormat:@"还有%ld小时%ld分钟",(long)h,(long)m];
    }
    return [NSString stringWithFormat:@"还有%ld分钟",(long)m];
}

- (void)setIsBig:(BOOL)isBig
{
    if (_isBig == isBig) {
        return;
    }
    _isBig = isBig;
    if (_isBig) {
        self.matchTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        self.dateLabel.textColor = kTitleColor;
        self.awardLabel.font = [UIFont systemFontOfSize:12];
        self.awardLabel.textColor = kTitleColor;
        self.matchBackImageView.layer.cornerRadius = 5;
        [self updateBigConstraints];
        [self layoutIfNeeded];
    } else {
        self.matchTitleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.dateLabel.font = [UIFont systemFontOfSize:10];
        self.awardLabel.font = [UIFont systemFontOfSize:10];
    }
}
//更新到大的布局
- (void)updateBigConstraints
{
    [self.gameIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(8);
        make.left.mas_equalTo(self.contentView).offset(16);
        make.width.height.mas_equalTo(24);
    }];
    [self.matchTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.gameIcon);
        make.left.mas_equalTo(self.gameIcon.mas_right).offset(8);
    }];
    [self.matchBackImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(16);
        make.right.mas_equalTo(self.contentView).offset(-16);
        make.top.mas_equalTo(self.gameIcon.mas_bottom).offset(8);
        make.height.mas_equalTo((CGRectGetWidth(self.bounds) - 32) * 153/343);
    }];
    [self.stateImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.matchBackImageView);
        make.width.height.mas_equalTo(64);
    }];
    [self.clockIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.matchBackImageView.mas_bottom).offset(7);
        make.left.mas_equalTo(self.matchBackImageView);
        make.width.height.mas_equalTo(10);
    }];
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.clockIcon);
        make.left.mas_equalTo(self.clockIcon.mas_right).offset(10);
    }];
    [self.awardLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.matchBackImageView);
        make.centerY.mas_equalTo(self.clockIcon);
    }];
    [self.goldIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.awardLabel.mas_left).offset(-6);
        make.centerY.mas_equalTo(self.clockIcon);
        make.width.height.mas_equalTo(8);
    }];
}
-(UIImageView *)matchBackImageView
{
    if (_matchBackImageView) {
        return _matchBackImageView;
    }
    _matchBackImageView = [UIImageView new];
    _matchBackImageView.backgroundColor = kBackgroundColor;
//    _matchBackImageView.contentMode = UIViewContentModeScaleAspectFit;
    _matchBackImageView.layer.cornerRadius = 2;
    _matchBackImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_matchBackImageView];
    [_matchBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(CGRectGetWidth(self.contentView.bounds) * 74/166);
    }];
    return _matchBackImageView;
}
-(UIImageView *)gameIcon
{
    if (_gameIcon) {
        return _gameIcon;
    }
    _gameIcon = [UIImageView new];
    _gameIcon.layer.cornerRadius = 2;
    _gameIcon.layer.masksToBounds = YES;
    [self.contentView addSubview:_gameIcon];
    [_gameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.matchBackImageView.mas_bottom).offset(4);
        make.left.mas_equalTo(self.matchBackImageView);
        make.width.height.mas_equalTo(24);
    }];
    return _gameIcon;
}
- (UILabel *)matchTitleLabel
{
    if (_matchTitleLabel) {
        return _matchTitleLabel;
    }
    _matchTitleLabel = [UILabel new];
    _matchTitleLabel.textColor = kTitleColor;
    _matchTitleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_matchTitleLabel];
    [_matchTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.gameIcon);
        make.left.mas_equalTo(self.gameIcon.mas_right).offset(4);
    }];
    return _matchTitleLabel;
}
-(UIImageView *)clockIcon
{
    if (_clockIcon) {
        return _clockIcon;
    }
    _clockIcon = [UIImageView new];
    _clockIcon.image = [UIImage imageNamed:@"clockGray"];
    [self.contentView addSubview:_clockIcon];
    [_clockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameIcon);
        make.top.mas_equalTo(self.gameIcon.mas_bottom).offset(7);
        make.width.height.mas_equalTo(8);
    }];
    return _clockIcon;
}
-(UILabel *)dateLabel
{
    if (_dateLabel) {
        return _dateLabel;
    }
    _dateLabel = [UILabel new];
    _dateLabel.text = @"";
    _dateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _dateLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.clockIcon);
        make.left.mas_equalTo(self.clockIcon.mas_right).offset(4);
    }];
    return _dateLabel;
}
-(UIImageView *)goldIcon
{
    if (_goldIcon) {
        return _goldIcon;
    }
    _goldIcon = [UIImageView new];
    _goldIcon.image = [UIImage imageNamed:@"goldGray"];
    [self.contentView addSubview:_goldIcon];
    [_goldIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameIcon);
        make.top.mas_equalTo(self.clockIcon.mas_bottom).offset(10);
        make.width.height.mas_equalTo(8);
    }];
    return _goldIcon;
}
-(UILabel *)awardLabel
{
    if (_awardLabel) {
        return _awardLabel;
    }
    _awardLabel = [UILabel new];
    _awardLabel.text = @"";
    _awardLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _awardLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_awardLabel];
    [_awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dateLabel);
        make.centerY.mas_equalTo(self.goldIcon);
    }];
    return _awardLabel;
}
-(UIImageView *)stateImageView
{
    if (_stateImageView) {
        return _stateImageView;
    }
    _stateImageView = [UIImageView new];
    _stateImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_stateImageView];
    [_stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.matchBackImageView);
        make.width.height.mas_equalTo(40);
    }];
    return _stateImageView;
}
@end
