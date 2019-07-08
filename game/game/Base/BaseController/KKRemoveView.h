//
//  KKRemoveView.h
//  game
//
//  Created by GKK on 2018/10/12.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKRemoveView : UIView
@property (nonatomic,strong) void(^removeBlock)(void);
@end

NS_ASSUME_NONNULL_END
