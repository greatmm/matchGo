//
//  KKOrderTableViewCell.m
//  game
//
//  Created by GKK on 2018/8/29.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKOrderTableViewCell.h"

@implementation KKOrderTableViewCell
+(instancetype)shareCell
{
    return [[NSBundle mainBundle] loadNibNamed:@"KKOrderTableViewCell" owner:nil options:nil].firstObject;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)assignWithType:(NSInteger)type
{
    switch (type) {
        case 0:
        {
            self.stateLabel.text = @"等待支付";
            self.stateLabel.textColor = kOrangeColor;
            [self.btn setTitle:@"去支付" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            self.stateLabel.text = @"等待收货";
            self.stateLabel.textColor = kOrangeColor;
            [self.btn setTitle:@"确认收货" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            self.stateLabel.text = @"已完成";
            self.stateLabel.textColor = kThemeColor;
            [self.btn setTitle:@"再买一件" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
