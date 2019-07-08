//
//  KKResultListTableViewCell.m
//  game
//
//  Created by GKK on 2018/9/27.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKResultListTableViewCell.h"
#import "UIImage+KKCategory.h"
@interface KKResultListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;//查看
@property (weak, nonatomic) IBOutlet UIImageView *btmLine;//底部线
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;//右边箭头
@property (nonatomic,strong) UIImageView * leftImgView;//NO1指示
@property (nonatomic,strong) UIImageView *resultImgView;//结果展示图片
@end
@implementation KKResultListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setShowImage:(BOOL)showImage
{
    _showImage = showImage;
    self.arrowImgView.hidden = !_showImage;
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    if (self.showImage) {
        self.isOpen = NO;
    }
    self.type = 2;
}
- (UIImageView *)resultImgView
{
    if (_resultImgView == nil) {
        _resultImgView = [UIImageView new];
//        _resultImgView.image = [UIImage imageNamed:@"GK_Back"];
        [self.contentView addSubview:_resultImgView];
        [_resultImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImgView.mas_bottom).offset(2);
            make.left.mas_equalTo(self.avatarImgView);
            make.right.mas_equalTo(self.arrowImgView);
            make.height.mas_equalTo(100);
        }];
    }
    return _resultImgView;
}
-(void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    if (_isOpen) {
        [self.contentView addSubview:self.resultImgView];
    } else {
        if (_resultImgView) {
            [_resultImgView removeFromSuperview];
            _resultImgView = nil;
        }
    }
    CGFloat ang = M_PI;
    if (_isOpen == NO) {
        ang = 0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.arrowImgView.transform = CGAffineTransformMakeRotation(ang);
    }];
}
-(void)assignWithDic:(NSDictionary *)dic
{
    self.nickNameLabel.text = dic[@"gamer"];
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon"]];
    if (self.showImage) {
        if (self.isOpen) {
            [self.resultImgView sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]] placeholderImage:[UIImage imageWithColor:kSubtitleColor]];
        }
        return;
    }
    NSNumber * result = dic[@"result"];
    NSNumber * state = dic[@"state"];
    if (state == nil || state.integerValue == 99) {
        self.rightLabel.text = @"无数据";
    } else {
        NSInteger s = state.integerValue + result.integerValue + 4;
        NSString * t = @"无数据";
        switch (s) {
            case 11:
            {
                t = @"未提交";
            }
                break;
            case 12:
            {
                NSInteger r = result.integerValue;
                if (r == 1 || r == 3) {
                    t = @"胜利";
                } else if (r == 2){
                    t = @"惜败";
                }
            }
                break;
            case 13:
                t = @"认输";
                break;
                
            default:
                t = @"无数据";
                break;
        }
        self.rightLabel.text = t;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(UIImageView *)leftImgView
{
    if (_leftImgView) {
        return _leftImgView;
    }
    _leftImgView = [UIImageView new];
    _leftImgView.image = [UIImage imageNamed:@"NO1"];
    _leftImgView.frame = CGRectMake(12, 18, 18, 20);
    return _leftImgView;
}
- (void)setType:(NSInteger)type
{
    //0第一个，隐藏分割线，1表示第一名 2表示普通的
    _type = type;
    if (type == 0) {
        self.btmLine.hidden = YES;
        if(_leftImgView){
            [_leftImgView removeFromSuperview];
            _leftImgView = nil;
        }
        self.nickNameLabel.textColor = kTitleColor;
        self.nickNameLabel.font = [UIFont boldSystemFontOfSize:12];
        self.rightLabel.textColor = kTitleColor;
    } else if(type == 1){
        [self.contentView addSubview:self.leftImgView];
        self.btmLine.hidden = NO;
        self.nickNameLabel.textColor = kOrangeColor;
        self.nickNameLabel.font = [UIFont boldSystemFontOfSize:16];
        self.rightLabel.textColor = kOrangeColor;
    } else {
        self.btmLine.hidden = YES;
        self.nickNameLabel.textColor = kTitleColor;
        self.nickNameLabel.font = [UIFont boldSystemFontOfSize:12];
        self.rightLabel.textColor = kTitleColor;
        if(_leftImgView){
            [_leftImgView removeFromSuperview];
            _leftImgView = nil;
        }
    }
}
@end
