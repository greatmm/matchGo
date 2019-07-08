//
//  KKWechatPayBindViewController.m
//  game
//
//  Created by GKK on 2018/10/24.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKWechatPayBindViewController.h"

@interface KKWechatPayBindViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UIButton *btmBtn;
@end

@implementation KKWechatPayBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"微信绑定";
    self.navigationItem.rightBarButtonItem = nil;
    [self checkBtn];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIView * supView = self.nameTf.superview;
    [supView addShadowWithFrame:supView.bounds shadowOpacity:0.15 shadowColor:kTitleColor shadowOffset:CGSizeZero];
}
- (IBAction)tfChanged:(id)sender {
    [self checkBtn];
}
-(void)checkBtn
{
    
    if (self.nameTf.text.length == 0) {
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
- (IBAction)clickBtmBtn:(id)sender {
    
}
@end
