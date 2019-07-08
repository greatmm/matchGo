//
//  KKSupeiCollectionViewCell.m
//  game
//
//  Created by GKK on 2018/8/13.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKSupeiCollectionViewCell.h"
@implementation KKSupeiCollectionViewCell
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.desLabel.text = @"";
    self.desLabel.hidden = YES;
}
-(void)assignWithDic:(NSDictionary *)dic
{
    NSNumber * gId = dic[@"game"];
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]] placeholderImage:[UIImage imageWithColor:kBackgroundColor]];
    if (gId) {
        NSInteger gameId = gId.integerValue;
        if (gameId > 0 && gameId < 5) {
            NSArray * gameIconImgs = @[@"PUBGIcon",@"GKIcon",@"ZCIcon",@"LOLIcon"];
            self.avatarImageView.image = [UIImage imageNamed:gameIconImgs[gId.integerValue - 1]];
        }
    }
    self.titleLabel.text = dic[@"title"];
    self.subTitleLabel.text = dic[@"subtitle"];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addShadowWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) shadowOpacity:0.05 shadowColor:nil shadowOffset:CGSizeMake(0, 3)];
    [self.backImageView addCornersWithRectCorner:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerSize:CGSizeMake(2, 2)];
}
@end
