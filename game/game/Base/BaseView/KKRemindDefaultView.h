//
//  KKRemindDefaultView.h
//  game
//
//  Created by linsheng on 2018/12/25.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKRemindDefaultView : UIView
@property (strong,nonatomic) void(^remindDefaultViewButtonBlock)(NSString *title);
- (void)resetToNeedLoginView;
@end

NS_ASSUME_NONNULL_END
