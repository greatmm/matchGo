//
//  AppDelegate.m
//  game
//
//  Created by GKK on 2018/8/7.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "KKBigHouseViewController.h"
#import <StoreKit/StoreKit.h>
#import <UMCommon/UMCommon.h>
#import <UMCommon/UMConfigure.h>
#import <UMAnalytics/MobClick.h>
#import <UMShare/UMShare.h>
#import "KKUpgradesModel.h"
#import "KKUpgradesView.h"
#import "HNUPushManager.h"
#import "PBAlipayApiManager.h"
#import "KKMatchGoSchemesManager.h"
@interface AppDelegate ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setKeyboard];
    [self setUM];
    [self addNoti];
    self.window.backgroundColor = [UIColor whiteColor];
    [[KKWSTool shareTools] getWSList];
    [self checkVersion];
    
    //推送
    //注册通知
    [[HNUPushManager sharePushManager] registerUserNotification];
    //处理远程通知启动 APP
    [[HNUPushManager sharePushManager] receiveNotificationByLaunchingOptions:launchOptions];
    //推送通知
    [[HNUPushManager sharePushManager] startJPushWithLaunchOptions:launchOptions];
    [HNUBZUtil isNetworking];
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    NSLog(@"%@",url.host);
    
    if ([KKMatchGoSchemesManager dealWithOpenUrl:url]) {
        return true;
    }
    if([[PBAlipayApiManager sharedManager] dealWithOpenUrl:url])
    {
        return true;
    }
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
//添加通知
- (void)addNoti
{
    //苹果支付的通知
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buydDiamond:) name:@"buydDiamond" object:nil];
    //退出登录之后的处理
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:KKLogoutNotification object:nil];
}
- (void)logout
{
    [KKDataTool showLoginVc];
    [KKNetTool logoutSuccessBlock:^(NSDictionary *dic) {
    } erreorBlock:^(NSError *error) {
    }];
    [KKDataTool removeUser];
    [KKDataTool shareTools].gameItem = nil;
    [KKDataTool saveToken:nil];
    [[KKDataTool shareTools] destroyAllRoom];
    UIViewController * vc = [self currentVc];
    [vc.navigationController popToRootViewControllerAnimated:YES];
}
//设置友盟
- (void)setUM
{
    [UMConfigure initWithAppkey:kUMKey channel:@"App Store"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kUMQQAppId  appSecret:nil redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kUMWechatAppId  appSecret:kUMWechatAppSecret redirectURL:nil];
    [UMConfigure setLogEnabled:YES];
//    [MobClick setCrashReportEnabled:YES];
}
//设置键盘
-(void)setKeyboard
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = NO; // 是否显示占位文字
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}
//检查更新
- (void)checkVersion
{
    [KKDataTool moveUserToNewPath];//迁移用户缓存的登录数据
    [KKNetTool getUpdateVersionSuccessBlock:^(NSDictionary *dic) {
        KKUpgradesModel * model = [[KKUpgradesModel alloc] initWithJSONDict:dic];
        if (model.url && model.version) {
            NSString * v = [KKDataTool appVersion];
            if ([v compare:model.version options:NSNumericSearch] == NSOrderedAscending) {
                KKUpgradesView * upgradesView = [KKUpgradesView shareUpgradesView];
                //如果点击立即更新需要清除提示框的话，一定要在block里清除alertView
                upgradesView.closeBtn.hidden = (model.forceupgrade != 0);
                if (model.des) {
                    upgradesView.subtitleLabel.text = model.des;
                }
                upgradesView.upgradesBlock = ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
                };
            }
        }
    } erreorBlock:^(NSError *error) {}];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (UIViewController *)currentVc
{
   return [self getCurrentVCFrom:self.window.rootViewController];
}
- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}
//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [[HNUPushManager sharePushManager] registerDeviceToken:deviceToken];
}
/** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    //点击通知栏进入app ios10之前的处理
    if (kkiOSVersion < 10.0) {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [[HNUPushManager sharePushManager] receiveMessageWithUserInfo:userInfo];
        }else{
            [[HNUPushManager sharePushManager] dealWithRemoteNotificationWithUserInfo:userInfo];
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
    //    [JPUSHService handleRemoteNotification:userInfo];
}
#pragma mark - 内购代理方法
- (void)buydDiamond:(NSNotification *)noti
{
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        //检测是否有未完成的交易
        SKPaymentTransaction* transaction = [transactions firstObject];
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
    }
    NSDictionary * dict = noti.object;
    NSString * order = dict[@"orderId"];
    [KKDataTool saveOrderId:order];
    NSNumber * index = dict[@"index"];
    if ([SKPaymentQueue canMakePayments]) {
        [self RequestProductDataWithIndex:index.integerValue];
    } else {
        [KKAlert showText:@"您的设备不允许程序内付费购买" toView:self.window];
    }
}
-(void)RequestProductDataWithIndex:(NSInteger)index
{
    NSArray * arr = @[@"com.aiyou.cn.60",@"com.aiyou.cn.120",@"com.aiyou.cn.300",@"com.aiyou.cn.500",@"com.aiyou.cn.1280",@"com.aiyou.cn.6180"];
    NSArray *product = [NSArray arrayWithObject:arr[index]];
    NSSet * nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate = self;
    [request start];
    [KKAlert showAnimateWithText:nil toView:self.window];
}
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    [KKAlert showAnimateWithText:nil toView:self.window];
    NSArray *myProduct = response.products;
    for(SKProduct *product in myProduct){
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
        payment.quantity = 1;
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchased:{//交易完成
                [self purchaseOfValidationWith:transaction];
            }
                break;
            case SKPaymentTransactionStateFailed:{//交易失败
                [self failedTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
            {
                [KKAlert dismissWithView:self.window];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表"
//                NSLog(@"商品添加进列表");
                break;
            default:
                [KKAlert dismissWithView:self.window];
                break;
        }
    }
}
//购买错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [KKAlert dismissWithView:self.window];
    [KKAlert showText:[error localizedDescription] toView:self.window];
}
//交易失败的处理
- (void)failedTransaction: (SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        
    }
    [KKAlert dismissWithView:self.window];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
//验签
-(void)purchaseOfValidationWith:(SKPaymentTransaction *)transaction
{
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData * receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString * receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    NSString * orderid = [KKDataTool orderId];
    if (orderid == nil) {
        [KKAlert dismissWithView:self.window];
        return;
    }
    [KKNetTool verifyPaymentOrderWithParm:@{@"orderid":orderid,@"data":receiptString} SuccessBlock:^(NSDictionary *dic) {
         [KKAlert dismissWithView:self.window];
         [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:self.window];
    }];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([KKMatchGoSchemesManager dealWithOpenUrl:url]) {
        return true;
    }
    return [[PBAlipayApiManager sharedManager] dealWithOpenUrl:url];
}
@end
