//
//  KKSmallHouseViewController.m
//  game
//
//  Created by greatkk on 2018/11/14.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKSmallHouseViewController.h"

@interface KKSmallHouseViewController ()

@end

@implementation KKSmallHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layer.cornerRadius = 12;
    self.view.layer.masksToBounds = YES;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.backgroundColor = [UIColor colorWithWhite:248/255.0 alpha:0.82];
    [self.view addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    UIControl * control = [UIControl new];
    [self.view addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    [control addTarget:self action:@selector(clickControl) forControlEvents:UIControlEventTouchUpInside];
    self.gameIcon.image = [UIImage imageNamed:@"Chiji_Icon"];
    self.titleLabel.text = @" ";
}
#pragma mark Method
-(void)clickControl
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}
-(void)clickRightBtn
{
    if (self.clickRightBtnBlock) {
        self.clickRightBtnBlock();
    }
}
- (void)clickEnsureQuitBtn
{
    if (self.clickEnsureQuitBlock) {
        self.clickEnsureQuitBlock();
    }
}
- (void)removeCloseUI
{
    if (_closeBtn) {
        [_closeBtn removeFromSuperview];
        _closeBtn = nil;
    }
    if (_countLabel) {
        [_countLabel removeFromSuperview];
        _countLabel = nil;
    }
    if (_ensureQuitBtn) {
        [_ensureQuitBtn removeFromSuperview];
        _ensureQuitBtn = nil;
    }
    if (_cancelBtn) {
        [_cancelBtn removeFromSuperview];
        _cancelBtn = nil;
    }
    if (_clickEnsureQuitBlock) {
        _clickEnsureQuitBlock = nil;
    }
}
- (void)clickCloseBtn
{
    self.closeBtn.hidden = YES;
    self.countLabel.hidden = YES;
    self.ensureQuitBtn.hidden = NO;
    self.cancelBtn.hidden = NO;
}
- (void)updateShowInfo
{
    self.gameIcon.image =MTKImageNamed([KKMyMatchManager sharedMatchManager].getGameIcon); //[UIImage imageNamed:gameIconImgs[self.gameId - 1]];

    self.titleLabel.text=[[KKMyMatchManager sharedMatchManager].matchModel getMatchInfo];
}
- (void)updateShowTime
{
    if ([KKMyMatchManager sharedMatchManager].statusMatch==KKSmallHouseStatusStart||[KKMyMatchManager sharedMatchManager].statusMatch==KKSmallHouseStatusSubmission) {
        NSInteger time=[[KKMyMatchManager sharedMatchManager].matchModel getCountDownTime];
        if (time>0) {
            self.timeLabel.text =[NSString stringWithFormat:@"%02ld:%02ld",time/60,time%60];
        }
        
    }
}
- (void)updateMatchStatus
{
    [self updateShowInfo];
     self.timeLabel.text = @"";
    switch ([KKMyMatchManager sharedMatchManager].statusMatch) {
            case KKSmallHouseStatusRoom:
        {
            //刚创建房间 type为room类型
            self.rightBtn.userInteractionEnabled = false;
            if ([[KKMyMatchManager sharedMatchManager].matchModel isKindOfClass:[KKRoomMatchModel class]]) {
                KKRoomMatchModel *model=(KKRoomMatchModel *)[KKMyMatchManager sharedMatchManager].matchModel;
                self.countLabel.text=[NSString stringWithFormat:@"%ld/%ld",(long)model.users.count,(long)model.slots];
            }
        }
            break;
            case KKSmallHouseStatusStart:
        {
//            //倒计时
                //自建房清除人数和关闭按钮，匹配本来就没有这些UI
            [self removeCloseUI];//清除关闭按钮，人数按钮，取消按钮，确认退出按钮
            [self.rightBtn setTitle:@"开始比赛" forState:UIControlStateNormal];
            self.rightBtn.userInteractionEnabled = true;//其它的不可点
//            self.timeLabel.text = @"00:00";
            [self.view addSubview:self.clockIcon];
            self.clickRightBtnBlock = ^{
//                [weakSelf clickBtmBtn:nil];
            };
            //固定时间倒计时 假设是锦标赛
//            vc.timeLabel.text = @" ";
        }
            break;
            case KKSmallHouseStatusSubmission:
        {
            //提交比赛
            //固定时间倒计时
            [self removeCloseUI];
            self.rightBtn.userInteractionEnabled = true;
            [self.rightBtn setTitle:@"提交战绩" forState:UIControlStateNormal];
//            self.timeLabel.text = @"00:00";
            [self.view addSubview:self.clockIcon];
            self.clickRightBtnBlock = ^{
//                [weakSelf uploadResult];
            };
        }
            break;
            
        default:
        {
            //隐藏自身
        }
            break;
    }
}
#pragma mark set/get

