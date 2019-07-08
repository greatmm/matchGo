//
//  KKChampionMyResultTableViewCell.m
//  game
//
//  Created by greatkk on 2018/11/6.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKChampionMyResultTableViewCell.h"

@interface KKChampionMyResultTableViewCell ()
@property (strong,nonatomic) UIImageView * arrowImageView;//查看的箭头
@property (strong,nonatomic) UILabel * reasonLabel;//失败原因
@property (strong,nonatomic) UILabel * lookLabel;//查看label
@property (assign,nonatomic) NSInteger result;//结果 0未出结果，1胜利，2失败
//"result" 0 state 10 10分钟等待  2未提交
@end
@implementation KKChampionMyResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arrowImageView.hidden = YES;
    // Initialization code
}
- (NSString *)getTitleWithState:(NSInteger)state result:(NSInteger)result
{
    self.stateLabel.textColor = kTitleColor;
//    self.result=result;
    switch (state) {
        case 10:
            return @"待开始";
            break;
        case 2:
            return @"待提交";
            break;
        default:
        {
            switch (result) {
                case 0:
                    return @"待验证";
                    break;
                case 1:
                {
                    self.stateLabel.textColor = kThemeColor;
                    [self.contentView addSubview:self.arrowImageView];
                    [self.contentView addSubview:self.lookLabel];
                    return @"胜利";
                }
                    break;
                case 2:
                {
                    self.stateLabel.textColor = kOrangeColor;
                   return @"惜败";
                }
                    break;
                default:
                    break;
            }
        }
            break;
    }
    return @"";
}
- (void)resetWithData:(id)data
{
    KKChampionshipsMatchModel *model=data;
    NSArray * arr = @[@"Chiji_Icon",@"GK_Icon",@"Qiusheng_Icon",@"LOL_Icon"];
    self.gameIcon.image = [UIImage imageNamed:arr[self.gameId - 1]];
    NSNumber * statrTime = model.starttime;
    NSInteger t = statrTime.integerValue;
    if (t > 0) {
        self.dateLabel.text = [KKDataTool timeStrWithTimeStamp:t];
    } else {
        self.dateLabel.text = @" ";
    }
    
    NSInteger result = model.result;
    if (result == 1 || result == 3) {
        self.result = 1;//胜利
    } else if(result == 2){
        //失败
        self.result = 2;
    } else {
        //无结果
        self.result = 0;
    }
    NSNumber * state = model.state;
    if (state == nil) {
        state = @0;
    }
    if (_type==KKChampionshipsTypeRating) {
        self.stateLabel.text=[self getTitleWithState:state.integerValue result:self.result];
    }else
    {
        self.stateLabel.textColor=MTK16RGBCOLOR(0x101D37);
        self.stateLabel.text=_choice;
    }
    
    
    NSString * images = model.images;
    NSString * img;
    if (images && images.length > 0) {
        img = images;
    }
    
    if (self.result == 2) {
        //失败
        NSNumber * reasoncode = model.reasoncode;
        if (reasoncode && reasoncode.integerValue != 0) {
            NSInteger reason = reasoncode.integerValue;
            NSString * r = @" ";
            switch (reason) {
                case 1:
                {
                    r = @"截图无效";
                }
                    break;
                case 2:
                {
                    r = @"非绑定账号";
                }
                    break;
                case 3:
                {
                    r = @"时间错误";
                }
                    break;
                default:
                    break;
            }
            self.reasonLabel.text = r;
        } else {
            NSNumber * value = model.value;
            if (value.integerValue == -3) {
                self.reasonLabel.text = @"放弃提交";
            }
        }
        if (img) {
            self.arrowImageView.hidden = NO;
            [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.stateLabel);
                make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
            }];
            [self.lookLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
                make.bottom.mas_equalTo(self.dateLabel);
            }];
        } else {
            if (_lookLabel) {
                [_lookLabel removeFromSuperview];
                _lookLabel = nil;
            }
            [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
            }];
            self.arrowImageView.hidden = YES;
        }
    }
    else if(_type==KKChampionshipsTypeLadder)
    {
        float showAmount=model.value.floatValue;
        if (model.state.integerValue==8||showAmount>0) {
            
            if (showAmount<=0) {
                showAmount=0;
            }
            self.reasonLabel.textColor=MTK16RGBCOLOR(0x29C29E);
            self.reasonLabel.text=[NSString stringWithFormat:@"%0.1f",showAmount];
        }
        else if([HNUBZUtil checkStrEnable:model.reason])
        {
            self.reasonLabel.textColor=kOrangeColor;
            self.reasonLabel.text=model.reason;
        }
        else if(model.state.integerValue==7||model.state.integerValue==9)
        {
            self.reasonLabel.textColor=kOrangeColor;
            self.reasonLabel.text=@"放弃提交";
        }
        else
        {
            self.reasonLabel.textColor=MTK16RGBCOLOR(0x101D37);
            self.reasonLabel.text=@"待验证";
        }
        if (img) {
            self.arrowImageView.hidden = NO;
            [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.stateLabel);
                make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
            }];
            [self.lookLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
                make.bottom.mas_equalTo(self.dateLabel);
            }];
        } else {
            if (_lookLabel) {
                [_lookLabel removeFromSuperview];
                _lookLabel = nil;
            }
            [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
            }];
            self.arrowImageView.hidden = YES;
        }
    }
    else if (self.result == 0) {
        //无结果
       
        if (_reasonLabel) {
            [_reasonLabel removeFromSuperview];
            _reasonLabel = nil;
        }
        
        if (img) {
            self.arrowImageView.hidden = NO;
            [self.lookLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
                make.centerY.mas_equalTo(self.contentView);
            }];
        } else {
            if (_lookLabel) {
                [_lookLabel removeFromSuperview];
                _lookLabel = nil;
            }
            self.arrowImageView.hidden = YES;
        }
    } else {
        //胜利
        if (_reasonLabel) {
            [_reasonLabel removeFromSuperview];
            _reasonLabel = nil;
        }
        self.arrowImageView.hidden = NO;
        [self.lookLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
            make.centerY.mas_equalTo(self.arrowImageView);
        }];
    }
}
-(void)assignWithDic:(NSDictionary *)dic
{
    /*
     championid = 1;
     deadline = 1545123440;
     gamerid = 9;
     id = 10009;
     images = "";
     reason = "";
     reasoncode = 0;
     result = 0;
     starttime = 1545123140;
     state = 9;
     status = 3;
     step = 2;
     uid = 10006;
     value = "-3";
  */
    NSArray * arr = @[@"Chiji_Icon",@"GK_Icon",@"Qiusheng_Icon",@"LOL_Icon"];
    self.gameIcon.image = [UIImage imageNamed:arr[self.gameId - 1]];
    NSNumber * statrTime = dic[@"starttime"];
    NSInteger t = statrTime.integerValue;
    if (t > 0) {
        self.dateLabel.text = [KKDataTool timeStrWithTimeStamp:t];
    } else {
        self.dateLabel.text = @" ";
    }
    
    NSNumber * rst = dic[@"result"];
    if (rst == nil) {
        rst = @0;
    }
    NSInteger result = rst.integerValue;
    if (result == 1 || result == 3) {
        self.result = 1;//胜利
    } else if(result == 2){
        //失败
        self.result = 2;
    } else {
       //无结果
        self.result = 0;
    }
    NSNumber * state = dic[@"state"];
    if (state == nil) {
        state = @0;
    }
    self.stateLabel.text=[self getTitleWithState:state.integerValue result:self.result];
    NSString * images = dic[@"images"];
    NSString * img;
    if (images && images.length > 0) {
        img = images;
    }
    if (self.result == 2) {
        //失败
        NSNumber * reasoncode = dic[@"reasoncode"];
        if (reasoncode && reasoncode.integerValue != 0) {
            NSInteger reason = reasoncode.integerValue;
            NSString * r = @" ";
            switch (reason) {
                case 1:
                {
                    r = @"截图无效";
                }
                    break;
                case 2:
                {
                    r = @"非绑定账号";
                }
                    break;
                case 3:
                {
                    r = @"时间错误";
                }
                    break;
                default:
                    break;
            }
            self.reasonLabel.text = r;
        } else {
            NSNumber * value = dic[@"value"];
            if (value.integerValue == -3) {
                self.reasonLabel.text = @"放弃提交";
            }
        }
        if (img) {
            self.arrowImageView.hidden = NO;
            [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.stateLabel);
                make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
            }];
            [self.lookLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
                make.bottom.mas_equalTo(self.dateLabel);
            }];
        } else {
            if (_lookLabel) {
                [_lookLabel removeFromSuperview];
                _lookLabel = nil;
            }
            [self.reasonLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
            }];
            self.arrowImageView.hidden = YES;
        }
    } else if (self.result == 0) {
        //无结果
        if (_reasonLabel) {
            [_reasonLabel removeFromSuperview];
            _reasonLabel = nil;
        }
        if (img) {
            self.arrowImageView.hidden = NO;
            [self.lookLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
                make.centerY.mas_equalTo(self.contentView);
            }];
        } else {
            if (_lookLabel) {
                [_lookLabel removeFromSuperview];
                _lookLabel = nil;
            }
            self.arrowImageView.hidden = YES;
        }
    } else {
       //胜利
        if (_reasonLabel) {
            [_reasonLabel removeFromSuperview];
            _reasonLabel = nil;
        }
        self.arrowImageView.hidden = NO;
        [self.lookLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
            make.centerY.mas_equalTo(self.arrowImageView);
        }];
    }
