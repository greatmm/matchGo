//
//  KKSilderView.h
//  game
//
//  Created by linsheng on 2018/12/24.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKBZGoldModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKBZSliderView : UIView
//输出value
@property (nonatomic, assign) NSUInteger currentMin;
//双向添加
@property (nonatomic, assign) NSUInteger currentMax;
//回调
@property (strong,nonatomic) void(^silderValueChange)(NSUInteger);
//是否是双向控件
@property (nonatomic,assign) IBInspectable BOOL boolDoubleTwoWay;

- (void)resetWithData:(NSArray <KKBZGoldModel>*)data;
@end

NS_ASSUME_NONNULL_END
