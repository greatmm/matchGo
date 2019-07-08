//
//  KKGamerInfoCollectionViewCell.h
//  game
//
//  Created by GKK on 2018/10/10.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKGamerInfoCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign) NSInteger type;//显示几个来调整间距
-(void)assignWithDic:(id)item;//给界面赋值，dic为nil表示没人显示默认值
@end

NS_ASSUME_NONNULL_END
