//
//  HNUBZBasicView.m
//  game
//
//  Created by linsheng on 2018/12/18.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "HNUBZBasicView.h"

@implementation HNUBZBasicView

- (id)initWithFrame:(CGRect)frame scroll:(UIScrollView *)scroll
{
    if (self=[super initWithFrame:frame]) {
        _scrollViewBZ=scroll;
        [self addSubview:_scrollViewBZ];
    }
    return self;
}

@end
