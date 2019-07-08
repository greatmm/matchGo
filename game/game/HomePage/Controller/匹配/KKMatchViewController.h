//
//  KKMatchViewController.h
//  game
//
//  Created by greatkk on 2018/11/22.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKMatchViewController : KKBaseViewController
@property (nonatomic,strong) void(^ensureBlock)(NSNumber * roomId);
@property (nonatomic,strong) void(^cancelBlock)(void);
@property (strong,nonatomic) void(^closeBlock)(void);

@end

NS_ASSUME_NONNULL_END
