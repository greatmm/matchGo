//
//  KKAlertViewStyleTips.m
//  game
//
//  Created by greatkk on 2019/1/8.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKAlertViewStyleTips.h"

@implementation KKAlertViewStyleTips
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.btmBtn.layer.shadowColor = kThemeColor.CGColor;
}
+(instancetype)sharedAlertViewStyleTips
{
    KKAlertViewStyleTips * tips = [[NSBundle mainBundle] loadNibNamed:@"KKAlertViewStyleTips" owner:nil options:nil].firstObject;
    return tips;
}
- (IBAction)clickCloseBtn:(id)sender {
    [self removeFromSuperview];
    if (self.clickCancelBtnBlock) {
        self.clickCancelBtnBlock();
    }
}
- (IBAction)clickBtmBtn:(id)sender {
    [self removeFromSuperview];
    if (self.clickBtmBtnBlock) {
        self.clickBtmBtnBlock();
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    if (self.clickCancelBtnBlock) {
        self.clickCancelBtnBlock();
    }
}
@end
