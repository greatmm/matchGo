//
//  KKAlipayBindViewController.m
//  game
//
//  Created by GKK on 2018/10/24.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKAlipayBindViewController.h"

@interface KKAlipayBindViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *acountTf;
@property (weak, nonatomic) IBOutlet UIButton *btmBtn;
@property (weak, nonatomic) IBOutlet UILabel *btmLabel;

@end

@implementation KKAlipayBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkBtn];//设置button不能点击
    if (self.type != 0) {
        self.navigationItem.title = @"身份验证";
        self.acountTf.placeholder = @"身份证号";
        [self.btmBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.btmLabel.attributedText = nil;
        self.btmLabel.text = @"修改密码需进行身份验证";
    } else {
        self.navigationItem.title = @"支付宝绑定";
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIView * supView = self.nameTf.superview;
    [supView addShadowWithFrame:supView.bounds shadowOpacity:0.15 shadowColor:kTitleColor shadowOffset:CGSizeZero];
}
#warning todo点击下一步未完待续
- (IBAction)clickBtmBtn:(id)sender {
    if (self.type == 0) {
        //绑定支付宝账号
    } else {
       //实名认证
    }
}
- (IBAction)tfChanged:(id)sender {
    [self checkBtn];
}
-(void)checkBtn
{
    if (self.nameTf.text.length == 0 || self.acountTf.text.length == 0) {
        self.btmBtn.userInteractionEnabled = NO;
        [self.btmBtn setBackgroundImage:[UIImage imageNamed:@"btn_unenable"] forState:UIControlStateNormal];
        return;
    }
    self.btmBtn.userInteractionEnabled = YES;
    [self.btmBtn setBackgroundImage:[UIImage imageNamed:@"btn_enable"] forState:UIControlStateNormal];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
