//
//  HKRBZRefreshManager.m
//  Housekeeper
//
//  Created by bazinga on 16/7/15.
//  Copyright © 2016年 zpf. All rights reserved.
//

#import "HKRBZRefreshManager.h"

@interface HKRBZRefreshManager()
@property (nonatomic, assign) BOOL animationLock;

@end
@implementation HKRBZRefreshManager
- (id)init
{
    if (self=[super init]) {
        _fDefaultLoadingPointY=70;
        self.frame=CGRectMake(0, -_fDefaultLoadingPointY, kScreenWidth, _fDefaultLoadingPointY);
        _labelTitle=[[UILabel alloc] initWithText:@"" color:[UIColor grayColor] fontSize:15 forFrame:CGRectMake(100, 0, self.width, self.height)];
        [self addSubview:_labelTitle];
    }
    return self;
}
- (void)setColorDefault:(UIColor *)colorDefault
{
    _colorDefault=colorDefault;
    _labelTitle.textColor=colorDefault;
    _circleView.colorDefault=colorDefault;
}
- (void)setState:(BZPullRefreshState)aState{
    
    switch (aState) {

        case BZPullRefreshNormal:
            //隐藏动画
//             DLOG(@"BZPullRefreshNormal");
            _labelTitle.text=@"下拉刷新";
            _circleView.progress=0;
            _circleView.animation=false;
            break;
        case BZPullRefreshLoading: {
            //显示动画
//             DLOG(@"BZPullRefreshLoading");
            _labelTitle.text=@"刷新中...";
            _circleView.progress=1;
            _circleView.animation=true;
            break;
        }
        case BZPullRefreshSliding: {
            _labelTitle.text=@"下拉刷新";
//             DLOG(@"BZPullRefreshSliding");
             _circleView.animation=false;
            break;
        }
        case BZPullRefreshSlided: {
            _labelTitle.text=@"释放刷新";
//            DLOG(@"BZPullRefreshSliding");
            _circleView.animation=false;
            break;
        }
        default:
            
            break;
    }
    
    _state = aState;
}
#pragma mark -
#pragma mark ScrollView Methods
- (void)bzScrollViewDidScrollWithDragging:(BOOL)dragging
{
    if (_state==BZPullRefreshLoading||_loading) {
        return;
    }
    if (dragging) {
        [self scrollViewSliding];
//        DLOG(@"dragging");
    }
    else
    {
        
        if (_state==BZPullRefreshSliding||_state==BZPullRefreshSlided) {
            DLOG(@"dragEnd");
            [self scrollViewSlideEnd];
        }
    }
}

- (void)scrollViewSliding
{
    
    
    if (self.scrollViewMain.contentOffset.y < -self.originalTopInset&&!self.isLoading) {
        float moveY = fabs(self.scrollViewMain.contentOffset.y+self.originalTopInset);
        if (moveY > _fDefaultLoadingPointY)
            moveY = _fDefaultLoadingPointY;
        [self setProgress:(moveY-15) / (_fDefaultLoadingPointY-15)];
        [_circleView setNeedsDisplay];
        if ((self.scrollViewMain.contentOffset.y+self.originalTopInset)<-_fDefaultLoadingPointY) {
            [self setState:BZPullRefreshSlided];
            
        }
        else
        {
            [self setState:BZPullRefreshSliding];
        }
    }
}
- (void)scrollViewSlideEnd
{
    if (_state==BZPullRefreshLoading) {
        return;
    }
    if (_state == BZPullRefreshSlided) {//self.scrollViewMain.contentOffset.y <= -_fDefaultLoadingPointY&& !self.isLoading&&_state != BZPullRefreshLoading
//        if (_blockTriggerRefresh) {
//            _blockTriggerRefresh();
//        }
//        [self setState:BZPullRefreshLoading];
//        [self setScrollViewContentInsetForLoading];
        if (_blockTriggerRefresh) {
            _blockTriggerRefresh();
        }
        [self setState:BZPullRefreshLoading];
        [self setScrollViewContentInsetForLoadingWithAnimation:true];
        
    }
    else  [self setState:BZPullRefreshNormal];
}

- (BOOL)beginRefreshing
{
    if (_state!=BZPullRefreshLoading) {
        if (_blockTriggerRefresh) {
            _blockTriggerRefresh();
        }
        [self setState:BZPullRefreshLoading];
        [self setScrollViewContentInsetForLoadingWithAnimation:false];
        return true;
    }
    return false;
}
- (void)endRefreshing {
    self.loading=false;
    if (self.state!=BZPullRefreshNormal) {
//        [self resetScrollViewContentInset];
//        self.loading=false;
//        [self setState:BZPullRefreshNormal];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(delayAnimation) withObject:nil afterDelay:0.3];
    }
   
    
}
- (void)delayAnimation
{
    if (self.state!=BZPullRefreshNormal&&!_animationLock) {
        [self resetScrollViewContentInset];
    }
    
}
- (void)setProgress:(float)p {
    if (p<0) {
        p=0;
    }
    else if(p>1)
    {
        p=1;
    }
    _circleView.progress=p;
}
#pragma marwk - Scroll View

- (void)resetScrollViewContentInset {
    self.topInsetLock=true;
    UIEdgeInsets currentInsets = self.scrollViewMain.contentInset;
    currentInsets.top = self.originalTopInset;
    _animationLock=true;
    hnuSetWeakSelf;
    [self setScrollViewContentInset:currentInsets block:^(BOOL finished)
     {
         [weakSelf setState:BZPullRefreshNormal];
         weakSelf.animationLock=false;
     } time:0.3];
}

- (void)setScrollViewContentInsetForLoadingWithAnimation:(BOOL)animation {
//    CGFloat offset = 0;//MAX(self.scrollViewMain.contentOffset.y * -1, 0);
    self.topInsetLock=true;
    UIEdgeInsets currentInsets = self.scrollViewMain.contentInset;
    currentInsets.top = self.originalTopInset + self.bounds.size.height;//MIN(offset, );
//
    if (animation) {

        [self setScrollViewContentInset:currentInsets block:nil time:0.1];
    }
    else
    {
        [self.scrollViewMain setContentOffset:CGPointMake(0, -currentInsets.top)];
       [self.scrollViewMain setContentInset:currentInsets];
    }
//    [self.scrollViewMain setContentOffset:CGPointMake(0, 0)];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset block:(void (^ __nullable)(BOOL finished))completion time:(float)time {
    [UIView animateWithDuration:time
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|
     UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.scrollViewMain.contentInset = contentInset;
                     }
                     completion:^(BOOL finished)
     {
         if (completion) {
             completion(finished);
         }
         
     }];
}
@end
