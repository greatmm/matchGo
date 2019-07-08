//
//  KKSupeiCollectionViewCell.h
//  game
//
//  Created by GKK on 2018/8/13.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface KKSupeiCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
-(void)assignWithDic:(NSDictionary *)dic;
@end
