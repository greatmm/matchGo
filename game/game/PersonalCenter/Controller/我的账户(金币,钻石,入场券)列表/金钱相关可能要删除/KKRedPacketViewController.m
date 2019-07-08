//
//  KKRedPacketViewController.m
//  game
//
//  Created by GKK on 2018/10/24.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKRedPacketViewController.h"
#import "KKMoneyRecordViewController.h"
@interface KKRedPacketViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentMoneyLabel;//当前余额
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;//总收入
@property (weak, nonatomic) IBOutlet UILabel *wechatAccountLabel;//微信账户名
@property (weak, nonatomic) IBOutlet UILabel *alipayAccountLabel;//支付宝账户名


@end

@implementation KKRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.currentWallet) {
        CGFloat currentW = self.currentWallet.floatValue * 0.01;
        self.currentMoneyLabel.text = [KKDataTool decimalNumber:[NSNumber numberWithFloat:currentW] fractionDigits:2];
    } else {
        self.currentMoneyLabel.text = @"";
    }
    if (self.generalIncome) {
        CGFloat currentT = self.generalIncome.floatValue * 0.01;
        self.totalMoneyLabel.text = [KKDataTool decimalNumber:[NSNumber numberWithFloat:currentT] fractionDigits:2];
    } else {
        self.totalMoneyLabel.text = @"";
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIView * sV = self.wechatAccountLabel.superview.superview;
    [sV addShadowWithFrame:sV.bounds shadowOpacity:0.15 shadowColor:kTitleColor shadowOffset:CGSizeMake(0, -5)];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击微信
- (IBAction)clickWechatControl:(id)sender {
    UIViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"wechatPayBind"];
    [self.navigationController pushViewController:vc animated:YES];
}
//点击支付宝
- (IBAction)clickAlipayControl:(id)sender {
    UIViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"alipayBind"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickRedpacketDetail:(id)sender {
//    NSLog(@"红包明细");
    KKMoneyRecordViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"moneyRecord"];
    vc.moneyStr = self.currentMoneyLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}
//点击提现按钮
- (IBAction)clickBtmbtn:(id)sender {
    UIViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"withdrawVc"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
