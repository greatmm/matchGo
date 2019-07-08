//
//  KKBaseViewController.h
//  EasyToWork
//
//  Created by GKK on 2017/11/30.
//  Copyright © 2017年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKBZBasicDataManager.h"
#import "KKRemindDefaultView.h"
@interface KKBaseViewController : UIViewController<UITableViewDelegate>
@property (assign,nonatomic) CGFloat houseBtm;
@property (nonatomic, strong) KKBZBasicDataManager *dataManagerMain;
@property (nonatomic, strong) UITableView *tableViewMain;
//非登录情况下 显示错误logview
@property (nonatomic, assign) BOOL boolLogOutShow;
@property (nonatomic, strong) KKRemindDefaultView *viewLogoutShow;

//设置tableview位置

- (void)setTableviewContain;
- (void)initSuperInfoWithMJ;
- (void)initSuperInfoWithMJ:(BOOL)mj;

- (void)requestData;
- (void)reloadDataWithEnd:(BOOL)end;
@end
