//
//  KKHomeGameCollectionViewCell.h
//  game
//
//  Created by GKK on 2018/8/14.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKHomeGameCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *cv;
@property (nonatomic,strong) NSArray * dataArr;
@end
