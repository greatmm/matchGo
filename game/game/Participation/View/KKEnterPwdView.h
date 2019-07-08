//
//  KKEnterPwdView.h
//  game
//
//  Created by greatkk on 2018/10/29.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKEnterPwdView : UIView
+(instancetype)shareView;
@property (strong,nonatomic) void(^cancelBlock)(void);
@property (strong,nonatomic) void(^ensureBlock)(NSString *pwd);
@end

NS_ASSUME_NONNULL_END
