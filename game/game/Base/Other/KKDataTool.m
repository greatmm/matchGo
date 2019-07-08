//
//  KKDataTool.m
//  game
//
//  Created by GKK on 2018/8/22.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKDataTool.h"
#import "GameItem.h"
#define userPath [cachePath stringByAppendingPathComponent:@"user"]//缓存的用户
#define userPathNew [documentPath stringByAppendingPathComponent:@"user"]//缓存的用户
#define gamesPath [cachePath stringByAppendingPathComponent:@"games.plist"]//缓存的游戏数据

static  KKDataTool*_instance;
static  UIWindow * loginWindow;
@implementation KKDataTool

+(instancetype)shareTools
{
    return [[self alloc]init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
-(nonnull id)copyWithZone:(nullable NSZone *)zone
{
    return _instance;
}
-(nonnull id)mutableCopyWithZone:(nullable NSZone *)zone
{
    return _instance;
}
+(void)showLoginVc
{
    if (loginWindow && loginWindow.rootViewController) {
        return;
    }
    if (loginWindow == nil) {
        loginWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        loginWindow.windowLevel = UIWindowLevelAlert + 100;
        loginWindow.mj_y = ScreenHeight;
        loginWindow.backgroundColor = kThemeColor;
    }
    UINavigationController * nc = [[UIStoryboard storyboardWithName:@"KKLogin" bundle:nil] instantiateInitialViewController];
    loginWindow.rootViewController = nc;
    [loginWindow makeKeyAndVisible];
    [UIView animateWithDuration:0.25 animations:^{
        loginWindow.mj_y = 0;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication].delegate.window becomeKeyWindow];
    }];
}
+(void)destroyLoginVc
{
    if (loginWindow) {
        [UIView animateWithDuration:0.25 animations:^{
            loginWindow.mj_y = ScreenHeight;
        } completion:^(BOOL finished) {
            loginWindow.rootViewController = nil;
            [loginWindow resignKeyWindow];
            loginWindow.hidden = YES;
            loginWindow = nil;
        }];
    }
}
-(UIViewController *)wVc
{
    if (_window) {
        UINavigationController * nav = (UINavigationController *)_window.rootViewController;
        return nav.childViewControllers.firstObject;
    }
    return nil;
}
-(UIViewController *)showWVc
{
    if (_showWindow) {
        UINavigationController * nav = (UINavigationController *)_showWindow.rootViewController;
        return nav.childViewControllers.firstObject;
    }
    return nil;
}
-(UIViewController *)windowRootVc
{
    if (self.isWindowShow) {
        return self.window.rootViewController;
    }
    return nil;
}
-(UIViewController *)showWindowRootVc
{
    if (self.isShowWindowShow) {
        return self.showWindow.rootViewController;
    }
    return nil;
}
-(void)destroyAllRoom
{
    [self destroyWindow];
    [self destroyShowWindow];
}
-(void)destroyWindow
{
    if (self.isWindowShow) {
        self.window.rootViewController = nil;
        [self.window resignKeyWindow];
        self.window.hidden = YES;
        self.window = nil;
    }
}
-(void)destroyShowWindow
{
    if (self.isShowWindowShow) {
        self.showWindow.rootViewController = nil;
        [self.showWindow resignKeyWindow];
        self.showWindow.hidden = YES;
        self.showWindow = nil;
    }
}
-(void)destroyAlertWindow
{
    if (_alertWindow) {
        [_alertWindow resignKeyWindow];
        _alertWindow.hidden = YES;
        _alertWindow = nil;
    }
}
-(void)setShowWindowHeight:(BOOL)showWindowHeight
{
    _showWindowHeight = showWindowHeight;
    if (self.isShowWindowShow && self.isWindowShow) {
        if (_showWindowHeight) {
            self.showWindow.windowLevel = UIWindowLevelNormal + 100;
            self.window.windowLevel = UIWindowLevelNormal;
        } else {
            self.window.windowLevel = UIWindowLevelNormal + 100;
            self.showWindow.windowLevel = UIWindowLevelNormal;
        }
    }
}

