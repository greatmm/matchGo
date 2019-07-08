//
//  KKHouseTool.m
//  game
//
//  Created by greatkk on 2018/12/28.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKHouseTool.h"
#import "KKChampionshipDetailNewViewController.h"
#import "KKBigHouseViewController.h"
#import "Appdelegate.h"

@implementation KKHouseTool
+(void)enterChampionWihtChamDic:(NSDictionary *)championDic
{
    NSNumber * cId = championDic[@"champion"][@"id"];
    //更新数据
    UIViewController * wv = [[KKDataTool shareTools] wVc];
    if ([wv isKindOfClass:[KKChampionshipDetailNewViewController class]]) {
        KKChampionshipDetailNewViewController * championVC = (KKChampionshipDetailNewViewController *)wv;
        if ([championVC.cId isEqual:cId]) {
            championVC.dataDic = championDic;
            championVC.cId = cId;
            [championVC dealData];
            return;
        }
    }
    UIViewController * swv = [[KKDataTool shareTools] showWVc];
    if ([swv isKindOfClass:[KKChampionshipDetailNewViewController class]]) {
        KKChampionshipDetailNewViewController * championVC = (KKChampionshipDetailNewViewController *)swv;
        if ([championVC.cId isEqual:cId]) {
            championVC.dataDic = championDic;
            championVC.cId = cId;
            [championVC dealData];
            return;
        }
    }
    //显示新的
    KKChampionshipDetailNewViewController * vc = [KKChampionshipDetailNewViewController new];//[[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"championship"];
    vc.dataDic = championDic;
    vc.cId = cId;
    vc.isSmall = YES;
    KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:vc];
    if (wv != nil) {
        vc.secondWindow = YES;
    }
    if (vc.secondWindow) {
        [KKDataTool shareTools].showWindow.rootViewController = nav;
        [KKDataTool shareTools].showWindow.hidden = NO;
        [[KKDataTool shareTools].showWindow makeKeyAndVisible];
        [KKDataTool shareTools].window.hidden = NO;
        [[KKDataTool shareTools] setShowWindowHeight:NO];
    } else {
        [KKDataTool shareTools].window.rootViewController = nav;
        [KKDataTool shareTools].window.hidden = NO;
        [[KKDataTool shareTools].window makeKeyAndVisible];
        [KKDataTool shareTools].showWindow.hidden = NO;
        [[KKDataTool shareTools] setShowWindowHeight:YES];
    }
}
+(void)enterChampionWihtCid:(NSNumber *)cId
{
    UIViewController * wv = [[KKDataTool shareTools] wVc];
    if ([wv isKindOfClass:[KKChampionshipDetailNewViewController class]]) {
        KKChampionshipDetailNewViewController * championVC = (KKChampionshipDetailNewViewController *)wv;
        if ([championVC.cId isEqual:cId]) {
            [championVC openRoom];
            return;
        }
    }
    UIViewController * swv = [[KKDataTool shareTools] showWVc];
    if ([swv isKindOfClass:[KKChampionshipDetailNewViewController class]]) {
        KKChampionshipDetailNewViewController * championVC = (KKChampionshipDetailNewViewController *)swv;
        if ([championVC.cId isEqual:cId]) {
            [championVC openRoom];
            return;
        }
    }
    [KKAlert showAnimateWithText:nil toView:[UIApplication sharedApplication].delegate.window];
    [KKNetTool getChampionInfoWithCid:cId successBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:[UIApplication sharedApplication].delegate.window];
        KKChampionshipDetailNewViewController * vc =[KKChampionshipDetailNewViewController new];// [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"championship"];
        vc.dataDic = dic;
        vc.cId = cId;
        KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:vc];
        if (wv != nil) {
            vc.secondWindow = YES;
        }
        if (vc.secondWindow) {
            [KKDataTool shareTools].showWindow.rootViewController = nav;
            [KKDataTool shareTools].showWindow.hidden = NO;
            [[KKDataTool shareTools].showWindow makeKeyAndVisible];
            [KKDataTool shareTools].window.hidden = NO;
            [[KKDataTool shareTools] setShowWindowHeight:NO];
        } else {
            [KKDataTool shareTools].window.rootViewController = nav;
            [KKDataTool shareTools].window.hidden = NO;
            [[KKDataTool shareTools].window makeKeyAndVisible];
            [KKDataTool shareTools].showWindow.hidden = NO;
            [[KKDataTool shareTools] setShowWindowHeight:YES];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:[UIApplication sharedApplication].delegate.window];
        //                    NSLog(@"失败%@",error);
    }];
}
+(void)enterPwdroomWithPwd:(NSString *)pwd
{
    KKBigHouseViewController * vc = [[self class] currentBigRoomWithPwd:pwd];
    if (vc != nil) {
        [vc openRoom];
        return;
    }
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController * curVc = [app currentVc];
    [KKAlert showAnimateWithText:nil toView:curVc.view];
    [KKNetTool joinRoomWithCode:pwd successBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:curVc.view];
        dispatch_main_async_safe(^{
            //成功之后进入房间
            [[self class] enterBigHouseWithDic:dic popToRootVC:NO];
        })
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:curVc.view];
    }];
}
+(void)enterRoomWithRoomid:(NSNumber *)roomId popToRootVC:(BOOL)popToRootVC
{
    //通知页面，应该是nsnumber但但判断处理是字符串类型（5位）10256--NSTaggedPointerString
    if ([roomId isKindOfClass:[NSNumber class]] || ([NSString stringWithFormat:@"%@",roomId].length == 5)) {
        [KKAlert showAnimateWithText:nil toView:[UIApplication sharedApplication].delegate.window];
        [KKNetTool getMatchInfoWithMatchId:roomId SuccessBlock:^(NSDictionary *dic) {
            //当前存在的房间控制器，如果已存在小房间，则直接打开
            [[self class] enterBigHouseWithDic:dic popToRootVC:popToRootVC];
            [KKAlert dismissWithView:[UIApplication sharedApplication].delegate.window];
        } erreorBlock:^(NSError *error) {
            [KKAlert dismissWithView:[UIApplication sharedApplication].delegate.window];
        }];
    } else {
        //字符串则是未开始，是房间
        [KKAlert showAnimateWithText:nil toView:[UIApplication sharedApplication].delegate.window];
        [KKNetTool getRoomInfoWithRoomId:(NSString *)roomId SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismissWithView:[UIApplication sharedApplication].delegate.window];
            [[self class] enterBigHouseWithDic:dic popToRootVC:popToRootVC];
        } erreorBlock:^(NSError *error) {
            [KKAlert dismissWithView:[UIApplication sharedApplication].delegate.window];
        }];
    }
}
//拿到数据后进入房间
+ (void)enterBigHouseWithDic:(NSDictionary *)dic popToRootVC:(BOOL)popToRootVC
{
    KKBigHouseViewController * vc = [[self class] currentBigHouse];
    NSNumber * roomId = dic[@"match"][@"id"];
    if (roomId == nil) {
        roomId = dic[@"room"][@"id"];
    }
    if (vc && [vc.matchId isEqual:roomId]) {
        if (vc.isOpen) {
            vc.roomDic = dic;
            [vc performSelector:@selector(dealRoomData) withObject:nil afterDelay:0.25];
        } else {
            [vc openRoom];
        }
        return;
    }
    KKBigHouseViewController * infoVC = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"bighouseVC"];
    if (dic[@"share"]) {
        infoVC.isCreate = YES;
    }
    infoVC.matchId = roomId;
    infoVC.roomDic = dic;
    KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:infoVC];
    infoVC.secondWindow = [[self class] showSecondWindow];
    if (infoVC.secondWindow) {
        [KKDataTool shareTools].showWindow.rootViewController = nav;
        [KKDataTool shareTools].showWindow.hidden = NO;
        [[KKDataTool shareTools].showWindow makeKeyAndVisible];
        [KKDataTool shareTools].window.hidden = NO;
        [[KKDataTool shareTools] setShowWindowHeight:NO];
    } else {
        [KKDataTool shareTools].window.rootViewController = nav;
        [KKDataTool shareTools].window.hidden = NO;
        [[KKDataTool shareTools].window makeKeyAndVisible];
        [KKDataTool shareTools].showWindow.hidden = NO;
        [[KKDataTool shareTools] setShowWindowHeight:YES];
    }
    if (popToRootVC == NO) {
        return;
    }
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController * curVc = [app currentVc];
    //进入房间之后，回到根控制器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [curVc.navigationController popToRootViewControllerAnimated:NO];
    });
}
+ (BOOL)showSecondWindow
{
    UIViewController * wv = [[KKDataTool shareTools] wVc];
    return wv != nil;
}
+ (KKBigHouseViewController *)currentBigRoomWithPwd:(NSString *)pwd
{
    KKBigHouseViewController * vc = [[self class] currentBigHouse];
    if (vc && vc.pwd.integerValue == pwd.integerValue) {
        return vc;
    }
    return nil;
}
+ (KKBigHouseViewController *)currentBigHouse
{
    UIViewController * wvc = [[KKDataTool shareTools] wVc];
    if (wvc && [wvc isKindOfClass:[KKBigHouseViewController class]]) {
        return (KKBigHouseViewController *)wvc;
    }
    UIViewController * svc = [[KKDataTool shareTools] showWVc];
    if (svc && [svc isKindOfClass:[KKBigHouseViewController class]]) {
        return (KKBigHouseViewController *)svc;
    }
    return nil;
}
@end
