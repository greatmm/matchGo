//
//  KKEnterInvcodeView.h
//  game
//
//  Created by greatkk on 2019/1/14.
//  Copyright © 2019 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKEnterInvcodeView : UIView
@property (strong,nonatomic) void(^clickBtmBtnBlock)(NSString * inviteCode);
+(instancetype)shareInvcodeView;
-(void)showKeyboard;
@end

NS_ASSUME_NONNULL_END
