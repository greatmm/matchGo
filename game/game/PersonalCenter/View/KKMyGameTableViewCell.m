//
//  KKMyGameTableViewCell.m
//  game
//
//  Created by GKK on 2018/8/21.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKMyGameTableViewCell.h"
#import "Masonry.h"
@interface KKMyGameTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;//游戏图标
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;//未开始
@property (weak, nonatomic) IBOutlet UILabel * titleLabel;//KDA最高
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;//自由竞赛
@property (weak, nonatomic) IBOutlet UILabel *maxawardLabel;//最多可赢
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;//入场费

@property (nonatomic,strong) UIButton * rightBtn;//开始竞赛，提交战绩

@property (nonatomic,strong) UILabel * coinNumberLabel;//+100,钻石已退回

@end

@implementation KKMyGameTableViewCell

-(void)assignWithModel:(KKChampionSummaryModel *)model
{
    KKMyChampionModel * champion = model.championModel;
    self.feeLabel.text = @" ";
    if (champion) {
        NSNumber * game = champion.game;
        NSInteger g = game.integerValue;
        self.iconImageView.image = [KKDataTool gameIconWithGameId:g];
        NSNumber * t = champion.starttime;
        if (t && t.integerValue > 0) {
            NSDate * d = [NSDate dateWithTimeIntervalSince1970:t.integerValue];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
            [formatter setDateFormat:@"MM/dd HH:mm"];
            NSString* string = [formatter stringFromDate:d];
            self.dateLabel.text = string;
        } else {
            self.dateLabel.text = @" ";
        }
        self.matchLabel.hidden = YES;
        if (champion.name != nil) {
            self.titleLabel.text = champion.name;
        } else {
            self.titleLabel.text = @"  ";
        }
        NSNumber * stauts = champion.status;
        if (stauts.integerValue == 3) {
            self.stateLabel.text = @"已结束";
            NSNumber * award = model.award;
            if (award && award.integerValue > 0) {
                self.stateLabel.text = @"胜利";
                self.stateLabel.textColor = kThemeColor;
                NSString * str = [NSString stringWithFormat:@"+%@",award];
                NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttributes:@{NSForegroundColorAttributeName:kYellowColor,NSFontAttributeName:[UIFont systemFontOfSize:24]} range:NSMakeRange(0, str.length)];
                NSTextAttachment * attchment = [NSTextAttachment new];
                attchment.bounds = CGRectMake(0, 0, 17, 17);
                attchment.image = [UIImage imageNamed:@"coin"];
                NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attchment];
                [attr appendAttributedString:string];
                self.coinNumberLabel.backgroundColor = [UIColor whiteColor];
                self.coinNumberLabel.text = nil;
                self.coinNumberLabel.attributedText = attr;
            } else {
                self.stateLabel.text = @"惜败";
                self.stateLabel.textColor = kOrangeColor;
                self.coinNumberLabel.backgroundColor = [UIColor whiteColor];
                self.coinNumberLabel.attributedText = nil;
                self.coinNumberLabel.text = @"再接再厉";
                self.coinNumberLabel.font = [UIFont systemFontOfSize:12];
            }
        } else {
            self.stateLabel.text = @"进行中";
            self.stateLabel.textColor = kTitleColor;
            self.coinNumberLabel.attributedText = nil;
            self.coinNumberLabel.backgroundColor = kThemeColor;
            self.coinNumberLabel.layer.cornerRadius = 15;
            self.coinNumberLabel.layer.masksToBounds = YES;
            self.coinNumberLabel.textColor = [UIColor whiteColor];
            self.coinNumberLabel.text = @"  进入房间  ";
        }
        NSString * str = @"挑战";
        NSString * value = champion.value;
        if (value) {
            str = [NSString stringWithFormat:@"%@%@",str,value];
        }
        NSString * choice = champion.choice;
        if (choice) {
            str = [NSString stringWithFormat:@"%@%@",str,choice];
        }
        self.maxawardLabel.text = str;
    }
}
-(void)assignWithItem:(KKRoomItem *)item
{
    NSNumber * t = item.starttime;
    if (t && t.integerValue > 0) {
        NSDate * d = [NSDate dateWithTimeIntervalSince1970:t.integerValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [formatter setDateFormat:@"MM/dd HH:mm"];
        NSString* string = [formatter stringFromDate:d];
        self.dateLabel.text = string;
    } else {
        self.dateLabel.text = @"  ";
    }
    if (item.name.length) {
        self.titleLabel.text = item.name;
    } else {
        self.titleLabel.text = @" ";
    }
    self.coinNumberLabel.text = item.awardmax.stringValue;
    NSNumber * game = item.game;
    NSInteger g = game.integerValue;
    self.iconImageView.image = [KKDataTool gameIconWithGameId:g];
    NSInteger m = item.matchtype.integerValue;
    if (m == 2) {
        self.matchLabel.text = @"1V1单挑";
    } else if (m == 3) {
       self.matchLabel.text = @"锦标赛";
    } else if (m == 1) {
        if (item.slots) {
            self.matchLabel.text = [NSString stringWithFormat:@"%@人赛",item.slots];
        } else {
            self.matchLabel.text = @" ";
        }
    } else {
        self.matchLabel.text = @" ";
    }
    if (item.awardmax) {
        self.maxawardLabel.text = [NSString stringWithFormat:@"最多可赢%@金币",item.awardmax];
    }
    if (item.gold) {
        self.feeLabel.text = [NSString stringWithFormat:@"%@金币/场",item.gold];
    }
    NSInteger result = item.result.integerValue;
    if (result > 0 && result < 5) {
        self.type = result;
    } else {
        if (item.state) {
            NSInteger state = item.state.integerValue;
            self.type = state + 4;
        } else {
            self.type = 5;
        }
    }
    switch (_type) {
        case 1:
        {
            //胜利
            if (_rightBtn) {
                [_rightBtn removeFromSuperview];
                _rightBtn = nil;
            }
            self.stateLabel.text = @"胜利";
            self.stateLabel.textColor = kThemeColor;
            NSString * str = [NSString stringWithFormat:@"+%@",item.awardmax];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttributes:@{NSForegroundColorAttributeName:kYellowColor,NSFontAttributeName:[UIFont systemFontOfSize:24]} range:NSMakeRange(0, str.length)];
            NSTextAttachment * attchment = [NSTextAttachment new];
            attchment.bounds = CGRectMake(0, 0, 17, 17);
            attchment.image = [UIImage imageNamed:@"coin"];
            NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attchment];
            [attr appendAttributedString:string];
            self.coinNumberLabel.attributedText = attr;
        }
            break;
        case 2:
        {
            //惜败
            if (_rightBtn) {
                [_rightBtn removeFromSuperview];
                _rightBtn = nil;
            }
            if (_coinNumberLabel) {
                [_coinNumberLabel removeFromSuperview];
                _coinNumberLabel = nil;
            }
            self.stateLabel.text = @"惜败";
            self.stateLabel.textColor = kOrangeColor;
//            if(item.reasoncode && item.reasoncode.integerValue > 0){
//                NSInteger r = item.reasoncode.integerValue;
//                if (r == 1) {
//                   self.coinNumberLabel.text = @"截图无效";
//                } else if (r == 2) {
//                   self.coinNumberLabel.text = @"非绑定账号";
//                } else if (r == 3){
//                   self.coinNumberLabel.text = @"时间错误";
//                } else {
//                   self.coinNumberLabel.text = @"再接再厉";
//                }
//            } else {
//                if(item.value.integerValue == -3){
//                    self.coinNumberLabel.text = @"放弃提交";
//                } else {
//                    self.coinNumberLabel.text = @"再接再厉";
//                }
//            }
            self.coinNumberLabel.text = @"再接再厉";
            self.coinNumberLabel.font = [UIFont systemFontOfSize:12];
        }
            break;
        case 3:
        {
            //平局（胜利）
            if (_rightBtn) {
                [_rightBtn removeFromSuperview];
                _rightBtn = nil;
            }
            self.stateLabel.text = @"胜利";
            self.stateLabel.textColor = kThemeColor;
            NSString * str = [NSString stringWithFormat:@"+%ld",(long)item.awardmax.integerValue];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
            [attr addAttributes:@{NSForegroundColorAttributeName:kYellowColor,NSFontAttributeName:[UIFont systemFontOfSize:24]} range:NSMakeRange(0, str.length)];
            NSTextAttachment * attchment = [NSTextAttachment new];
            attchment.bounds = CGRectMake(0, 0, 17, 17);
            attchment.image = [UIImage imageNamed:@"coin"];
            NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attchment];
            [attr appendAttributedString:string];
            self.coinNumberLabel.attributedText = attr;
        }
            break;
        case 4:
        {
            //流局
            if (_rightBtn) {
                [_rightBtn removeFromSuperview];
                _rightBtn = nil;
            }
            self.stateLabel.text = @"流局";
            self.stateLabel.textColor = kTitleColor;
            if (self.coinNumberLabel.attributedText) {
                self.coinNumberLabel.attributedText = nil;
            }
            self.coinNumberLabel.text = @"金币已退回";
            self.coinNumberLabel.font = [UIFont systemFontOfSize:12];
            self.coinNumberLabel.textColor = kTitleColor;
        }
            break;
        case 5:
        {
            //未开始（等待匹配）
            [self.rightBtn setTitle:@"开始比赛" forState:UIControlStateNormal];
            self.stateLabel.text = @"未开始";
            self.stateLabel.textColor = kTitleColor;
            if (_coinNumberLabel != nil) {
                [_coinNumberLabel removeFromSuperview];
                _coinNumberLabel = nil;
            }
        }
            break;
        case 6:
        {
            //待提交
            [self.rightBtn setTitle:@"提交战绩" forState:UIControlStateNormal];
            self.stateLabel.text = @"待提交";
            self.stateLabel.textColor = kTitleColor;
            if (_coinNumberLabel != nil) {
                [_coinNumberLabel removeFromSuperview];
                _coinNumberLabel = nil;
            }
        }
            break;
        case 14:
        {
            //开始了什么也没做
            [self.rightBtn setTitle:@"开始比赛" forState:UIControlStateNormal];
            self.stateLabel.text = @"进行中";
            self.stateLabel.textColor = kTitleColor;
            if (_coinNumberLabel != nil) {
                [_coinNumberLabel removeFromSuperview];
                _coinNumberLabel = nil;
            }
        }
            break;
        case 15:{
         //超时未提交战绩
            if (_rightBtn) {
                [_rightBtn removeFromSuperview];
                _rightBtn = nil;
            }
            self.stateLabel.text = @"已结束";
            self.stateLabel.textColor = kTitleColor;
            if (self.coinNumberLabel.attributedText) {
                self.coinNumberLabel.attributedText = nil;
            }
            self.coinNumberLabel.text = @"等待结果";
            self.coinNumberLabel.font = [UIFont systemFontOfSize:12];
            self.coinNumberLabel.textColor = kTitleColor;
        }
            break;
        default:
            if (_type > 6 && _type < 11) {
                //已提交，等待结果
                if (_rightBtn) {
                    [_rightBtn removeFromSuperview];
                    _rightBtn = nil;
                }
                self.stateLabel.text = @"已提交";
                self.stateLabel.textColor = kTitleColor;
                if (self.coinNumberLabel.attributedText) {
                    self.coinNumberLabel.attributedText = nil;
                }
                self.coinNumberLabel.text = @"等待结果";
                self.coinNumberLabel.font = [UIFont systemFontOfSize:12];
                self.coinNumberLabel.textColor = kTitleColor;
            }
            break;
    }
}
-(UIButton *)rightBtn
{
    if (_rightBtn) {
        return _rightBtn;
    }
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    _rightBtn.layer.cornerRadius = 11;
    [_rightBtn setTitle:@"开始比赛" forState:UIControlStateNormal];
     [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.backgroundColor = kThemeColor;
    _rightBtn.userInteractionEnabled = NO;
    [self.dateLabel.superview addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.dateLabel.mas_top).offset(-3);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(50);
        make.right.mas_equalTo(self.rightBtn.superview).offset(-10);
    }];
    return _rightBtn;
}
-(UILabel *)coinNumberLabel
{
    if (_coinNumberLabel) {
        return _coinNumberLabel;
    }
    _coinNumberLabel = [UILabel new];
    _coinNumberLabel.textColor = kTitleColor;
    _coinNumberLabel.font = [UIFont systemFontOfSize:12];
    [self.dateLabel.superview addSubview:_coinNumberLabel];
    [_coinNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stateLabel);
        make.right.mas_equalTo(self.dateLabel);
        make.height.mas_equalTo(30);
    }];
    return _coinNumberLabel;
}
//点击button
-(void)clickRightBtn{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
