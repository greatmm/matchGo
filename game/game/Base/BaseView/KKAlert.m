//
//  KKAlert.m
//  game
//
//  Created by Jack on 2018/8/9.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKAlert.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "Appdelegate.h"
@implementation KKAlert
+ (void)showText:(NSString *)text
{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [[self class] showText:text toView:[app currentVc].view];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
//    [SVProgressHUD setFont:[UIFont systemFontOfSize:14]];
//    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:text];
//    [SVProgressHUD setCornerRadius:20];
////    [SVProgressHUD showWithStatus:text];
//    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:189/255.0 alpha:1]];
//    [SVProgressHUD dismissWithDelay:1.5];
}

+ (void)showAnimateWithStauts:(NSString *)status
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD showWithStatus:status];
}
+ (void)dismiss
{
    [SVProgressHUD dismiss];
}
+ (void)showErrorHint:(NSString *)hint
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD showErrorWithStatus:hint];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD dismissWithDelay:1.5];
}
+ (void)showSuccessHint:(NSString *)hint
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD showSuccessWithStatus:hint];
    [SVProgressHUD dismissWithDelay:1.5];
}
+ (void)showHint:(NSString *)hint
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD showWithStatus:hint];
    [SVProgressHUD dismissWithDelay:1.5];
}
+ (void)showText:(NSString *)text toView:(UIView *)aView
{
    MBProgressHUD * hud = [MBProgressHUD HUDForView:aView];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    }
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:189/255.0 alpha:1];
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:1.5];
}
+ (void)showAnimateWithText:(NSString *)text toView:(UIView *)aView
{
    MBProgressHUD * hud = [MBProgressHUD HUDForView:aView];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    if (text) {
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
    }
    [hud showAnimated:YES];
}
+ (void)dismissWithView:(UIView *)aView
{
    [MBProgressHUD hideHUDForView:aView animated:YES];
}
@end
