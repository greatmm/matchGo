//
//  HNUResultHeadView.h
//  game
//
//  Created by linsheng on 2019/1/15.
//  Copyright © 2019年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKChampionshipsMatchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HNUResultHeadView : UIView
- (void)setType:(KKChampionshipsType)type value:(NSString *)value;
@end

NS_ASSUME_NONNULL_END
