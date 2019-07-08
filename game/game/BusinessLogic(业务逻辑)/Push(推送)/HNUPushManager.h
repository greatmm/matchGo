//
//  HNUPushManager.h
//  EyeStock
//
//  Created by Peak on 2017/9/6.
//  Copyright © 2017年 NiuBang. All rights reserved.
//

#import "HNUBaseMultiDelegateManager.h"
#import "HNUPushModel.h"

typedef NS_ENUM(NSUInteger, HNUPushType) {
    HNUPushNotificationBackground = 0,//后台推送
    HNUPushNotificationForeground,//前台推送
    HNUPushNotificationJPFNetwork//透传
};

@class HNUPushManager;
@class HNURedPointModel;
/**
 Push的监听
 */
@class HNUPushManager;
@protocol HNUPushManagerDelegate <NSObject>
@optional
/**
 收到push通知的推送
 */
-(void)pushManager:(HNUPushManager *)manager didReceivePushModel:(HNUPushModel *)pushModel type:(HNUPushType)type;
///**
// 红点刷新的回调
// */
//-(void)pushManager:(HNUPushManager*)manager didRefreshRedPointModel:(HNURedPointModel*)redPointModel;

@end
@interface HNUPushManager : HNUBaseMultiDelegateManager
//极光推送 用来和设备绑定
@property (nonatomic, strong) NSString *registrationID;
+(instancetype)sharePushManager;
-(void)registerDeviceToken:(NSData *)deviceToken;
-(void)startJPushWithLaunchOptions:(NSDictionary *)launchOptions;
/**
 处理推送通知点击事件
 @param userInfo 推送信息的userInfo
 @return 内部是否处理该通知
 */
- (BOOL)dealWithRemoteNotificationWithUserInfo:(NSDictionary*)userInfo;
/**
 处理站内通知
 @param userInfo 推送信息的userInfo
 */
-(void)receiveMessageWithUserInfo:(NSDictionary *)userInfo;
/** 注册用户通知 */
- (void)registerUserNotification;
/**
 处理远程通知启动 APP
 */
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions;
/**
 *  绑定/清除别名功能:后台可以根据别名进行推送
 *
 *  @param alias 别名字符串
 */
//-(void)setJPushAlias:(NSString*)alias;
//设置tags
- (void)jPushSetTags;
//设置registrationID
@end
