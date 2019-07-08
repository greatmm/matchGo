//
//  KKBindAccountViewController.h
//  game
//
//  Created by greatkk on 2018/11/27.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseViewController.h"
#import "KKAccountModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKBindAccountViewController : KKBaseViewController

//@property (nonatomic,strong) NSDictionary * accountDic;//如果是修改，会传绑定的信息过来
@property (strong,nonatomic) KKAccountModel * item;////如果是修改，会传原来绑定的信息过来
@property (nonatomic,assign) NSInteger gameId;//哪个游戏
@property (strong,nonatomic) void(^bindBlock)(void);
@end

NS_ASSUME_NONNULL_END
