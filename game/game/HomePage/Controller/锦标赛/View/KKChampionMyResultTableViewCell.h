//
//  KKChampionMyResultTableViewCell.h
//  game
//
//  Created by greatkk on 2018/11/6.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseTableViewCell.h"
#import "KKChampionshipsMatchModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKChampionMyResultTableViewCell : KKBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *gameIcon;//游戏图标
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;//胜利
@property (strong,nonatomic) UILabel * leftLabel;//右侧显示KDA最高
//@property (strong,nonatomic) UIControl * leftControl;//查看
@property (assign,nonatomic) KKChampionshipsType type;
@property (assign,nonatomic) NSInteger gameId;
@property (nonatomic, strong) NSString *choice;
@property (strong,nonatomic) void(^clickRightBlock)(void);
-(void)assignWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
