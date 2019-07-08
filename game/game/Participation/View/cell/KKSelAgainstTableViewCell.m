//
//  KKSelAgainstTableViewCell.m
//  game
//
//  Created by GKK on 2018/10/9.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKSelAgainstTableViewCell.h"

@implementation KKSelAgainstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setShowRightView:(BOOL)showRightView
{
    _showRightView = showRightView;
    if (_showRightView) {
        self.textLabel.textColor = kThemeColor;
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nick"]];
    } else {
        self.textLabel.textColor = kTitleColor;
        self.accessoryView = nil;
    }
}
@end
