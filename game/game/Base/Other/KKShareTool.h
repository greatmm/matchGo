//
//  KKShareTool.h
//  game
//
//  Created by greatkk on 2019/1/7.
//  Copyright © 2019 MM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
NS_ASSUME_NONNULL_BEGIN

@interface KKShareTool : NSObject
+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType viewController:(UIViewController *)viewController;
+ (void)shareWebPageWithPlatformType:(UMSocialPlatformType)platformType viewController:(UIViewController *)viewController title:(NSString *)title des:(NSString *)des webpageUrl:(NSString *)webpageUrl;
+ (void)shareInvitecodeWithViewController:(UIViewController *)viewController;
+ (void)shareRoomcode:(NSString *)roomCode viewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
