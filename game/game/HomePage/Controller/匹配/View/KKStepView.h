//
//  KKStepView.h
//  game
//
//  Created by greatkk on 2018/11/22.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKStepView : UIView
@property (strong,nonatomic) NSArray * titleArr;//标题数组
@property (assign,nonatomic) NSInteger currentStep;//当前是第几步
@end

NS_ASSUME_NONNULL_END
