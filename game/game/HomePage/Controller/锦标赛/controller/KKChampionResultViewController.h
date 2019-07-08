//
//  KKChampionResultViewController.h
//  game
//
//  Created by linsheng on 2019/1/11.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKBaseViewController.h"
#import "KKChampionshipsMatchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKChampionResultViewController : KKBaseViewController

- (id)initWithCid:(NSNumber *)cid gameId:(NSNumber *)gameId type:(KKChampionshipsType )type;
@end

NS_ASSUME_NONNULL_END
