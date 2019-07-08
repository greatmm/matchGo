//
//  KKAlert.h
//  game
//
//  Created by Jack on 2018/8/9.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKAlert : NSObject
+ (void)showAnimateWithStauts:(NSString *)status;
+ (void)dismiss;
+ (void)showErrorHint:(NSString *)hint;
+ (void)showSuccessHint:(NSString *)hint;
+ (void)showHint:(NSString *)hint;
+ (void)showText:(NSString *)text;
//mbprogresshud
+ (void)showText:(NSString *)text toView:(UIView *)aView;
+ (void)showAnimateWithText:(NSString *)text toView:(UIView *)aView;
+ (void)dismissWithView:(UIView *)aView;
@end
