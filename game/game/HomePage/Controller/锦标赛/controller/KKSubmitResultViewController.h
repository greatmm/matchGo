//
//  KKSubmitResultViewController.h
//  game
//
//  Created by greatkk on 2018/11/2.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKSubmitResultViewController : UIViewController
@property (strong,nonatomic) NSNumber * matchId;
@property (assign,nonatomic) NSInteger gameId;
@property (assign,nonatomic) BOOL isChampion;//是否是锦标赛
@property (strong,nonatomic) void(^submitSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
