//
//  KKEnsureGameAccountView.h
//  game
//
//  Created by GKK on 2018/8/23.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
//可删除了
@interface KKEnsureGameAccountView : UIView

@property (weak, nonatomic) IBOutlet UIImageView * avatarView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonatomic,strong) void(^ensureBlock)(void);
@property (nonatomic,strong) void(^cancelBlock)(void);
+(instancetype)shareAccountView;
@end
