//
//  CircleView.m
//  Demo8
//
//  Created by bazinga on 11/15/13.
//  Copyright (c) 2013 zpf. All rights reserved.
//

#import "HKRBZCircleView.h"

@implementation HKRBZCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _colorDefault=MTKRGBCOLOR(187, 187, 187);
        self.imagevArrow=[[UIImageView alloc] initWithFrame:self.frame];
        self.imagevArrow.image=[UIImage imageNamed:@"bzArrow.png"];
        self.imagevArrow.contentMode=UIViewContentModeCenter;
//        [self addSubview:_imagevArrow];
        _boolShowArrow=true;
    }
    return self;
}
- (void)setBoolShowArrow:(BOOL )boolShowArrow
{
    _boolShowArrow=boolShowArrow;
    _imagevArrow.hidden=!boolShowArrow;
}
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//    }
//    return self;
//}
- (void)setColorDefault:(UIColor *)colorDefault
{
    _colorDefault=colorDefault;
    _imagevArrow.image=[_imagevArrow.image imageWithTintColor:colorDefault Alpha:1];
//    _imagevArrow.tintColor=colorDefault;
}
- (void)setAnimation:(BOOL)animation
{
    if (_animation==animation) {
        return;
    }
    _animation=animation;
//    [self endAnimation];
    if (animation) {
        [self showAnimation];
    }
    else [self endAnimation];
}
- (void)setProgress:(float)progress
{
    self.animation=false;
    if (_boolShowArrow) {
        [self showImageArrowAnimationWithValue:progress];
    }
    _progress=progress;
    [self setNeedsDisplay];
}
- (void)showImageArrowAnimationWithValue:(float)value
{
    CGAffineTransform transform;
    if (value>=1) {
        transform=CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
    }
    else transform=CGAffineTransformIdentity;
    if (!CGAffineTransformEqualToTransform(transform, _imagevArrow.transform)) {
//        NSLog(@"donghuadonghua");
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^()
         {
             [_imagevArrow setTransform:transform];
         } completion:nil];
    }
    
//    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.y"];
//    rotate.removedOnCompletion = FALSE;
//    rotate.fillMode = kCAFillModeForwards;
//
//    //Do a series of 5 quarter turns for a total of a 1.25 turns
//    //(2PI is a full turn, so pi/2 is a quarter turn)
//    [rotate setToValue: [NSNumber numberWithFloat: value]];//M_PI / 2
////    rotate.repeatCount = 1;
//
//    rotate.duration = 0.2;
//    //            rotate.beginTime = start;
//    rotate.cumulative = TRUE;
//    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//
//    [_imagevArrow.layer addAnimation:rotate forKey:@"rotateAnimation"];
}
- (void)showAnimation
{
    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotate.removedOnCompletion = FALSE;
    rotate.fillMode = kCAFillModeForwards;
    
    //Do a series of 5 quarter turns for a total of a 1.25 turns
    //(2PI is a full turn, so pi/2 is a quarter turn)
    [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
    rotate.repeatCount = 1000;
//    rotate.timingFunction
    rotate.duration = 0.15;
    //            rotate.beginTime = start;
    rotate.cumulative = TRUE;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [self.layer addAnimation:rotate forKey:@"rotateAnimation"];
}
- (void)endAnimation
{
    [self.layer removeAllAnimations];
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.imagevArrow.frame=self.frame;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, _colorDefault.CGColor);
    CGFloat startAngle = -M_PI/3;
    CGFloat step = 11*M_PI/6 * self.progress;
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, self.bounds.size.width/2-3, startAngle, startAngle+step, 0);
    CGContextStrokePath(context);
    
//    [_imagevArrow setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, M_PI*self.progress)];
}

@end

