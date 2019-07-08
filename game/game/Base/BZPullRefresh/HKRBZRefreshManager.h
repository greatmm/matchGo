//
//  HKRBZRefreshManager.h
//  Housekeeper
//
//  Created by bazinga on 16/7/15.
//  Copyright © 2016年 zpf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HKRAddScrollAnimationView.h"
#import "HKRBZCircleView.h"
typedef enum{
    BZPullRefreshNormal,
    BZPullRefreshSliding,//显示下拉刷新
    BZPullRefreshSlided,//显示释放刷新
    BZPullRefreshLoading,
} BZPullRefreshState;
typedef void (^HKRBZRefreshManagerBlock) (void);
@interface HKRBZRefreshManager : HKRAddScrollAnimationView
@property (nonatomic, strong) HKRBZCircleView *circleView;
@property (nonatomic, copy) HKRBZRefreshManagerBlock blockTriggerRefresh;
@property (nonatomic, assign) BZPullRefreshState state;
@property (nonatomic, assign, getter = isLoading) BOOL loading;
@property (nonatomic, assign) float fDefaultLoadingPointY;//默认70
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIColor *colorDefault;
- (BOOL)beginRefreshing;//显示动画
- (void)endRefreshing;//结束动画
@end
