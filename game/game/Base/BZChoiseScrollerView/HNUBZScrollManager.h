//
//  HNUBZScrollManager.h
//  test
//
//  Created by linsheng on 2018/7/23.
//  Copyright © 2018年 linsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HNUBZChoiceView.h"
#import "HNUBZBasicView.h"
@interface HNUBZScrollManager : NSObject
//viewcontrollers
@property (nonatomic, strong) NSArray *arrayVCs;
//会动的顶部栏
@property (nonatomic, strong) HNUBZChoiceView *viewHeader;
//主view
@property (nonatomic, strong) UIView *viewMain;
//当前选中的标签
@property (nonatomic, assign) NSInteger indexNow;

//初始化
- (id)initWithViewController:(NSArray <HNUBZBasicView *>*)viewControllers headView:(HNUBZChoiceView *)headView mainView:(UIView *)mainView;
//主动设置标签
- (void)touchAtIndex:(NSInteger)index;
@end
