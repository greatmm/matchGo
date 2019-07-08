//
//  KKSingleSlider.h
//  game
//
//  Created by GKK on 2018/10/17.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKSingleSlider : UIView
@property (nonatomic,strong) void(^minValueChangeBlock)(NSInteger minValue);
@property (nonatomic,assign) NSInteger currentMin;

@end

NS_ASSUME_NONNULL_END
