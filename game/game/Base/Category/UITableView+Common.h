//
//  UITableView+Common.h
//  MaiTalk
//
//  Created by Joy on 15/8/11.
//  Copyright (c) 2015年 duomai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKRemindDefaultView;
@interface UITableView (Common)
//默认页面框架
@property (nonatomic,strong) KKRemindDefaultView *mtk_remindDefaultView;

@property (nonatomic,readwrite) BOOL isShowNothingReminderView;

@property (nonatomic, assign) IBInspectable BOOL manualShowDefaultView;
/**
 *  设置默认的头
 */
- (void)setDefaultHeaderView;
@end
