//
//  KKOrderTableViewCell.h
//  game
//
//  Created by GKK on 2018/8/29.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKBaseTableViewCell.h"

@interface KKOrderTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
+(instancetype)shareCell;
-(void)assignWithType:(NSInteger)type;
@end
