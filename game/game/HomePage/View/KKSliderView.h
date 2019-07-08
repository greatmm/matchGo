//
//  KKSliderView.h
//  game
//
//  Created by GKK on 2018/8/14.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKSliderView : UIView
/**
 设置最小值
 */
@property (nonatomic,assign)CGFloat minNum;

/**
 设置最大值
 */
@property (nonatomic,assign)CGFloat maxNum;
/**
 显示较小的数btn
 */
@property (nonatomic,strong)UIButton *minBtn;
/**
 显示较大的数btn
 */
@property (nonatomic,strong)UIButton *maxBtn;
/**
 显示 min 滑块
 */
@property (nonatomic,strong)UIButton *minSlider;

/**
 显示 max 滑块
 */
@property (nonatomic,strong) UIButton * maxSlider;
@property (nonatomic,assign) BOOL layout;
@property (nonatomic,strong) void(^minValueChangeBlock)(NSInteger minValue);
@property (nonatomic,strong) void(^maxValueChangeBlock)(NSInteger maxValue);
@property (nonatomic,assign) NSInteger currentMin;
@property (nonatomic,assign) NSInteger currentMax;
@end
