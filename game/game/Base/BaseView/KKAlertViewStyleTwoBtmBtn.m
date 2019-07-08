//
//  KKAlertViewStyleTwoBtmBtn.m
//  game
//
//  Created by greatkk on 2019/1/7.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKAlertViewStyleTwoBtmBtn.h"
#import "KKChongzhiViewController.h"
@implementation KKAlertViewStyleTwoBtmBtn
- (IBAction)clickLeftBtn:(id)sender {
    [self removeFromSuperview];
    if (self.clickLeftBtnBlock) {
        self.clickLeftBtnBlock();
    }
}
- (IBAction)clickRightBtn:(id)sender {
    [self removeFromSuperview];
    if (self.clickRightBtnBlock) {
        self.clickRightBtnBlock();
    }
}
+(instancetype)shareAlertViewStyleTwoBtmBtn
{
    KKAlertViewStyleTwoBtmBtn * hintView = [[NSBundle mainBundle] loadNibNamed:@"KKAlertViewStyleTwoBtmBtn" owner:nil options:nil].firstObject;
    return hintView;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    if (self.clickLeftBtnBlock) {
        self.clickLeftBtnBlock();
    }
}

+ (void)showRechargeWithVC:(UIViewController *)basicVC amount:(NSInteger)amount block:(MTKCompletionBlock)block
{
    UIView *view=basicVC.view;
    [KKAlert showAnimateWithText:nil toView:view];
    [KKNetTool getMyWalletSuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:view];
        NSNumber * diamond = dic[@"diamond"];
        NSNumber * gold = dic[@"gold"];
        KKAlertViewStyleTwoBtmBtn * roomHintView = [KKAlertViewStyleTwoBtmBtn shareAlertViewStyleTwoBtmBtn];
        roomHintView.frame = [UIScreen mainScreen].bounds;
        [view.window addSubview:roomHintView];
        NSInteger goldLack = gold.integerValue + diamond.integerValue * 10 - amount;
        if (goldLack > 0) {
            //钻石兑换之后足够
            roomHintView.titleLabel.text = @"";
            roomHintView.subtitleLabel.text = @"金币不足，需要将钻石换为金币继续参加比赛";
            [roomHintView.rightBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
            roomHintView.clickRightBtnBlock = ^{
                KKChongzhiViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"chongzhiVC"];
                vc.isChongzhi = false;
                vc.lackGold = amount-gold.integerValue;
                vc.chongzhiBlock = ^{
                    if (block) {
                         block(true,@"",nil);
                    }
                };
                [basicVC.navigationController pushViewController:vc animated:YES];
            };
        } else {
            roomHintView.titleLabel.text = @"";
            roomHintView.subtitleLabel.text = @"金币不足，将无法参赛,请先充值";
            [roomHintView.rightBtn setTitle:@"立即充值" forState:UIControlStateNormal];
            roomHintView.clickRightBtnBlock = ^{
                KKChongzhiViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"chongzhiVC"];
                vc.isChongzhi = true;
//                vc.lackGold = amount-gold.integerValue;
                vc.chongzhiBlock = ^{
                    if (block) {
                        block(true,@"",nil);
                    }
                };
                [basicVC.navigationController pushViewController:vc animated:YES];
            };
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:view];
        if (block) {
            block(false,(NSString *)error,nil);
        }
        if ([error isKindOfClass:[NSString class]]) {
            [KKAlert showText:(NSString *)error toView:view];
        }
    }];
}
@end
