//
//  KKBZSingelSilderView.h
//  game
//
//  Created by linsheng on 2019/1/5.
//  Copyright © 2019年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKBZSingelSilderView : UISlider
@property (nonatomic,strong) void(^valueChangeBlock)(NSInteger value);
@end

NS_ASSUME_NONNULL_END
