//
//  CircleView.h
//  Demo8
//
//  Created by bazinga on 11/15/13.
//  Copyright (c) 2013 zpf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKRBZCircleView : UIView

@property (nonatomic, assign) float progress;
@property (nonatomic, assign) BOOL animation;
@property (nonatomic, assign) BOOL boolShowArrow;//default true
@property (nonatomic, strong) UIImageView *imagevArrow;//can change image
@property (nonatomic, strong) UIColor *colorDefault;
@end
