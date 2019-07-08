
//
//  KKDataTool.h
//  game
//
//  Created by GKK on 2018/8/22.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKUser.h"
#import "GameItem.h"
#import "KKMoveWindow.h"
@interface KKDataTool : NSObject<NSCopying,NSMutableCopying>
@property (nonatomic,strong) GameItem * gameItem;//当前选中的哪个游戏
@property (nonatomic,strong) KKMoveWindow * window;//底部小房间
@property (nonatomic,strong) KKMoveWindow * showWindow;//可以浏览的房间
@property (nonatomic,assign) BOOL isWindowShow;//小房间是否在
@property (nonatomic,assign) BOOL isShowWindowShow;//浏览的房间是否在
@property (nonatomic,assign) BOOL showWindowHeight;//showwindow显示在前
@property (strong,nonatomic) UIWindow * alertWindow;
//时间修正差值
@property (nonatomic, assign) NSInteger timeDeviation;
//-(UIViewController *)currentRoom;//当前的小房间
-(UIViewController *)windowRootVc;//window的跟控制器
-(UIViewController *)wVc;//window根控制器的rootviewcontroller
-(UIViewController *)showWVc;//showWindow的rootViewcontroller
-(UIViewController *)showWindowRootVc;//showWindow的跟控制器
-(void)destroyAllRoom;//销毁当前房间，并释放window
-(void)destroyWindow;//销毁显示的房间
-(void)destroyShowWindow;//销毁显示的房间
-(void)destroyAlertWindow;//销毁alertWindow
+(void)refreshUserInfoWithSuccessBlock:(void (^)(NSDictionary *dic))successBlock erreorBlock:(void(^)(NSError *error))errorBlock;
+(void)saveGamesWithArr:(NSArray *)gameArr;//保存首页游戏数据
+(NSMutableArray *)games;//返回游戏数据
+(GameItem *)itemWithGameId:(NSInteger)gameId;//通过gameId获取到gameItem
+(UIImage *)gameIconWithGameId:(NSInteger)gameId;//根据游戏id返回游戏图标
+(instancetype)shareTools;
+(void)showLoginVc;//弹出登录视图
+(void)destroyLoginVc;//销毁登录视图
+(NSInteger)nowTimeStamp;//当前时间戳
+(NSInteger)timeStampFromDate:(NSDate *)date;//将日期转换成时间戳
+(NSString *)timeStrWithTimeStamp:(NSInteger)timeStamp withTimeFormate:(NSString *)formate;//根据固定格式获取
+(NSString *)timeStrWithTimeStamp:(NSInteger)timeStamp;//将时间戳转换成时间字符串
+(KKUser *)user;
+(void)saveUser:(KKUser *)user;
+(void)removeUser;//清除缓存的用户数据
+(void)moveUserToNewPath;//把用户缓存从cache移动到document
+(NSString *)appVersion;//app当前版本
+(void)saveToken:(NSString *)token;
+(NSString *)token;
+(NSInteger)gameId;
+(CGFloat)navBarH;
+(CGFloat)tabBarH;
+(CGFloat)statusBarH;
+(CGFloat)safeContentH;
+(NSString *)timeStrWithSeconds:(NSInteger)seconds;//把秒数转换成时分秒
+(void)saveOrderId:(NSString *)orderId;//存储购买的订单
+(NSString *)orderId;//返回订单字典
//把nsnumber转成1，234.00 count表示小数点后几位
+(NSString *)decimalNumber:(NSNumber *)number fractionDigits:(NSInteger)count;
+(void)copyStr:(NSString *)str;//复制字符串至剪切板
//修正过的时间戳
- (NSInteger)getDateStamp;
//window位置还原
- (void)resetPath;
@end
