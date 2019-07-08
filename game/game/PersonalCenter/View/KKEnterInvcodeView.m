//
//  KKEnterInvcodeView.m
//  game
//
//  Created by greatkk on 2019/1/14.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKEnterInvcodeView.h"

@interface KKEnterInvcodeView()<UITextViewDelegate>
@property (strong,nonatomic) UIView * contentView;
@property (strong,nonatomic) NSArray <UILabel*>*labels;
@property (strong,nonatomic) NSArray <UIView*>*lines;
@property (strong,nonatomic) UIButton * btmBtn;
@property (strong,nonatomic) NSMutableString * inviteStr;
@property (strong,nonatomic) UITextView * tv;
@end

@implementation KKEnterInvcodeView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self addSubview:self.tv];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
+(instancetype)shareInvcodeView
{
    KKEnterInvcodeView * invCodeView = [[KKEnterInvcodeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return invCodeView;
}
#pragma mark - 添加子试图
-(void)initSubviews
{
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enterInvcode"]];
    [self.contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.centerX.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(57);
    }];
    NSMutableArray * arr = [NSMutableArray new];
    NSMutableArray * lineArr = [NSMutableArray new];
    CGFloat w = CGRectGetWidth(imgView.bounds) * 0.25;
    for (int i = 0; i < 4; i ++) {
        UILabel * l = [UILabel new];
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont fontWithName:@"bahnschrift" size:40];
        [self.contentView addSubview:l];
        l.text = @"";
        l.textColor = kThemeColor;
        [arr addObject:l];
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgView.mas_left).offset(w * i);
            make.top.mas_equalTo(imgView.mas_bottom).offset(30);
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(40);
        }];
        UIView * line = [UILabel new];
        line.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        [self.contentView addSubview:line];
        [lineArr addObject:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(l.mas_bottom).offset(2);
            make.centerX.mas_equalTo(l);
            make.width.mas_equalTo(w - 14);
            make.height.mas_equalTo(1);
        }];
    }
    self.lines = lineArr;
    self.labels = arr;
    UIControl * contorl = [UIControl new];
    [self.contentView addSubview:contorl];
    [contorl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(imgView);
        make.top.mas_equalTo(self.labels.firstObject);
        make.bottom.mas_equalTo(self.lines.firstObject);
    }];
    [contorl addTarget:self action:@selector(showKeyboard) forControlEvents:UIControlEventTouchUpInside];
    UILabel * l = [UILabel new];
    l.text = @"您和邀请您的好友都能获得1张锦标赛入场券";
    l.font = [UIFont systemFontOfSize:11];
    l.textColor = [UIColor colorWithWhite:153/255.0 alpha:1];
    [self.contentView addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.lines.firstObject.mas_bottom).offset(20);
    }];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.backgroundColor = kThemeColorTranslucence;
    btn.userInteractionEnabled = NO;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 3;
    [btn addTarget:self action:@selector(invitePeople) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(l.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
    }];
    self.btmBtn = btn;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self);
    }];
    self.contentView.layer.cornerRadius = 10;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"rightTopClose"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.contentView);
        make.height.width.mas_equalTo(28);
    }];
}
#pragma mark - 点击关闭按钮
- (void)clickCloseBtn
{
   [self removeFromSuperview];
}
#pragma mark - 点击底部按钮
- (void)invitePeople
{
    if (self.inviteStr.length != 4) {
        [KKAlert showText:@"请输入四位邀请码" toView:self];
        return;
    }
    if (self.clickBtmBtnBlock) {
        __weak typeof(self) weakSelf = self;
        NSString * upperStr = [weakSelf.inviteStr uppercaseString];
        self.clickBtmBtnBlock(upperStr);
    }
    [self removeFromSuperview];
}
#pragma mark - 获取到的输入的字符串
-(NSMutableString *)inviteStr
{
    if (_inviteStr) {
        return _inviteStr;
    }
    _inviteStr = [NSMutableString string];
    return _inviteStr;
}
#pragma mark - 检测底部按钮是否可用
- (void)checkBtmBtn
{
    if (self.inviteStr.length == 4) {
        self.btmBtn.userInteractionEnabled = YES;
        self.btmBtn.backgroundColor = kThemeColor;
    } else {
        self.btmBtn.userInteractionEnabled = NO;
        self.btmBtn.backgroundColor = kThemeColorTranslucence;
    }
}
#pragma mark - 键盘即将弹出
-(void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    CGFloat maxY = CGRectGetMaxY(self.contentView.frame);
    CGFloat y = ScreenHeight - maxY;//距离底部的距离
    if (y < keyboardHeight + 10) {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self).offset(-keyboardHeight - 10 + y);
        }];
        [self layoutIfNeeded];
    }
}
#pragma mark - 键盘即将消失
- (void)keyboardWillHide:(NSNotification *)noti
{
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
    }];
    [self layoutIfNeeded];
}
#pragma mark - 输入的处理，显示输入的字符
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * str = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    if (!([str containsString:text] || [text isEqualToString:@""])) {
        return false;
    }
    if ([text isEqualToString:@""]) {
        if (self.inviteStr.length) {
            UILabel * l = self.labels[self.inviteStr.length - 1];
            l.text = @"";
            UIView * line = self.lines[self.inviteStr.length - 1];
            line.backgroundColor = [UIColor colorWithWhite:153/255.0 alpha:1];
            [self.inviteStr deleteCharactersInRange:NSMakeRange(self.inviteStr.length - 1, 1)];
            [self checkBtmBtn];
        }
    } else {
        if (self.inviteStr.length == 4) {
            return NO;
        }
        UILabel * l = self.labels[self.inviteStr.length];
        l.text = text;
        UIView * line = self.lines[self.inviteStr.length];
        line.backgroundColor = kThemeColor;
        [self.inviteStr appendString:text];
        [self checkBtmBtn];
    }
    return NO;
}
-(UITextView *)tv
{
    if (_tv == nil) {
        _tv = [UITextView new];
        _tv.frame = CGRectZero;
        _tv.delegate = self;
        _tv.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _tv;
}

#pragma mark - 弹出键盘
- (void)showKeyboard {
    [self.tv becomeFirstResponder];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 点击空白回收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
@end