-(BOOL)isWindowShow
{
    return _window != nil;
}
-(BOOL)isShowWindowShow
{
    return _showWindow != nil;
}
-(KKMoveWindow *)window
{
    if (_window == nil) {
        _window = [[KKMoveWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.windowLevel = UIWindowLevelNormal;
        _window.mj_x = ScreenWidth;
        _window.backgroundColor = [UIColor clearColor];
    }
    return _window;
}
-(KKMoveWindow *)showWindow
{
    if (_showWindow == nil) {
        _showWindow = [[KKMoveWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _showWindow.windowLevel = UIWindowLevelNormal;
        _showWindow.backgroundColor = [UIColor clearColor];
        _showWindow.mj_x = ScreenWidth;
    }
    return _showWindow;
}
-(UIWindow *)alertWindow
{
    if (_alertWindow == nil) {
        _alertWindow = [UIWindow new];
        _alertWindow.frame = [UIScreen mainScreen].bounds;
        _alertWindow.windowLevel = UIWindowLevelAlert;
    }
    _alertWindow.hidden = NO;
    return _alertWindow;
}

+(void)saveGamesWithArr:(NSArray *)gameArr{
    [gameArr writeToFile:gamesPath atomically:YES];
}
+(NSMutableArray *)games
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:gamesPath]) {
        return nil;
    }
    NSArray * arr = [NSArray arrayWithContentsOfFile:gamesPath];
    if (arr == nil) {
        return nil;
    }
    NSMutableArray * games = [NSMutableArray new];
    for (NSDictionary * dict in arr) {
        GameItem * item = [GameItem mj_objectWithKeyValues:dict];
        [games addObject:item];
    }
    return games;
}
+(NSInteger)nowTimeStamp
{
    NSDate * now = [NSDate date];
    NSTimeInterval timeIn = [now timeIntervalSince1970];
    NSString * time = [NSString stringWithFormat:@"%.0f",timeIn];
    return time.integerValue;
}
+(NSDate *)dateWithTimeStamp:(NSTimeInterval)timeStamp
{
    NSDate * d = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    return d;
}
+(NSInteger)timeStampFromDate:(NSDate *)date
{
    NSTimeInterval timeIn = [date timeIntervalSince1970];
    NSString * time = [NSString stringWithFormat:@"%.0f",timeIn];
    return time.integerValue;
}
+(NSString *)timeStrWithTimeStamp:(NSInteger)timeStamp withTimeFormate:(NSString *)formate
{
    NSDate * d = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateFormat:formate];
    NSString* string = [formatter stringFromDate:d];
    return string;
}
+(NSString *)timeStrWithTimeStamp:(NSInteger)timeStamp
{
   return [[self class] timeStrWithTimeStamp:timeStamp withTimeFormate:@"MM/dd HH:mm"];
}
+(CGFloat)navBarH
{
    if (isIphoneX) {
        return 88;
    }
    return 64;
}
+(CGFloat)tabBarH
{
    if (isIphoneX) {
        return 83;
    }
    return 49;
}
+(CGFloat)statusBarH
{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}
+(CGFloat)safeContentH
{
    CGFloat h = 0;
    if (isIphoneX) {
        h = 88 + 34;
    } else {
        h = 64;
    }
    return ScreenHeight - h;
}
+(void)refreshUserInfoWithSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock
{
    [KKNetTool getAccountSuccessBlock:^(NSDictionary *dic) {
        //获取到了数据，更新用户
        //        NSLog(@"获取到的用户数据%@",dic);
        KKUser * user = [KKUser mj_objectWithKeyValues:dic];
        [KKDataTool saveUser:user];
        if (successBlock) {
            successBlock(dic);
        }
    } erreorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}
+(KKUser *)user
{
    if (@available(iOS 11.0, *)) {
       NSError * error;
       KKUser * user = [NSKeyedUnarchiver unarchivedObjectOfClass:[KKUser class] fromData:[NSData dataWithContentsOfFile:userPathNew] error:&error];
        return user;
    } else {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:userPathNew];
    }
}
+(void)saveUser:(KKUser *)user
{
    if (user == nil) {
        return;
    }
    NSError * error;
    if (@available(iOS 11.0, *)) {
       NSData * data = [NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:YES error:&error];
        if (error) {
            return;
        }
       [data writeToFile:userPathNew atomically:YES];
    } else {
        [NSKeyedArchiver archiveRootObject:user toFile:userPathNew];
    }
}
+(void)removeUser
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:userPathNew]) {
       [fileManager removeItemAtPath:userPathNew error:nil];
    }
}
+(void)moveUserToNewPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:userPath]) {
        [fileManager moveItemAtPath:userPath toPath:userPathNew error:nil];
    }
}
+(NSString *)paymentOrderId
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:@"paymentOrder"];
}
+(void)saveOrderId:(NSString *)orderId
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:orderId forKey:@"orderId"];
    [defaults synchronize];
}
+(NSString *)orderId
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:@"orderId"];
}
+(NSString *)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
+(void)saveToken:(NSString *)token
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:token forKey:@"token"];
    [defaults synchronize];
}
+(NSString *)token
{
//#ifdef kkDEBUGEnvironment
//    return @"139254a18e1dbcdd099b41bee73dc9d46977b0e8bee7be68c090abef634ba972";
//    #else
//    #endif
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *token=[defaults valueForKey:@"token"];
    return token;
}
+(GameItem *)itemWithGameId:(NSInteger)gameId
{
    NSArray * games = [KKDataTool games];
    for (GameItem * item in games) {
        if (item.gameId.integerValue == gameId) {
            return item;
        }
    }
    return nil;
}
+(NSInteger)gameId
{
    if ([KKDataTool shareTools].gameItem) {
        return [KKDataTool shareTools].gameItem.gameId.integerValue;
    }
    return 0;
}
+(NSString *)timeStrWithSeconds:(NSInteger)seconds
{
    NSInteger t = seconds%(60 * 60 * 24);//几天，过滤掉
    NSInteger h = t/(60 * 60);//几小时
    t = t%(60 * 60);
    NSInteger m = t/60;//几分钟
    NSInteger s = t%60;//秒数
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)h,(long)m,(long)s];
}
+(NSString *)decimalNumber:(NSNumber *)number fractionDigits:(NSInteger)count
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumFractionDigits = count;
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:number];
}
+(void)copyStr:(NSString *)str
{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = str;
}
- (NSInteger)getDateStamp
{
//    if (_timeDeviation) {
        NSInteger nowTime=[KKDataTool nowTimeStamp];
        
    return nowTime-_timeDeviation;
//    }
}
+(UIImage *)gameIconWithGameId:(NSInteger)gameId
{
    if (gameId < 1 || gameId > 4) {
        return nil;
    }
    NSArray * gameIconImgs = @[@"PUBGIcon",@"GKIcon",@"ZCIcon",@"LOLIcon"];
    return [UIImage imageNamed:gameIconImgs[gameId - 1]];
}
- (void)resetPath
{
    if (_window) {
        [_window resetPath];
    }
    if (_showWindow) {
        [_showWindow resetPath];
    }
}
@end
