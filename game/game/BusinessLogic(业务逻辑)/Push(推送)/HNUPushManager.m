//
//  HNUPushManager.m
//  EyeStock
//
//  Created by Peak on 2017/9/6.
//  Copyright © 2017年 NiuBang. All rights reserved.
//

#import "HNUPushManager.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "KKBindingGamerModel.h"
//#import "HNUTimeIntervalOperation.h"
//HNUUserManagerDelegate
#define MAXCOUNT 1000
@interface HNUPushManager ()<JPUSHRegisterDelegate>


@property (nonatomic, assign) BOOL didEnterBackground;

@end

@implementation HNUPushManager

+(instancetype)sharePushManager
{
    static HNUPushManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HNUPushManager alloc]init];
    });
    return manager;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(instancetype)init
{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:KKLoginNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:KKLogoutNotification object:nil];
//         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRegistrationID:) name:kJPFNetworkDidLoginNotification object:nil];
        
    }
    return self;
}

-(void)addDelegate:(id<HNUPushManagerDelegate>)delegate
{
    [super addDelegate:delegate];
}

-(void)removeDelegate:(id<HNUPushManagerDelegate>)delegate
{
    [super removeDelegate:delegate];
}

#pragma mark notification

-(void)appDidBecomeActive:(NSNotification *)noti
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [JPUSHService resetBadge];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.didEnterBackground = NO;
    });
}

-(void)appWillResignActive:(NSNotification *)noti
{

}

-(void)appDidEnterBackground:(NSNotification *)noti
{
    _didEnterBackground = YES;
    [JPUSHService resetBadge];
}
//- (void)getRegistrationID:(NSNotification *)notification
//{
//    NSLog(@"asd%@",[JPUSHService registrationID]);
////    [JPUSHService registrationID];
//}
- (void)login:(NSNotification *)notification
{
    [self jPushClearAlias:^(bool success,NSError *error){
//        if (success) {
//            self
//        }
        [self performSelector:@selector(jPushSetAlias) withObject:nil afterDelay:5];
    }];
    [self jPushSetTags];
}
- (void)logout:(NSNotification *)notification
{
    
}
#pragma mark 设置推送

-(void)startJPushWithLaunchOptions:(NSDictionary *)launchOptions
{
    //添加初始化APNs代码
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:[HNUPushManager sharePushManager]];
    //添加初始化JPush代码
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchOptions appKey:kJPushKey
                          channel:@"appstore"
                 apsForProduction:kJPpushApsForProduction
            advertisingIdentifier:advertisingId];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            self.registrationID=registrationID;
//            [self login:nil];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

-(void)registerDeviceToken:(NSData *)deviceToken
{
     [JPUSHService registerDeviceToken:deviceToken];
}
/** 注册用户通知 */
- (void)registerUserNotification{
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
        [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        // 判读系统版本是否是“iOS 8.0”以上
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}
#pragma mark tags/alies
//设置tags
- (void)jPushSetTags
{
    if ([KKDataTool token]) {
        [KKNetTool getBindAccountListSuccessBlock:^(NSDictionary *dic)
         {
             KKAutoArrayModel *model=[[KKAutoArrayModel alloc] initWithKey:@"d" bid:[KKBindingGamerModel class]];
             [model injectJSONData:dic];
             NSMutableArray *array=[@[] mutableCopy];
             for (KKBindingGamerModel *tmpData in model.arrayOutput) {
                 [array addObject:[tmpData getJPushInfo]];
                 
             }
             [self jPushSetTagsWithData:array];
         }erreorBlock:^(NSError *error)
         {
            
         }];
    }
    else
    {
        [self jPushSetTagsWithData:nil];
    }
}
- (void)jPushSetTagsWithData:(NSArray *)tags
{
    NSSet *set=nil;
    if (tags) {
        set=[NSSet setWithArray:tags];
    }
    [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq){
        NSLog(@"JPUSHServiceSetTagResCode:%ld",(long)iResCode);
    } seq:1234];
}
- (void)jPushClearAlias:(void (^)(bool success,NSError *error))block
{

    [KKNetTool postClearAliasSuccessBlock:^(NSDictionary *dic){
        block(true,nil);
    }erreorBlock:^(NSError *error) {
        //重复3次
        NSLog(@"清理别名失败 需要重复调用");
        block(false,error);
    }];
  
    
}
- (void)jPushSetAlias
{
    NSString *str=[NSString stringWithFormat:@"u%@",[KKDataTool user].userId];
    [JPUSHService setAlias:str completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq){
        NSLog(@"JPUSHServiceSetAliseResCode:%ld",(long)iResCode);
        
    } seq:1111];
}
////当前系统设置
////设置别名,服务器根据别名进行推送消息
//-(void)setJPushAlias:(NSString*)alias{
//
////    hnuSetWeakSelf;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self jpushAlias:alias];
//    });
//}
//-(void)jpushAlias:(NSString*)alias{
//    hnuSetWeakSelf;
//    [JPUSHService setTags:nil completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq)
//     {
//
//     } seq:1234];
//}


