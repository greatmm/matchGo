//
//  KKAlertViewStyleTips.h
//  game
//
//  Created by greatkk on 2019/1/8.
//  Copyright © 2019 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKAlertViewStyleTips : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btmBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;//添加中间的其它内容，如：设备，平台等，添加完成之后，需要更新contentView的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (strong,nonatomic) void(^clickBtmBtnBlock)(void);
@property (strong,nonatomic) void(^clickCancelBtnBlock)(void);
+(instancetype)sharedAlertViewStyleTips;
@end

NS_ASSUME_NONNULL_END
