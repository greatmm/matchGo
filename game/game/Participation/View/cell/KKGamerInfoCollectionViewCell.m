//
//  KKGamerInfoCollectionViewCell.m
//  game
//
//  Created by GKK on 2018/10/10.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKGamerInfoCollectionViewCell.h"
#import "KKRoomUser.h"
@interface KKGamerInfoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *gamerIcon;//头像
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;//用户名
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;//胜率
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;//头像宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginToIcon;//昵称距离头像的距离

@end
@implementation KKGamerInfoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setType:(NSInteger)type
{
    if (_type == type) {
        return;
    }
    _type = type;
    if (_type == 2) {
        self.iconWidth.constant = 62;
        self.gamerIcon.layer.cornerRadius = 31;
        self.gamerIcon.layer.masksToBounds = YES;
        self.topMarginToIcon.constant = 17;
    } else if (_type == 4) {
        self.iconWidth.constant = 45;
        self.gamerIcon.layer.cornerRadius = 22.5;
        self.gamerIcon.layer.masksToBounds = YES;
        self.topMarginToIcon.constant = 10;
    } else {
        self.iconWidth.constant = 45;
        self.gamerIcon.layer.cornerRadius = 22.5;
        self.gamerIcon.layer.masksToBounds = YES;
        self.topMarginToIcon.constant = 2;
    }
    [self layoutIfNeeded];
}

-(void)assignWithDic:(id)item
{
    if (item == nil) {
        self.gamerIcon.image = [UIImage imageNamed:@"icon"];
        self.rateLabel.hidden = YES;
        self.nicknameLabel.textColor = [UIColor whiteColor];
        self.nicknameLabel.text = @"  待参赛  ";
        self.nicknameLabel.backgroundColor = [UIColor colorWithWhite:157/255.0 alpha:1];
    } else {
        KKRoomUser * user = item;
        self.rateLabel.hidden = NO;
        NSNumber * total = user.total;
        NSNumber * win = user.win;
        if (total.integerValue == 0) {
            self.rateLabel.text = @"胜率:0%";
        } else {
            CGFloat r = win.floatValue/total.floatValue;
            self.rateLabel.text = [NSString stringWithFormat:@"胜率:%.f%@",100 * r,@"%"];
        }
        self.nicknameLabel.textColor = kTitleColor;
        self.nicknameLabel.text = user.gamer;
        self.nicknameLabel.backgroundColor = [UIColor whiteColor];
        [self.gamerIcon sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];
    }
}
@end
