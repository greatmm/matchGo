//
//  KKBigHouseListTableViewCell.m
//  game
//
//  Created by greatkk on 2018/11/23.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBigHouseListTableViewCell.h"
#import "LEffectLabel.h"
#import <SDWebImage/UIImage+GIF.h>
@interface KKBigHouseListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称label
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;//单排分数
@property (weak, nonatomic) IBOutlet UILabel *winRateLabel;//胜率label
@property (strong,nonatomic) UILabel * mineLabel;//显示我
@property (strong,nonatomic) UILabel * coinLabel;//输赢多少金币(右上角label)
@property (strong,nonatomic) UILabel * resultLabel;//KDA:13.3(右下角)
@property (strong,nonatomic) UILabel * rankLabel;//排名
@property (strong,nonatomic) NSNumber * value;//KDA多少分
//跑马灯label
//@property (strong,nonatomic) LEffectLabel *effectLabel;
@property (strong,nonatomic) UIImageView *imageGifView;
@end

@implementation KKBigHouseListTableViewCell

- (void)awakeFromNib {
//    [self addSubview:self.effectLabel];
//    _effectLabel.text=@"准备中";
//    [self.effectLabel startAnimation];
    [self addSubview:self.imageGifView];
    

    [super awakeFromNib];
    // Initialization code
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    self.nickNameLabel.textColor = kTitleColor;
    if (_mineLabel) {
        [_mineLabel removeFromSuperview];
        _mineLabel = nil;
    }
}
-(UILabel *)resultLabel
{
    if (_resultLabel) {
        return _resultLabel;
    }
    _resultLabel = [UILabel new];
    _resultLabel.font = [UIFont systemFontOfSize:10];
    _resultLabel.textColor = kSubtitleColor;
    [self.contentView addSubview:_resultLabel];
    [_resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-16);
        make.top.mas_equalTo(self.nickNameLabel.mas_bottom).offset(5);
    }];
    return _resultLabel;
}
-(void)assignWithUser:(KKRoomUser *)user gameid:(KKGameType)gameid
{
    if (user.value) {
        self.value = user.value;
    }
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.nickNameLabel.text = user.name;
    KKUser * u = [KKDataTool user];
    if (u.userId.integerValue == user.uid.integerValue) {
        self.nickNameLabel.textColor = kThemeColor;
        [self.contentView addSubview:self.mineLabel];
    }
    self.winRateLabel.text = [NSString stringWithFormat:@"胜率:%.0f%%",[user getRateOfWinning]];
    if (gameid==KKGameTypeJuediQS) {
        if (user.gamerank) {
            self.scoreLabel.text = [NSString stringWithFormat:@"单排:%@",user.gamerank];
        } else {
            self.scoreLabel.text = @"单排:0";
        }
    }
    else
    {
        if (user.gamerank) {
            self.scoreLabel.text = [NSString stringWithFormat:@"段位:%@",user.gamerank];
        }
        else self.scoreLabel.text = @"  ";
    }
    NSInteger r = user.result.integerValue;
    if (r>0 && r<5) {
        NSString * img;
        if (user.images && user.images.length > 0) {
            img = user.images;
        } else if(user.image && user.image.length > 0){
            img = user.image;
        }
        if (img) {
            [self.coinLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView).offset(-16);
//                make.top.mas_equalTo(self.nickNameLabel);
                make.top.mas_equalTo(self.avatarImgView).offset(5);
            }];
        } else {
            [self.coinLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView).offset(-16);
                make.centerY.mas_equalTo(self.contentView);
            }];
        }
        if (img == nil) {
            self.resultLabel.text = @" ";
            self.accessoryType = UITableViewCellAccessoryNone;
        } else {
            self.resultLabel.text = @"查看战绩";
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        if (r == 1 || r == 3) {
            NSMutableAttributedString * s = [[NSMutableAttributedString alloc] initWithString:user.award.stringValue attributes:@{NSForegroundColorAttributeName:kYellowColor,NSFontAttributeName:[UIFont systemFontOfSize:11]}];
            UIImage * image = [UIImage imageNamed:@"coin_big"];
            NSTextAttachment * attchment = [NSTextAttachment new];
            attchment.bounds = CGRectMake(0, 0, 9, 10);
            attchment.image = image;
            NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attchment];
            [s appendAttributedString:string];
            self.coinLabel.attributedText = s;
//            self.resultLabel.text = @"查看战绩";
        } else {
            self.coinLabel.font = [UIFont systemFontOfSize:11];
            self.coinLabel.textColor = kOrangeColor;
            if (r == 4) {
                if (img && img.length > 0) {
                    //有图片
                   self.coinLabel.text = @"流局·平分秋色";
                } else {
                    //无图片就是放弃
                   self.coinLabel.text = @"流局·放弃提交";
                }
//                if (user.value.integerValue == -3) {
//                    self.coinLabel.text = @"流局·放弃提交";
//                } else {
//                    self.coinLabel.text = @"流局·平分秋色";
//                }
            } else {
                NSNumber * reason = user.reasoncode;
                if (reason && reason.integerValue > 0) {
                    NSInteger r = reason.integerValue;
                    NSString * str = @" ";
                    if (r == 1) {
                        str = @"惜败·截图无效";
                    } else if(r == 2) {
                        str = @"惜败·非绑定账号";
                    }else if (r == 3){
                        str = @"惜败·时间错误";
                    }
                    self.coinLabel.text = @"惜败·放弃提交";
                } else {
                    if (user.value.integerValue == -3) {
                        self.coinLabel.text = @"惜败·放弃提交";
                    } else {
                        self.coinLabel.text = @"惜败";
                    }
                }
            }
       }
    } else {
        NSInteger s = user.state.integerValue + 4;
        if (s == 4 || s == 5 || s == 14) {
            return;
        }
        [self.coinLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-16);
            make.centerY.mas_equalTo(self.contentView);
        }];
        if (s == 6) {
            self.coinLabel.text = @"待提交";
            self.coinLabel.textColor = kOrangeColor;
            self.coinLabel.font = [UIFont systemFontOfSize:11];
        } else if (s == 10) {
            self.coinLabel.text = @"放弃提交";
            self.coinLabel.textColor = kOrangeColor;
            self.coinLabel.font = [UIFont systemFontOfSize:11];
        } else {
            self.coinLabel.text = @"待验证";
            self.coinLabel.textColor = kThemeColor;
            self.coinLabel.font = [UIFont systemFontOfSize:11];
        }
    }
    [self layoutIfNeeded];
}
- (void)updateStatusGifImage:(KKRoomUser *)user step:(NSInteger)step
{
    NSInteger r = user.result.integerValue;
    if (r>0 && r<5) {
        self.imageGifView.hidden=true;
        return;
    }
    NSInteger s = user.state.integerValue + 4;
    if (!(s == 4 || s == 5 || s == 14)) {
        //待提交或者已提交，不显示动图
        self.imageGifView.hidden = true;
        return;
    }
    if (step == 0) {
         _imageGifView.image=[UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:kkBundlePath(@"ready", @"gif")]];
    } else if (step == 1){
        _imageGifView.image=[UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:kkBundlePath(@"fight", @"gif")]];
    } else {
        self.imageGifView.hidden=true;
        if (step == 2) {
            //过了10分钟倒计时，并且没有更新state
            self.coinLabel.text = @"待提交";
            self.coinLabel.textColor = kOrangeColor;
            self.coinLabel.font = [UIFont systemFontOfSize:11];
        }
        return;
    }
    self.imageGifView.hidden=false;
    
}
-(void)assignWithDic:(NSDictionary *)dic
{
    //绝地求生 value未负数需要处理
    if (self.value) {
        self.resultLabel.text = [NSString stringWithFormat:@"%@:%@",dic[@"choice"],self.value];
    } else {
      self.resultLabel.text = dic[@"choice"];
    }
}
- (UIImageView *)imageGifView
{
    if (!_imageGifView) {
        _imageGifView=[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-W(60), (self.height-W(50))/2, W(50), W(50))];
        _imageGifView.image=[UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:kkBundlePath(@"ready", @"gif")]];
    }
    return _imageGifView;
}
//- (LEffectLabel *)effectLabel
//{
//    if (!_effectLabel) {
//        _effectLabel=[[LEffectLabel alloc] initWithFrame:CGRectMake(kScreenWidth-80, (self.height-30)/2+10, 50, 30)];
//        _effectLabel.font=[UIFont boldSystemFontOfSize:14];
//        _effectLabel.textColor=MTK16RGBCOLOR(0x101D37);
//        _effectLabel.effectColor=[UIColor whiteColor];
//    }
//    return _effectLabel;
//}
-(UILabel *)coinLabel
{
    if (_coinLabel) {
        return _coinLabel;
    }
    _coinLabel = [UILabel new];
    [self.contentView addSubview:_coinLabel];
    [_coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-16);
        make.top.mas_equalTo(self.avatarImgView).offset(5);
    }];
    return _coinLabel;
}
-(UILabel *)rankLabel
{
    if (_rankLabel) {
        return _rankLabel;
    }
    _rankLabel = [UILabel new];
    _rankLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_rankLabel];
    _rankLabel.backgroundColor = kThemeColor;
    _rankLabel.layer.cornerRadius = 7;
    _rankLabel.layer.masksToBounds = YES;
    _rankLabel.font = [UIFont boldSystemFontOfSize:8];
    [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.left.mas_equalTo(self.avatarImgView);
        make.bottom.mas_equalTo(self.avatarImgView);
    }];
    return _rankLabel;
}
-(UILabel *)mineLabel
{
    if (_mineLabel) {
        return _mineLabel;
    }
    _mineLabel = [UILabel new];
    _mineLabel.textColor = [UIColor whiteColor];
    _mineLabel.text = @"我";
    _mineLabel.font = [UIFont boldSystemFontOfSize:8];
    _mineLabel.backgroundColor = kThemeColor;
    _mineLabel.textAlignment = NSTextAlignmentCenter;
    _mineLabel.layer.cornerRadius = 7;
    _mineLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_mineLabel];
    [_mineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self.avatarImgView);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    return _mineLabel;
}
-(void)setRank:(NSInteger)rank
{
    if (_rank == rank) {
        return;
    }
    _rank = rank;
    if (_rank < 4) {
        NSString * imgName = [NSString stringWithFormat:@"NO%ld",(long)_rank];
        UIImage * image = [UIImage imageNamed:imgName];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc]init];
        NSTextAttachment * attchment = [NSTextAttachment new];
        attchment.bounds = CGRectMake(0, 0, 14, 14);
        attchment.image = image;
        NSAttributedString * string = [NSAttributedString attributedStringWithAttachment:attchment];
        [str appendAttributedString:string];
        self.rankLabel.attributedText = str;
        self.rankLabel.backgroundColor = [UIColor whiteColor];
    } else {
        if (_rank < 6) {
            self.rankLabel.text = [NSString stringWithFormat:@"%ld",(long)_rank];
            self.rankLabel.backgroundColor = kThemeColor;
        } else {
            self.rankLabel.text = @"";
            self.rankLabel.backgroundColor = [UIColor clearColor];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
