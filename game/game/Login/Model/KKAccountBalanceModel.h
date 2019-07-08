//
//  KKAccountBalanceModel.h
//  game
//
//  Created by greatkk on 2019/1/14.
//  Copyright © 2019 MM. All rights reserved.
//

#import "MTKFetchModel.h"
//账户余额model，钻石，金币，入场券数量
NS_ASSUME_NONNULL_BEGIN

@interface KKAccountBalanceModel : MTKFetchModel
@property (strong,nonatomic) NSNumber * diamond;
@property (strong,nonatomic) NSNumber * gold;
@property (strong,nonatomic) NSNumber * lockgold;
@property (strong,nonatomic) NSNumber * ticket;
@end

NS_ASSUME_NONNULL_END
