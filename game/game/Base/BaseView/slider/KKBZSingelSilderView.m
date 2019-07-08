//
//  KKBZSingelSilderView.m
//  game
//
//  Created by linsheng on 2019/1/5.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKBZSingelSilderView.h"
@interface KKBZSingelSilderView()
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end
@implementation KKBZSingelSilderView

- (id)init
{
    if (self=[super init]) {
        [self addGesture];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self addGesture];
    }
    return self;
}
#pragma mark Super
- (void)sliderTouchDown:(UISlider *)sender {
    _tapGesture.enabled = NO;
}

- (void)sliderTouchUp:(UISlider *)sender {
    _tapGesture.enabled = YES;
}
#pragma mark Method
- (void)addGesture
{
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
//    tapGesture.delegate = self;
    [self addGestureRecognizer:_tapGesture];
    [self addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
}
- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:self];
    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.x / self.frame.size.width );
    [self setValue:value animated:YES];
    
}
//- (void)setValue:(float)value
//{
//    [super setValue:value];
//    if (_valueChangeBlock) {
//        _valueChangeBlock(value);
//    }
//}
- (void)setValue:(float)value animated:(BOOL)animated
{
    [super setValue:value animated:animated];
    if (_valueChangeBlock) {
        _valueChangeBlock(value);
    }
}
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds = [super trackRectForBounds:bounds]; // 必须通过调用父类的trackRectForBounds 获取一个 bounds 值，否则 Autolayout 会失效，UISlider 的位置会跑偏。
    return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 7); // 这里面的h即为你想要设置的高度。
}
@end
