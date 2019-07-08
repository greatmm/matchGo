//
//  KKPAgainstViewController.h
//  game
//
//  Created by GKK on 2018/10/17.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKPAgainstViewController : UIViewController
@property (nonatomic,assign) NSInteger gameId;//游戏id
- (void)createRoom;//创建房间
@end

NS_ASSUME_NONNULL_END
