//
//  KKBigHouseListTableViewCell.h
//  game
//
//  Created by greatkk on 2018/11/23.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseTableViewCell.h"
#import "KKRoomUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKBigHouseListTableViewCell : KKBaseTableViewCell
@property (assign,nonatomic) NSInteger rank;
-(void)assignWithUser:(KKRoomUser *)user gameid:(KKGameType)gameid;
-(void)assignWithDic:(NSDictionary *)dic;
- (void)updateStatusGifImage:(KKRoomUser *)user step:(NSInteger)step;
//-(void)assignLookResult;
@end

NS_ASSUME_NONNULL_END
