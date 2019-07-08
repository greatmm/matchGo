//
//  KKNotiMessageTableViewCell.h
//  game
//
//  Created by GKK on 2018/10/25.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseTableViewCell.h"
#import "NotiMessageItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKNotiMessageTableViewCell : KKBaseTableViewCell
-(void)assignWithItem:(NotiMessageItem *)item;
@end

NS_ASSUME_NONNULL_END
