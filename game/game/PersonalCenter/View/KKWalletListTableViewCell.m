//
//  KKWalletListTableViewCell.m
//  game
//
//  Created by GKK on 2018/10/23.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKWalletListTableViewCell.h"

@interface KKWalletListTableViewCell ()
@property (strong,nonatomic) NSString * typeStr;
@end
@implementation KKWalletListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)assignWithDic:(NSDictionary *)dic
{
    self.titleLabel.text = dic[@"description"];
    [self getTypeTitle];
    self.numLabel.text = [NSString stringWithFormat:@"%@",dic[self.typeStr]];
    NSNumber * t = dic[@"time"];
    if (t) {
        NSDate * d = [NSDate dateWithTimeIntervalSince1970:t.integerValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [formatter setDateFormat:@"MM/dd HH:mm"];
        NSString* string = [formatter stringFromDate:d];
        self.dateLabel.text = string;
    } else {
        self.dateLabel.text = @"";
    }
}
- (void)getTypeTitle
{
    if (self.typeStr) {
        return;
    }
    NSArray * arr = @[@"gold_change",@"diamond_change",@"ticket_change",@"lock_change",@"cny_change"];
    self.typeStr = arr[self.accountType - 1];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
