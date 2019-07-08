//
//  KKWithdrawViewController.m
//  game
//
//  Created by GKK on 2018/10/24.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKWithdrawViewController.h"

@interface KKWithdrawViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIButton *btmBtn;
@property (nonatomic,strong) UIButton * currentBtn;//当前选中的支付方式
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;//本次可提现金额

@property (weak, nonatomic) IBOutlet UIButton *rigBtn;//全部提现按钮

@end

@implementation KKWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkBtmbtn];
    self.navigationItem.title = @"红包提现";
    self.navigationItem.rightBarButtonItem = nil;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //删除键
    if (string.length == 0) {
        return YES;
    }
    NSString * text = textField.text;
    if ([text containsString:@"."]) {
        //重复输入小数点返回
        if ([string isEqualToString:@"."]) {
            return NO;
        }
        //小数点后不能超过两位
        NSRange r = [text rangeOfString:@"."];
        if (text.length > r.location + 2) {
            return  NO;
        }
        return YES;
    } else {
        //第一位是小数点返回
        if ([string isEqualToString:@"."] && text.length == 0) {
            return NO;
        }
    }
    return YES;
}
//提现
- (IBAction)clickBtmBtn:(id)sender {
    [self showWithSuccessResult];
}
- (void)showWithSuccessResult
{
    [self.view endEditing:YES];
    UIView * resultView = [UIView new];
    resultView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:resultView];
    [resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        } else {
            make.top.right.left.bottom.mas_equalTo(self.view);
        }
    }];
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"withdraw_success"]];
    [resultView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(resultView).offset(100);
        make.centerX.mas_equalTo(resultView);
        make.height.width.mas_equalTo(168);
    }];
    UILabel * label = [UILabel new];
    label.text = @"提现成功!";
    label.textColor = kTitleColor;
    label.font = [UIFont boldSystemFontOfSize:16];
    [resultView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom);
        make.centerX.mas_equalTo(imgView);
    }];
}
//全部提现
- (IBAction)withdrawAllmoney:(id)sender {
    self.tf.text = @"358.25";
    [self checkBtmbtn];
}
//提现方式
- (IBAction)clickSelBtn:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.currentBtn.selected = NO;
    sender.selected = YES;
    self.currentBtn = sender;
    [self checkBtmbtn];
}
//监听输入框的改变
- (IBAction)tfChanged:(id)sender {
    [self checkBtmbtn];
    CGFloat money = self.tf.text.floatValue;
    if (money > 358.25) {
        self.hintLabel.text = @"输入金额超出红包余额";
        self.hintLabel.textColor = kOrangeColor;
        self.rigBtn.hidden = YES;
    } else {
        self.hintLabel.text = @"本次可提现￥358.25，";
        self.hintLabel.textColor = kTitleColor;
        self.rigBtn.hidden = NO;
    }
}

//设置底部按钮是否可用
- (void)checkBtmbtn
{
    CGFloat money = self.tf.text.floatValue;
    if (self.currentBtn == nil || self.tf.text.floatValue <= 0 || money > 358.25) {
        self.btmBtn.userInteractionEnabled = NO;
        [self.btmBtn setBackgroundImage:[UIImage imageNamed:@"btn_unenable"] forState:UIControlStateNormal];
        return;
    }
    self.btmBtn.userInteractionEnabled = YES;
    [self.btmBtn setBackgroundImage:[UIImage imageNamed:@"btn_enable"] forState:UIControlStateNormal];
}
@end
