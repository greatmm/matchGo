//
//  UIScrollView+HNUBZPullRefresh.m
//  cloudpet
//
//  Created by linsheng on 2017/11/8.
//  Copyright © 2017年 bazinga. All rights reserved.
//

#import "UIScrollView+HNUBZPullRefresh.h"
#import <objc/runtime.h>
@implementation UIScrollView (HNUBZPullRefresh)
-(void)setBzRefreshManager:(HKRBZRefreshManager *)bzRefreshManager
{
    objc_setAssociatedObject(self, @selector(bzRefreshManager), bzRefreshManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(HKRBZRefreshManager *)bzRefreshManager
{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)addHNUPullToRefreshWithActionHandler:(void (^)(void))actionHandler
{
    self.bzRefreshManager=[[HKRBZRefreshManager alloc] init];
    self.bzRefreshManager.scrollViewMain=self;
    self.bzRefreshManager.blockTriggerRefresh=actionHandler;
    self.bzRefreshManager.circleView=[[HKRBZCircleView alloc] initWithFrame:CGRectMake((kScreenWidth-64-12-25)/2, (self.bzRefreshManager.height-25)/2, 25, 25)];
    if (self.width>0&&self.width<kScreenWidth) {
        self.bzRefreshManager.circleView.left=(self.width-64-12-25)/2;
    }
    self.bzRefreshManager.labelTitle.frame=CGRectMake(self.bzRefreshManager.circleView.right+14, self.bzRefreshManager.circleView.top, 64, self.bzRefreshManager.circleView.height);
    self.bzRefreshManager.labelTitle.font=[UIFont systemFontOfSize:14];
    self.bzRefreshManager.labelTitle.textColor=MTKRGBCOLOR(187, 187, 187);
    [self.bzRefreshManager addSubview:self.bzRefreshManager.circleView];
     [self.bzRefreshManager addSubview:self.bzRefreshManager.circleView.imagevArrow];
    [self addSubview:self.bzRefreshManager];
   
}
- (void)addHNUInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler
{
    
}
@end