- (UIImageView *)gameIcon
{
    if (_gameIcon) {
        return _gameIcon;
    }
    _gameIcon = [UIImageView new];
    [self.view addSubview:_gameIcon];
    [_gameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.mas_equalTo(self.view).offset(10);
    }];
    return _gameIcon;
}
-(UILabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor colorWithHexString:@"#101D37"];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameIcon.mas_right).offset(10);
        make.centerY.mas_equalTo(self.view);
    }];
    return _titleLabel;
}

-(UIButton *)rightBtn
{
    if (_rightBtn) {
        return _rightBtn;
    }
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.backgroundColor = kThemeColor;
    _rightBtn.layer.cornerRadius = 14;
    _rightBtn.layer.masksToBounds = YES;
    _rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-10);
        make.centerY.mas_equalTo(self.view);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(28);
    }];
    return _rightBtn;
}
-(UILabel *)timeLabel
{
    if (_timeLabel) {
        return _timeLabel;
    }
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [UIColor colorWithWhite:153/255.0 alpha:1];
    _timeLabel.font = [UIFont systemFontOfSize:8];
    [self.view addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rightBtn.mas_bottom).offset(2);
        make.centerX.mas_equalTo(self.rightBtn).offset(5);
    }];
    return _timeLabel;
}
-(UIImageView *)clockIcon
{
    if (_clockIcon) {
        return _clockIcon;
    }
    _clockIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock"]];
    [self.view addSubview:_clockIcon];
    [_clockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.timeLabel);
        make.right.mas_equalTo(self.timeLabel.mas_left).offset(-2);
    }];
    return _clockIcon;
}

-(UILabel *)countLabel
{
    if (_countLabel) {
        return _countLabel;
    }
    _countLabel = [UILabel new];
    _countLabel.textColor = kThemeColor;
    _countLabel.font = [UIFont systemFontOfSize:18];
    _countLabel.text = @" ";
    [self.view addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view);
        make.right.mas_equalTo(self.closeBtn.mas_left).offset(-20);
    }];
    return _countLabel;
}
-(UIButton *)closeBtn
{
    if (_closeBtn) {
        return _closeBtn;
    }
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"houseClose"] forState:UIControlStateNormal];
    [self.view addSubview:_closeBtn];
    [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.with.mas_equalTo(30);
    }];
    return _closeBtn;
}

-(UIButton *)cancelBtn
{
    if (_cancelBtn) {
        return _cancelBtn;
    }
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view);
        make.right.mas_equalTo(self.ensureQuitBtn.mas_left).offset(-20);
    }];
    [_cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    return _cancelBtn;
}
-(void)clickCancelBtn
{
    self.closeBtn.hidden = NO;
    self.countLabel.hidden = NO;
    [self.cancelBtn removeFromSuperview];
    self.cancelBtn = nil;
    [self.ensureQuitBtn removeFromSuperview];
    self.ensureQuitBtn = nil;
}
-(UIButton *)ensureQuitBtn
{
    if (_ensureQuitBtn) {
        return _ensureQuitBtn;
    }
    _ensureQuitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ensureQuitBtn setTitle:@"确认退出" forState:UIControlStateNormal];
    [_ensureQuitBtn setTitleColor:kOrangeColor forState:UIControlStateNormal];
    _ensureQuitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_ensureQuitBtn];
    [_ensureQuitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view).offset(-10);
    }];
    [_ensureQuitBtn addTarget:self action:@selector(clickEnsureQuitBtn) forControlEvents:UIControlEventTouchUpInside];
    return _ensureQuitBtn;
}

@end
