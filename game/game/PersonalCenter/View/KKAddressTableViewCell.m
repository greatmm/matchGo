//
//  KKAddressTableViewCell.m
//  game
//
//  Created by Jack on 2018/8/8.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKAddressTableViewCell.h"

@interface KKAddressTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end
@implementation KKAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clickEditBtn:(id)sender {
    if (self.editBlock) {
        self.editBlock();
    }
}
-(void)assignWithItem:(KKAddressItem *)item
{
    self.nameLabel.text = item.contact;
    self.firstNameLabel.text = [item.contact substringToIndex:1];
    self.firstNameLabel.layer.masksToBounds = YES;
    self.phoneLabel.text = item.phone;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@",item.area,item.address];
    self.stateLabel.hidden = !item.isdefault.boolValue;    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
