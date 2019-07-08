//
//  KKWalletListViewController.h
//  game
//
//  Created by GKK on 2018/10/23.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKWalletListViewController : KKBaseViewController
@property (nonatomic,assign) NSInteger type;// 0钻石 1金币 2入场券 3提现记录 4收入记录
@property (strong,nonatomic) NSString * numberStr;//数量
@end

NS_ASSUME_NONNULL_END
