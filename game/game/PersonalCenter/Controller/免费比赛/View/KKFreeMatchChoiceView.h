//
//  KKFreeMatchChoiceView.h
//  game
//
//  Created by greatkk on 2019/1/15.
//  Copyright © 2019 MM. All rights reserved.
//

#import "HNUBZChoiceView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKFreeMatchChoiceView : HNUBZChoiceView
@property (nonatomic, strong) UIView *moreView;
@property (nonatomic, strong) UIView * topView;//顶部试图
@property (strong,nonatomic) UILabel * inviteCountLabel;//成功邀请几人
@property (strong,nonatomic) UILabel * ticketLabel;//累计获取的入场券
- (id)initWithDelegate:(id<HNUBZChoiceViewDelegate>)delegate;
- (void)uploadInfo;
@end

NS_ASSUME_NONNULL_END
