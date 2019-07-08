//
//  KKAddressTableViewCell.h
//  game
//
//  Created by Jack on 2018/8/8.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKBaseTableViewCell.h"
#import "KKAddressItem.h"
@interface KKAddressTableViewCell : KKBaseTableViewCell
@property(nonatomic,strong)void(^editBlock)(void);
-(void)assignWithItem:(KKAddressItem *)item;
@end
