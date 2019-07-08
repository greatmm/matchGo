//
//  UITableView+Common.m
//  MaiTalk
//
//  Created by Joy on 15/8/11.
//  Copyright (c) 2015年 duomai. All rights reserved.
//

#import "UITableView+Common.h"
#import <objc/runtime.h>
#import "KKRemindDefaultView.h"
static UIView *defaultHeaderView = nil;
@implementation UITableView (Common)
+ (void)load
{
    Method reloadData    = class_getInstanceMethod(self, @selector(reloadData));
    Method xy_reloadData = class_getInstanceMethod(self, @selector(xy_reloadData));
    method_exchangeImplementations(reloadData, xy_reloadData);
}

- (void)setManualShowDefaultView:(BOOL)manualShowDefaultView {

    objc_setAssociatedObject(self, @selector(manualShowDefaultView), @(manualShowDefaultView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL )manualShowDefaultView{
    NSNumber *number=objc_getAssociatedObject(self, _cmd);
    return number.boolValue;
}
- (void)setMtk_remindDefaultView:(KKRemindDefaultView *)mtk_remindDefaultView {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[KKRemindDefaultView class]]) {
            [subView removeFromSuperview];
            break;
        }
    }
    objc_setAssociatedObject(self, @selector(mtk_remindDefaultView), mtk_remindDefaultView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KKRemindDefaultView *)mtk_remindDefaultView{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tableFooterView = [[UIView alloc]init];
    
}


-(void)setIsShowNothingReminderView:(BOOL)isShowNothingReminderView
{
    
    if (!self.mtk_remindDefaultView) {
        self.mtk_remindDefaultView=[[KKRemindDefaultView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    if (!self.mtk_remindDefaultView.superview) {
        if (self.mtk_remindDefaultView.width != self.width) {
            self.mtk_remindDefaultView.width = self.width;
            if (self.contentInset.top > 0) {
                if (self.mtk_remindDefaultView.height != self.height - self.contentInset.top) {
                    self.mtk_remindDefaultView.height = self.height - self.contentInset.top;
                }
            }else {
                if (self.mtk_remindDefaultView.height != self.height) {
                    self.mtk_remindDefaultView.height = self.height;
                }
            }
        }
        [self addSubview:self.mtk_remindDefaultView];
    }
    self.mtk_remindDefaultView.hidden = !isShowNothingReminderView;
}

-(BOOL)isShowNothingReminderView
{
    return !self.mtk_remindDefaultView.hidden;
}

- (UIView *)defaultHeaderView {
    if (!defaultHeaderView) {
        defaultHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    }
    return defaultHeaderView;
}
- (void)setDefaultHeaderView {
    self.tableHeaderView = [self defaultHeaderView];
}
#pragma mark reload
- (void)xy_reloadData
{
    [self xy_reloadData];
    //  刷新完成之后检测数据量
    if (!self.manualShowDefaultView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSInteger numberOfSections = [self numberOfSections];
            BOOL havingData = NO;
            for (NSInteger i = 0; i < numberOfSections; i++) {
                if ([self numberOfRowsInSection:i] > 0) {
                    havingData = YES;
                    break;
                }
            }
            
            self.isShowNothingReminderView=!havingData;
        });
    }
}
@end
