//
//  KKChampionResultHeadView.h
//  game
//
//  Created by linsheng on 2018/12/18.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "HNUBZChoiceView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChampionResultHeadView : HNUBZChoiceView
@property (nonatomic, strong) UIView *moreView;
@property (nonatomic, strong) UIImageView *imageVMain;
@property (nonatomic, strong) UIButton *explainBtn;
- (id)initWithDelegate:(id<HNUBZChoiceViewDelegate>)delegate;
- (void)uploadInfo;
@end

NS_ASSUME_NONNULL_END
