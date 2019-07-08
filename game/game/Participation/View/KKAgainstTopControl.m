//
//  KKAgainstTopControl.m
//  game
//
//  Created by GKK on 2018/10/11.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKAgainstTopControl.h"
@interface KKAgainstTopControl()
@property (nonatomic,strong) UIImageView * backImgView;//背景图片
@property (nonatomic,strong) UIImageView * maskImgView;//遮罩图片
@property (nonatomic,strong) UIImageView * gameImgView;//游戏图标
@property (nonatomic,strong) UILabel * gameNameLabel;//游戏名称
@end

@implementation KKAgainstTopControl
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.backImgView];
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    [self addSubview:self.maskImgView];
    [self.maskImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    [self addSubview:self.gameImgView];
    [self.gameImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-50);
        make.width.height.mas_equalTo(74);
    }];
    [self addSubview:self.gameNameLabel];
    [self.gameNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.gameImgView);
        make.centerX.mas_equalTo(self);
    }];
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [UIView animateWithDuration:0.25 animations:^{
            self.maskImgView.image = [UIImage imageNamed:@"mask_light"];
            self.backImgView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.gameImgView.alpha = 1.0;
            self.gameNameLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.maskImgView.image = [UIImage imageNamed:@"mask_dark"];
            self.backImgView.transform = CGAffineTransformMakeScale(1, 1);
            self.gameImgView.alpha = 0.6;
            self.gameNameLabel.alpha = 0.6;
        } completion:^(BOOL finished) {
            
        }];
    }
}
-(UIImageView *)backImgView
{
    if (_backImgView == nil) {
        _backImgView = [UIImageView new];
        NSArray * imgNames = @[@"LOL",@"PUBG",@"WZRY",@"CJZZ"];
        NSString * imgName = imgNames[self.tag];
        _backImgView.image = [UIImage imageNamed:imgName];
    }
    return _backImgView;
}
- (UIImageView *)maskImgView
{
    if (_maskImgView == nil) {
        _maskImgView = [UIImageView new];
        _maskImgView.image = [UIImage imageNamed:@"mask_dark"];
    }
    return _maskImgView;
}
-(UIImageView *)gameImgView
{
    if (_gameImgView == nil) {
        _gameImgView = [UIImageView new];
        NSArray * imgNames = @[@"game1",@"game2",@"game3",@"game4"];
        NSString * imgName = imgNames[self.tag];
        _gameImgView.image = [UIImage imageNamed:imgName];
        _gameImgView.alpha = 0.6;
    }
    return _gameImgView;
}
-(UILabel *)gameNameLabel
{
    if (_gameNameLabel == nil) {
        _gameNameLabel = [UILabel new];
        _gameNameLabel.textColor = [UIColor whiteColor];
        _gameNameLabel.alpha = 0.6;
        _gameNameLabel.font = [UIFont systemFontOfSize:12];
        NSArray * gameNames = @[@"英雄联盟",@"绝地求生",@"王者荣耀",@"刺激战场"];
        _gameNameLabel.text = gameNames[self.tag];
    }
    return _gameNameLabel;
}
@end
