//
//  KKBottomShareView.h
//  game
//
//  Created by greatkk on 2018/11/7.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKRemoveView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKBottomShareView : KKRemoveView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
+(instancetype)shareBottomShareView;
@end

NS_ASSUME_NONNULL_END
