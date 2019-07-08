//
//  KKSetPwdViewController.m
//  game
//
//  Created by GKK on 2018/10/24.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKSetPwdViewController.h"

@interface KKSetPwdViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *pwdLabelArr;//输入密码的六个label
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *ensurePwdLabelArr;//确认密码的六个label
@property (weak, nonatomic) IBOutlet UIButton *btmBtn;//底部按钮
@property (nonatomic,strong) UITextView * tf;//弹出键盘用的
@property (nonatomic,assign) BOOL isEnsure;//当前是第一次输入还是确认
@property (nonatomic,strong) NSMutableString * firstPwd;//输入的密码字符串
@property (nonatomic,strong) NSMutableString * secondPwd;//确认密码字符串
@end
#warning todo 设置提现密码接口
@implementation KKSetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //●
    self.navigationItem.title = @"设置提现密码";
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.firstPwd = [NSMutableString new];
    self.secondPwd = [NSMutableString new];
    [self checkBtn];
}
//点击右上角返回
-(void)goBack
{
    if (self.isEnsure) {
        //返回第一次输入密码
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.navigationItem.title = @"设置提现密码";
        self.isEnsure = NO;
        [self checkBtn];
    } else {
        //返回上一级
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //添加阴影
    UIView * subView = self.scrollView.subviews.firstObject;
    for (UIView * sub in subView.subviews) {
        [sub addShadowWithFrame:sub.bounds shadowOpacity:0.15 shadowColor:kTitleColor shadowOffset:CGSizeZero];
    }
    [self showKeyboard:nil];
}
- (IBAction)showKeyboard:(id)sender {
    [self.tf becomeFirstResponder];
}
-(UITextView *)tf
{
    if (_tf == nil) {
        _tf = [UITextView new];
        _tf.frame = CGRectZero;
        [self.view addSubview:_tf];
        _tf.delegate = self;
        _tf.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _tf;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.isEnsure == NO) {
        if ([text isEqualToString:@""]) {
            //点击了删除
            if (self.firstPwd.length) {
                //如果有输入，则把最后一位删除，把UI显示为“”
                UILabel * l = self.pwdLabelArr[self.firstPwd.length - 1];
                l.text = @"";
                [self.firstPwd deleteCharactersInRange:NSMakeRange(self.firstPwd.length -1, 1)];
            }
        } else {
            //如果已经够6位了，则不做处理
            if (self.firstPwd.length == 6) {
                return NO;
            }
            //不够六位就拼接输入内容，更新UI
            [self.firstPwd appendString:text];
            UILabel * l = self.pwdLabelArr[self.firstPwd.length - 1];
            l.text = @"●";
            //如果刚好输入够六位，则结束编辑进入确认密码界面
            if (self.firstPwd.length == 6) {
                self.isEnsure = YES;
                self.navigationItem.title = @"重复提现密码";
                [self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
            }
        }
        
    } else {
        if ([text isEqualToString:@""]) {
            //删除按钮的处理
            if (self.secondPwd.length) {
                //如果有输入清除最后一位
                UILabel * l = self.ensurePwdLabelArr[self.secondPwd.length - 1];
                l.text = @"";
                [self.secondPwd deleteCharactersInRange:NSMakeRange(self.secondPwd.length -1, 1)];
            }
        } else {
            if (self.secondPwd.length == 6) {
                return NO;
            }
            //否则就拼接新输入的内容
            [self.secondPwd appendString:text];
            UILabel * l = self.ensurePwdLabelArr[self.secondPwd.length - 1];
            l.text = @"●";
            //如果输入刚好够了6位，则结束编辑
            if (self.secondPwd.length == 6) {
                [self.view endEditing:YES];
            }
        }
    }
    [self checkBtn];//每次输入都检测底部按钮是否可用
    return NO;
}
//更改底部按钮是否可以点击
-(void)checkBtn
{
    if (self.isEnsure) {
        if (self.secondPwd.length == 6) {
            self.btmBtn.userInteractionEnabled = YES;
            [self.btmBtn setBackgroundImage:[UIImage imageNamed:@"btn_enable"] forState:UIControlStateNormal];
        } else {
            self.btmBtn.userInteractionEnabled = NO;
            [self.btmBtn setBackgroundImage:[UIImage imageNamed:@"btn_unenable"] forState:UIControlStateNormal];
        }
    } else {
        if (self.firstPwd.length == 6) {
            self.btmBtn.userInteractionEnabled = YES;
            [self.btmBtn setBackgroundImage:[UIImage imageNamed:@"btn_enable"] forState:UIControlStateNormal];
        } else {
            self.btmBtn.userInteractionEnabled = NO;
            [self.btmBtn setBackgroundImage:[UIImage imageNamed:@"btn_unenable"] forState:UIControlStateNormal];
        }
    }
}
- (IBAction)clickBtmBtn:(id)sender {
    if (self.isEnsure) {
        if ([self.firstPwd isEqualToString:self.secondPwd]) {
            [KKAlert showText:@"密码设置成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [KKAlert showText:@"两次输入的密码不一致"];
        }
    } else {
        self.navigationItem.title = @"重复提现密码";
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        self.isEnsure = YES;
        [self checkBtn];
    }
    
}

@end
