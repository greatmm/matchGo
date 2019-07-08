//
//  HNUSelectView.h
//  HeiNiu
//
//  Created by Wcy on 16/8/19.
//  Copyright © 2016年 niubang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HNUSelectViewDelegate <NSObject>

-(void)hnuSelectViewDidselectIndex:(NSUInteger)index;

@end

@interface HNUSelectView : UIView

@property(nonatomic, weak)id <HNUSelectViewDelegate>delegate;
@property(nonatomic,assign) NSInteger index;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *viewBG;
@property (nonatomic, strong) UIColor *selectColor;
- (instancetype)initWithTitles:(NSArray *)titleArr titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor selectColor:(UIColor *)selcetColor;
- (instancetype)initWithTitles:(NSArray *)titleArr titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor selectColor:(UIColor *)selectColor selectBgColor:(UIColor *)selectBgColor;
- (instancetype)initWithTitles:(NSArray *)titleArr;
- (void)selectIndex:(NSInteger)index; 
- (void)kSetSelectBarBgColor:(UIColor *)color;
- (void)resetWithTitle:(NSArray *)titleArr;
- (void)addLineWithColor:(UIColor *)color;
- (void) setPoinr:(float)point;
@end
