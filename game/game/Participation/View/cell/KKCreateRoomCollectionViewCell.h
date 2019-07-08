//
//  KKCreateRoomCollectionViewCell.h
//  game
//
//  Created by GKK on 2018/10/17.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKCreateRoomCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)void(^createRoomBlock)(void);
@property (nonatomic,strong) void(^joinRoomBlock)(void);
@end

NS_ASSUME_NONNULL_END
