//
//  KKShareView.h
//  game
//
//  Created by GKK on 2018/8/29.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKShareView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (strong,nonatomic) void(^closeBlock)(void);
@property (strong,nonatomic) void(^shareBlock)(NSInteger shareType);
+(instancetype)shareView;
@end
