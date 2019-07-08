//
//  KKBZDoubleSliderView.h
//  game
//
//  Created by linsheng on 2018/12/25.
//  Copyright © 2018年 MM. All rights reserved.
//  copy form GKK

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKBZDoubleSliderView : UIView
/**
 设置最小值
 */
@property (nonatomic,assign)float minimumValue;

/**
 设置最大值
 */
@property (nonatomic,assign)float maximumValue;

@property (nonatomic,strong) NSInteger(^minValueChangeBlock)(NSInteger minValue);
@property (nonatomic,strong) NSInteger(^maxValueChangeBlock)(NSInteger maxValue);
@property (nonatomic,assign) NSInteger currentMin;
@property (nonatomic,assign) NSInteger currentMax;

@end

NS_ASSUME_NONNULL_END
