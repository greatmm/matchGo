//
//  KKSmallShopCollectionViewCell.h
//  game
//
//  Created by GKK on 2018/9/7.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKSmallShopCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) NSArray * dataArr;
@property (weak, nonatomic) IBOutlet UICollectionView *cv;

@end
