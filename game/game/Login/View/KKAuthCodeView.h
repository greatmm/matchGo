//
//  KKAuthCodeView.h
//  game
//
//  Created by GKK on 2018/8/15.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKAuthCodeView : UIView
@property (nonatomic,strong) void(^ensureBlock)(NSMutableDictionary * captCode);
+(instancetype)shareCodeView;

@end
