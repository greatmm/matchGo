//
//  HNUBZChoiceView.h
//  test
//
//  Created by linsheng on 2018/7/23.
//  Copyright © 2018年 linsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNUSelectView.h"
@class HNUBZChoiceView;
@protocol HNUBZChoiceViewDelegate <HNUSelectViewDelegate,NSObject>

- (void)bzChoiceTouchView:(HNUBZChoiceView *)choiceView title:(NSString *)title;

@end
@interface HNUBZChoiceView : UIView
//拦截点击事件view
@property (nonatomic, strong) NSMutableArray *arrayTouchControl;
//选项栏高度
@property (nonatomic, assign) float fSelectHeight;
//百分比位置
@property (nonatomic, assign) float fPercentageY;
@property (nonatomic, strong) HNUSelectView *selectView;
@property (nonatomic, assign) id <HNUBZChoiceViewDelegate>delegate;
- (id)initWithDeault:(NSArray *)titles frame:(CGRect)frame delegate:(id<HNUBZChoiceViewDelegate>)delegate;
- (void)handleItemButtonNew:(NSInteger)index;
- (void)resetAllInfo;
- (void)setPercentage;
@end