#pragma mark 推送通知的处理
/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动--》启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
    if (!launchOptions)
    return;
    /*
     通过“远程推送”启动APP
     UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
     */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"\n>>>[Launching RemoteNotification]:%@", userInfo);
    }
}
-(BOOL)dealWithRemoteNotificationWithUserInfo:(NSDictionary *)userInfo
{
    
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    if (appState == UIApplicationStateActive) {
        return NO;
    }
    NSLog(@"bzbzbz%@//dealWithRemoteNotificationWithUserInfo//",userInfo);
    return [self dealWithDictionary:userInfo[@"ext_message"]  type:HNUPushNotificationBackground];
}

-(void)receiveMessageWithUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"bzbzbz%@//receiveMessageWithUserInfo//",userInfo);
    [self dealWithDictionary:userInfo[@"ext_message"] type:HNUPushNotificationForeground];
    
}
//透传
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    //接收到信息就进行逻辑
    NSDictionary * userInfo = [notification userInfo];
    NSLog(@"bzbzbz%@//networkDidReceiveMessage//",userInfo);
    [self dealWithDictionary:userInfo[@"content"] type:HNUPushNotificationJPFNetwork];
    
    
}
//处理收到的消息
//{"matchid":xxxx}
//{"championid":xxx}
- (BOOL)dealWithDictionary:(NSDictionary *)dictioanry type:(HNUPushType )type
{
    BOOL isDeal = NO;
    if ([HNUBZUtil checkStrEnable:dictioanry]) {
        dictioanry = [NSJSONSerialization JSONObjectWithData:[(NSString *)dictioanry dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }
    else if(![HNUBZUtil checkDictEnable:dictioanry])
    {
        return isDeal;
    }
    NSLog(@"bzbzbz%@//dealWithDictionary// type:%d",dictioanry,type);
    HNUPushModel *model=[[HNUPushModel alloc] initWithJSONDict:dictioanry];
    isDeal=true;
    switch (type) {
        case HNUPushNotificationBackground:
            {
                if (model.matchType==KKMatchTypeBattle) {
                    [KKHouseTool enterRoomWithRoomid:model.matchid popToRootVC:NO];
                }
                if (model.matchType==KKMatchTypeChampionships) {
                    [KKHouseTool enterChampionWihtCid:model.championid];
                }
                //后台进入 需要跳转到固定页面
            }
            break;
            
        default:
        {
//            if ([KKDataTool shareTools].window) {
//                <#statements#>
//            }
            [[NSNotificationCenter defaultCenter] postNotificationName:KKViewNeedReloadNotification object:nil];
        }
            break;
    }
    __weak typeof(self) weakSelf = self;
    [self operateDelegate:^(id delegate) {
        if ([delegate respondsToSelector:@selector(pushManager:didReceivePushModel:type:)]) {
            [delegate pushManager:weakSelf didReceivePushModel:model type:type];
        }
    }];
    return isDeal;
}
#pragma mark JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler API_AVAILABLE(ios(10.0)){
    // 前台收到信息逻辑 主要是站内通知
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSDictionary *userInfo = notification.request.content.userInfo;
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
        [self receiveMessageWithUserInfo:userInfo];
    }
    else {
        // 判断为本地通知
    }
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler  API_AVAILABLE(ios(10.0)){
    // 后台点击逻辑
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    completionHandler();  // 系统要求执行这个方法
    [self dealWithRemoteNotificationWithUserInfo:userInfo];
}


@end