//    if (self.gameId == 1) {
//        if (_leftControl) {
//            [_leftControl removeFromSuperview];
//            _leftControl = nil;
//        }
//        NSNumber * value = dic[@"value"];
//        if (value) {
//            self.leftLabel.text = [NSString stringWithFormat:@"%@",value];
//        } else {
//            self.leftLabel.text = @"";
//        }
//    } else {
//        if (_leftLabel) {
//            [_leftLabel removeFromSuperview];
//            _leftLabel = nil;
//        }
//        [self.contentView addSubview:self.leftControl];
//    }
}
-(void)setResult:(NSInteger)result
{
    _result = result;
//    if (_result == 0) {
//        self.stateLabel.text = @"待验证";
//        self.stateLabel.textColor = kTitleColor;
//    } else if (_result == 1) {
//        self.stateLabel.text = @"胜利";
//        self.stateLabel.textColor = kThemeColor;
//        [self.contentView addSubview:self.arrowImageView];
//        [self.contentView addSubview:self.lookLabel];
//    } else if (_result == 2){
//        self.stateLabel.text = @"惜败";
//        self.stateLabel.textColor = kOrangeColor;
//    }
}
-(UILabel *)reasonLabel
{
    if (_reasonLabel) {
        return _reasonLabel;
    }
    _reasonLabel = [UILabel new];
    _reasonLabel.font = [UIFont systemFontOfSize:11];
    _reasonLabel.textColor = kOrangeColor;
    [self.contentView addSubview:_reasonLabel];
    return _reasonLabel;
}
-(UIImageView *)arrowImageView
{
    if (_arrowImageView) {
        return _arrowImageView;
    }
    _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_gray"]];
    [self.contentView addSubview:_arrowImageView];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    return _arrowImageView;
}
-(UILabel *)lookLabel
{
    if (_lookLabel) {
        return _lookLabel;
    }
    _lookLabel = [UILabel new];
    _lookLabel.font = [UIFont systemFontOfSize:10];
    _lookLabel.text = @"查看";
    _lookLabel.textColor = [UIColor colorWithWhite:153/255.0 alpha:1];
    [self.contentView addSubview:_lookLabel];
    return _lookLabel;
}

-(UILabel *)leftLabel
{
    if (_leftLabel) {
        return _leftLabel;
    }
    _leftLabel = [UILabel new];
    _leftLabel.font = [UIFont systemFontOfSize:12];
    _leftLabel.textColor = kTitleColor;
    [self.contentView addSubview:_leftLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.centerY.mas_equalTo(self.gameIcon);
    }];
    return _leftLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
