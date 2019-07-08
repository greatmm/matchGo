//
//  HKRAddScrollAnimationView.m
//  Housekeeper
//
//  Created by bazinga on 16/7/21.
//  Copyright © 2016年 zpf. All rights reserved.
//

#import "HKRAddScrollAnimationView.h"

@implementation HKRAddScrollAnimationView

- (void)setScrollViewMain:(UIScrollView *)scrollViewMain
{
    _scrollViewMain=scrollViewMain;
    [_scrollViewMain addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollViewMain addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollViewMain addSubview:self];
    self.originalTopInset=self.scrollViewMain.contentInset.top;
    
//    [_scrollViewMain addObserver:self forKeyPath:@"dragging" options:NSKeyValueObservingOptionNew context:nil];
//    [_scrollViewMain addObserver:self forKeyPath:@"decelerating" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    if ([keyPath isEqualToString:@"dragging"]) {
//        [self bzScrollViewChangeDragging];
//    }
//    if ([keyPath isEqualToString:@"decelerating"]) {
//        [self bzScrollViewChangeDecelerating];
//    }
    if ([keyPath isEqualToString:@"contentOffset"]) {
//        if (self.scrollViewMain.dragging) {
            [self bzScrollViewDidScrollWithDragging:_scrollViewMain.dragging];
//        }
        
        
    }
    
    if ([keyPath isEqualToString:@"contentInset"]&&!_topInsetLock) {
        self.originalTopInset=self.scrollViewMain.contentInset.top;
        
        
    }
}
- (void)bzScrollViewDidScrollWithDragging:(BOOL)dragging
{
    
}
- (void)bzScrollViewChangeDragging
{
    if (!_scrollViewMain.dragging&&_scrollViewMain.decelerating) {
        [self bzScrollViewEndScroll];
    }
}
- (void)bzScrollViewChangeDecelerating
{
    if (_scrollViewMain.decelerating) {
        [self bzScrollViewEndScroll];
    }
}
- (void)bzScrollViewEndScroll
{
    
}
- (void)dealloc
{
    
    [_scrollViewMain removeObserver:self forKeyPath:@"contentOffset"];
    [_scrollViewMain removeObserver:self forKeyPath:@"contentInset"];
//    [_scrollViewMain removeObserver:self forKeyPath:@"dragging"];
//     [_scrollViewMain removeObserver:self forKeyPath:@"decelerating"];
}
@end
