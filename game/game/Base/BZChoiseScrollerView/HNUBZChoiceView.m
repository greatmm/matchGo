//
//  HNUBZChoiceView.m
//  test
//
//  Created by linsheng on 2018/7/23.
//  Copyright © 2018年 linsheng. All rights reserved.
//

#import "HNUBZChoiceView.h"

@implementation HNUBZChoiceView

- (id)init
{
    if (self=[super init]) {
        [self resetAllInfo];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self resetAllInfo];
    }
    return self;
}
- (id)initWithDeault:(NSArray *)titles frame:(CGRect)frame delegate:(id<HNUBZChoiceViewDelegate>)delegate
{
    if (self=[self initWithFrame:frame]) {
        _delegate=delegate;
        [self addDefaultSelectView:titles];
    }
    return self;
}
- (void)addDefaultSelectView:(NSArray *)titles
{
    if (!_selectView) {
        _selectView = [[HNUSelectView alloc] initWithTitles:titles];
        _selectView.frame=CGRectMake(0, self.height-W(44), kScreenWidth, W(44));
        ((HNUSelectView *)_selectView).delegate = _delegate;
        [self addSubview:_selectView];
        [self.arrayTouchControl addObject:_selectView];
        
//        [((HNUSelectView *)_selectView) addLineWithColor:MTK16RGBCOLOR(0xDDDADA)];
    }
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_selectView) {
        [self setPercentage];
    }
}
- (void)setPercentage
{
    float y=-self.frame.origin.y/(self.frame.size.height-_fSelectHeight);
    if (y<0) {
        y=0;
    }
    else if(y>1)
    {
        y=1;
    }
    if (y!=_fPercentageY) {
        self.fPercentageY=y;
    }
}
- (void)setFPercentageY:(float)fPercentageY
{
    _fPercentageY=fPercentageY;
    HNUSelectView *selectView = (HNUSelectView*)_selectView;
    [selectView setPoinr:_fPercentageY];
}
- (void)resetAllInfo
{
    _arrayTouchControl=[@[] mutableCopy];
    _fSelectHeight = kNavigationAllHeight;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *view in _arrayTouchControl) {
        CGPoint convertP = [self convertPoint:point toView:view];
        if (CGRectContainsPoint(view.bounds, convertP)) {
            return true;
        }
    }
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIControl class]]) {
            UIControl *subLabel = (UIControl *)subView;
            CGPoint convertP = [self convertPoint:point toView:subLabel];
            if (!subLabel.hidden&&CGRectContainsPoint(subLabel.bounds, convertP)) {
                [subLabel sendActionsForControlEvents:UIControlEventTouchUpInside];
                break;
            }
        }
    }
    return false;
}

- (void)handleItemButtonNew:(NSInteger)index {
    HNUSelectView *selectView = (HNUSelectView*)_selectView;
    [selectView selectIndex:index];
}
@end
