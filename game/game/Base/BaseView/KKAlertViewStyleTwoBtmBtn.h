//
//  KKAlertViewStyleTwoBtmBtn.h
//  game
//
//  Created by greatkk on 2019/1/7.
//  Copyright © 2019 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKAlertViewStyleTwoBtmBtn : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong,nonatomic) void(^clickLeftBtnBlock)(void);
@property (strong,nonatomic) void(^clickRightBtnBlock)(void);
+(instancetype)shareAlertViewStyleTwoBtmBtn;
+ (void)showRechargeWithVC:(UIViewController *)basicVC amount:(NSInteger)amount block:(MTKCompletionBlock)block;
@end

NS_ASSUME_NONNULL_END
