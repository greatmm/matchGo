//
//  HKRAddScrollAnimationView.h
//  Housekeeper
//
//  Created by bazinga on 16/7/21.
//  Copyright © 2016年 zpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKRAddScrollAnimationView : UIView
@property (nonatomic, strong) UIScrollView *scrollViewMain;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, assign) BOOL topInsetLock;
//scrolling
- (void)bzScrollViewDidScrollWithDragging:(BOOL)dragging;
//- (void)bzScrollViewDraggingScroll;
//- (void)bzScrollViewDeceleratingScroll;
//end
//- (void)bzScrollViewEndScroll;

@end
