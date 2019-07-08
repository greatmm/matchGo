//
//  BZPagingScrollView.h
//  game
//
//  Created by linsheng on 2019/1/11.
//  Copyright © 2019年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNUSelectView.h"
#import "KKBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface BZPagingScrollViewController : KKBaseViewController<HNUSelectViewDelegate,UIScrollViewDelegate>
//切换顶部栏(不需要主动切换selectViewMain.index)
@property (nonatomic, strong) HNUSelectView *selectViewMain;
//当前位置（自动与selectViewMain.index同步）
@property (nonatomic, assign) NSInteger index;
//viewcontrollers 实现
@property (nonatomic, strong) NSMutableArray *arrayVCs;
//滑动框
@property (nonatomic, strong) UIScrollView *scrollViewMain;

//view 所有页面绘制区域
@property (nonatomic, strong) UIView *viewMain;
- (void)initWithTitles:(NSArray *)titles vcs:(NSArray *)vcs;
@end

NS_ASSUME_NONNULL_END
