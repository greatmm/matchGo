//
//  KKMoveWindow.m
//  windowTest
//
//  Created by greatkk on 2018/11/8.
//  Copyright © 2018 greatkk. All rights reserved.
//

#import "KKMoveWindow.h"


@interface KKMoveWindow ()
//@property (assign,nonatomic) CGPoint beginPoint;
@end
@implementation KKMoveWindow
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGes];
    }
    return self;
}
//添加移动手势
- (void)addGes
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    pan.delaysTouchesBegan = YES;
    [self addGestureRecognizer:pan];
}
- (void)handlePanGesture:(UIPanGestureRecognizer *)ges
{
    if (self.mj_h != kSmallHouseHeight) {
        return;
    }
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [ges locationInView:appWindow];
    CGFloat y = panPoint.y;
    self.mj_y = y;
//    if (ges.state==UIGestureRecognizerStateBegan) {
//
//    }
    if(ges.state == UIGestureRecognizerStateEnded)
    {
        [self resetPath];
        
    }
    
}
- (void)resetPath
{
    if (self.mj_h != kSmallHouseHeight) {
        return;
    }
    float y=self.mj_y;
    UIViewController *vc=[HNUBZUtil getKeyWindowVisibleViewController];
    float yBottom=44;
//    float yTop=44;
    if(vc.hidesBottomBarWhenPushed)
    {
        yBottom=0;
    }
//    if (vc.navigationController.navigationBar.hidden) {
//        <#statements#>
//    }
//    float bottom=;
    CGFloat navH = kNavigationAllHeight;//[KKDataTool statusBarH];
    CGFloat btmY = isIphoneX?34:0;
    if (y < navH) {
        y = navH;
    } else if(y + btmY + kSmallHouseHeight+yBottom > ScreenHeight){
        y = ScreenHeight - btmY - kSmallHouseHeight-yBottom;
    }
    self.mj_y = y;
}
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"移动了");
//    if (self.frame.size.height != 49) {
//        return;
//    }
//    CGPoint point = [[touches anyObject] locationInView:self];
//    
//    CGRect frame = [self frame];
//    
//    frame.origin.y += point.y - _beginPoint.y;
//    [self setFrame:frame];
//}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"开始");
//    if (self.frame.size.height != 49) {
//        return;
//    }
//    self.beginPoint = [[touches anyObject] locationInView:self]; //记录第一个点，以便计算移动距离
//}
@end
