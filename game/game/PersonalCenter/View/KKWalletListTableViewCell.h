//
//  KKWalletListTableViewCell.h
//  game
//
//  Created by GKK on 2018/10/23.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKWalletListTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (assign,nonatomic) NSInteger accountType;
-(void)assignWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
