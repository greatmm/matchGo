//
//  KKChampionLadderPriceView.h
//  game
//
//  Created by linsheng on 2019/1/15.
//  Copyright © 2019年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, KKChampionLadderPriceType) {
    KKChampionLadderPriceTypeUsed=1,        // 已使用
    KKChampionLadderPriceTypeUnlock=2,      // 已解锁
    KKChampionLadderPriceTypeLocked=3,      // 未解锁
    
};
@interface KKChampionLadderPriceView : UIView
- (void)setTicketModel:(KKChampionshipsMyTicketsModel *)model;
- (void)setWithFirst:(NSInteger)first Rebuy:(NSInteger)rebuy Used:(NSInteger)used Buy:(NSInteger)buy;
@end

NS_ASSUME_NONNULL_END
