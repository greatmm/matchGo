//
//  KKEnterPwdView.m
//  game
//
//  Created by greatkk on 2018/10/29.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKEnterPwdView.h"

@interface KKEnterPwdView ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelArr;
@property (strong,nonatomic) UITextView * tv;
@property (strong,nonatomic) NSMutableString * pwdStr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centyYConst;
@property (weak, nonatomic) IBOutlet UIButton *btmBtn;//底部按钮

//高度384
@end
@implementation KKEnterPwdView
+(instancetype)shareView
{
    KKEnterPwdView * pwdView = [[NSBundle mainBundle] loadNibNamed:@"KKEnterPwdView" owner:nil options:nil].firstObject;
    [[NSNotificationCenter defaultCenter] addObserver:pwdView selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:pwdView selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [pwdView.tv becomeFirstResponder];
    pwdView.pwdStr = [NSMutableString new];
    [pwdView checkBtmBtn];
    return pwdView;
}
- (void)checkBtmBtn
{
    if (self.pwdStr.length == 5) {
        self.btmBtn.userInteractionEnabled = YES;
        self.btmBtn.backgroundColor = kThemeColor;
    } else {
        self.btmBtn.userInteractionEnabled = NO;
        self.btmBtn.backgroundColor = kThemeColorTranslucence;
    }
}
-(void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    CGFloat y = ScreenHeight * 0.5 - 384 * 0.5;//距离底部的距离
    if (y < keyboardHeight + 10) {
        self.centyYConst.constant = y - keyboardHeight - 10;
        [self layoutIfNeeded];
    }
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    self.centyYConst.constant = 0;
    [self layoutIfNeeded];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""]) {
        if (self.pwdStr.length) {
            UILabel * l = self.labelArr[self.pwdStr.length - 1];
            l.text = @"";
            [self.pwdStr deleteCharactersInRange:NSMakeRange(self.pwdStr.length - 1, 1)];
            [self checkBtmBtn];
        }
    } else {
        if (self.pwdStr.length == 5) {
            return NO;
        }
        UILabel * l = self.labelArr[self.pwdStr.length];
        l.text = text;
        [self.pwdStr appendString:text];
        [self checkBtmBtn];
    }
    return NO;
}
-(UITextView *)tv
{
    if (_tv == nil) {
        _tv = [UITextView new];
        _tv.frame = CGRectZero;
        [self addSubview:_tv];
        _tv.delegate = self;
        _tv.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _tv;
}
- (IBAction)clickCaneclBtn:(id)sender {
    [self removeFromSuperview];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (IBAction)clickEnsureBtn:(id)sender {
    if (self.pwdStr.length != 5) {
        [KKAlert showText:@"请输入五位密码" toView:self];
        return;
    }
    [self removeFromSuperview];
    if (self.ensureBlock) {
        __weak typeof(self)weakSelf = self;
        self.ensureBlock(weakSelf.pwdStr);
    }
}
//弹出键盘
- (IBAction)showKeyboard:(id)sender {
    [self.tv becomeFirstResponder];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
