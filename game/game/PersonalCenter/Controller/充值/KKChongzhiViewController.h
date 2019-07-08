//
//  KKChongzhiViewController.h
//  game
//
//  Created by GKK on 2018/8/24.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKBaseViewController.h"

@interface KKChongzhiViewController : KKBaseViewController
@property (assign,nonatomic) BOOL isChongzhi;//是充值还是兑换
@property (strong,nonatomic) void(^chongzhiBlock)(void);//充值或者兑换成功之后的回调
@property (assign,nonatomic) NSInteger lackGold;//缺少的金币数量
@end
