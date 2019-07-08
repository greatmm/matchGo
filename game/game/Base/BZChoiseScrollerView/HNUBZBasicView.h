//
//  HNUBZBasicView.h
//  game
//
//  Created by linsheng on 2018/12/18.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HNUBZBasicView : UIView
@property (nonatomic, strong) UIScrollView *scrollViewBZ;
@property (nonatomic, assign) float floatYBZ;
- (id)initWithFrame:(CGRect)frame scroll:(UIScrollView *)scroll;
@end

NS_ASSUME_NONNULL_END
