//
//  KKHintView.h
//  game
//
//  Created by GKK on 2018/8/24.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKHintView : UIView
@property (nonatomic,strong) void(^ensureBlock)(void);
@property (nonatomic,strong) void(^cancelBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *btmBtn;
+(instancetype)shareHintView;
-(void)assignWithGameId:(NSInteger)gameId;
@end
