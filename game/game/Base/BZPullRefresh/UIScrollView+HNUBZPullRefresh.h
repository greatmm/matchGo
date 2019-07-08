//
//  UIScrollView+HNUBZPullRefresh.h
//  cloudpet
//
//  Created by linsheng on 2017/11/8.
//  Copyright © 2017年 bazinga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKRBZRefreshManager.h"
@interface UIScrollView (HNUBZPullRefresh)
@property (nonatomic, strong) HKRBZRefreshManager *bzRefreshManager;
- (void)addHNUPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
//- (void)addHNUInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
@end
