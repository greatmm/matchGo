//
//  KKResultListTableViewCell.h
//  game
//
//  Created by GKK on 2018/9/27.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKResultListTableViewCell : KKBaseTableViewCell
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) BOOL showImage;
@property (nonatomic,assign) BOOL isOpen;
-(void)assignWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
