//
//  KKAuthCodeView.m
//  game
//
//  Created by GKK on 2018/8/15.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKAuthCodeView.h"
@interface KKAuthCodeView()
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (nonatomic,strong) NSMutableDictionary * paraDic;
@end
#warning todo 获取验证码时提示，获取失败时刷新的图片
@implementation KKAuthCodeView
+(instancetype)shareCodeView
{
   KKAuthCodeView * codeView = [[NSBundle mainBundle] loadNibNamed:@"KKAuthCodeView" owner:nil options:nil].firstObject;
    codeView.frame = [UIScreen mainScreen].bounds;
    codeView.paraDic = [NSMutableDictionary new];
    [codeView refreshAuthCode:codeView.imgBtn];
    return codeView;
}
- (IBAction)refreshAuthCode:(id)sender {
//    [MBProgressHUD showHUDAddedTo:self.imgBtn animated:YES];
    [KKNetTool getCaptchaSuccessBlock:^(NSDictionary *dic) {
        NSString * img = dic[@"img"];
        if (dic[@"ck"]) {
            self.paraDic[@"ck"] = dic[@"ck"];
        }
//        [MBProgressHUD hideHUDForView:self.imgBtn animated:YES];
        if ([img containsString:@"base64,"]) {
            NSArray * arr = [img componentsSeparatedByString:@"base64,"];
            NSString * imgStr = arr.lastObject;
            NSData *decodedImageData = [[NSData alloc]initWithBase64EncodedString:imgStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
            [self.imgBtn setBackgroundImage:decodedImage forState:UIControlStateNormal];
        }
        
    } erreorBlock:^(NSError *error) {
//        NSLog(@"%@",error);
//        [MBProgressHUD hideHUDForView:self.imgBtn animated:YES];
    }];
}
- (IBAction)clickEnsureBtn:(id)sender {
    NSString * str = self.tf.text;
    if (str.length != 5) {
        [KKAlert showText:@"输入的检测码有误" toView:self];
        return;
    }
    self.paraDic[@"captcha"] = str;
    __weak typeof(self) weakSelf = self;
    if (self.ensureBlock) {
        self.ensureBlock(weakSelf.paraDic);
    }
    [self removeFromSuperview];
}

- (IBAction)clickCloseBtn:(id)sender {
    [self removeFromSuperview];
}

@end
