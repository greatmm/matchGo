//
//  KKSmallMallShopCollectionViewCell.h
//  game
//
//  Created by GKK on 2018/9/7.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKSmallMallShopCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UILabel * desLabel;
@property (nonatomic,strong) UILabel * priceLabel;
@property (nonatomic,assign) BOOL showRight;
@end
