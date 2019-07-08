//
//  KKChampionshipHintView.h
//  game
//
//  Created by greatkk on 2018/11/1.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKChampionshipHintView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (strong,nonatomic) void(^ensureBlock)(void);
@property (strong,nonatomic) void(^cancelBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
+(instancetype)shareChampionshipHintView;
//代码写死title
+ (void)shareWithTitle:(NSString *)title
           buttonTitle:(NSString *)btitle
                  tips:(NSString *)tips
                  view:(UIView *)view
                 block:( void (^)(void))ensureBlock;

@end

NS_ASSUME_NONNULL_END
