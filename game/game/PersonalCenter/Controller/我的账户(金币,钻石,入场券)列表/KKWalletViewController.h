//
//  KKWalletViewController.h
//  game
//
//  Created by GKK on 2018/10/23.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseViewController.h"
#import "KKAccountBalanceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKWalletViewController : KKBaseViewController
@property (nonatomic,assign) NSInteger type;
//@property (strong,nonatomic) NSDictionary * moneyDic;
@property (strong,nonatomic) KKAccountBalanceModel * model;
@end

NS_ASSUME_NONNULL_END
