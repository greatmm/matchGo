//
//  KKHintTool.m
//  game
//
//  Created by greatkk on 2018/12/5.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKHintTool.h"
#import "KKResultHintWindow.h"
#import "KKBigHouseViewController.h"
#import "Appdelegate.h"
#import "KKChampionshipViewController.h"
#import "KKChampionResultNewViewController.h"
@interface KKHintTool ()

@end

@implementation KKHintTool

static KKResultHintWindow * hintWindow = nil;
static dispatch_source_t timer = nil;

+(void)showResultHintWithDic:(NSDictionary *)resultDic
{
    //关闭定时器
    if (timer != nil) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
    CGFloat bottom = [KKHintTool bottomHeight];
    CGFloat time = 0;
    //如果现实其它的结果，先消失
    if (hintWindow != nil) {
        [KKHintTool dismiss];
        time = 0.25;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hintWindow = [KKResultHintWindow new];
        hintWindow.backgroundColor = [UIColor whiteColor];
        [hintWindow makeKeyAndVisible];
        hintWindow.frame = CGRectMake(8, ScreenHeight - bottom - kSmallHouseHeight, ScreenWidth - 16, kSmallHouseHeight);
        hintWindow.mj_y = ScreenHeight;
        hintWindow.resultDic = resultDic;
        hintWindow.clickBlock = ^{
            //点击之后，停止定时器和UI，请求结果数据
            dispatch_main_async_safe(^{
                if (timer != nil) {
                    dispatch_source_cancel(timer);
                    timer = nil;
                }
                [KKHintTool dismiss];
            })
//            NSLog(@"请求数据---");
            [KKHouseTool enterRoomWithRoomid:resultDic[@"matchid"] popToRootVC:NO];
//            [KKNetTool getMatchInfoWithMatchId:resultDic[@"matchid"] SuccessBlock:^(NSDictionary *dic) {
////                NSLog(@"请求到的数据---%@",dic);
//                dispatch_main_async_safe(^{
//                    UIViewController * v = [KKHintTool currentVc];
//                    KKBigHouseViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"bighouseVC"];
//                    vc.roomDic = dic;
//                    vc.showResult = YES;
//                    [v.navigationController pushViewController:vc animated:YES];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        KKBigHouseViewController * vController = (KKBigHouseViewController *)[KKHintTool wRootVc];
//                        if(vController && [vController isKindOfClass:[KKBigHouseViewController class]]){
//                            if ([vController.matchId isEqual:resultDic[@"matchid"]]) {
//                                [vController dismissAnimated:NO];
//                            }
//                        } else {
//                            vController = (KKBigHouseViewController *)[KKHintTool swRootVc];
//                            if (vController && [vController isKindOfClass:[KKBigHouseViewController class]]) {
//                                if ([vController.matchId isEqual:resultDic[@"matchid"]]) {
//                                    [vController dismissAnimated:NO];
//                                }
//                            }
//                        }
//                    });
//                })
//            } erreorBlock:^(NSError *error) {
////                NSLog(@"请求到的数据出错---%@",error);
//            }];
        };
        //关闭
        hintWindow.closeBlock = ^{
            if (timer != nil) {
                dispatch_source_cancel(timer);
                timer = nil;
            }
            [KKHintTool dismiss];
        };
        //显示出来
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews animations:^{
            hintWindow.mj_y = ScreenHeight - bottom - kSmallHouseHeight;
        } completion:^(BOOL finished) {}];
    });
    //添加计时器，5s之后自动消失
    [KKHintTool addTimer];
}
+(void)showChampionMatchBegin:(NSDictionary *)beginDic
{
    UIViewController * wVc = [KKDataTool shareTools].windowRootVc;
//    if (wVc) {
//        UINavigationController * nav = (UINavigationController *)wVc;
//        UIViewController * vc = nav.childViewControllers.firstObject;
//        if ([vc isKindOfClass:[KKChampionshipViewController class]]) {
//            return;
//        }
//    }
    UIViewController * sVc = [KKDataTool shareTools].showWindowRootVc;
//    if (sVc) {
//        UINavigationController * nav = (UINavigationController *)sVc;
//        UIViewController * vc = nav.childViewControllers.firstObject;
//        if ([vc isKindOfClass:[KKChampionshipViewController class]]) {
//            return;
//        }
//    }
    if (sVc && wVc) {
        return;
    }
    //关闭定时器
    if (timer != nil) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
    CGFloat bottom = [KKHintTool bottomHeight];
    CGFloat time = 0;
    //如果现实其它的结果，先消失
    if (hintWindow != nil) {
        [KKHintTool dismiss];
        time = 0.25;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hintWindow = [KKResultHintWindow new];
        hintWindow.backgroundColor = [UIColor whiteColor];
        [hintWindow makeKeyAndVisible];
        hintWindow.frame = CGRectMake(8, ScreenHeight - bottom - kSmallHouseHeight, ScreenWidth - 16, kSmallHouseHeight);
        hintWindow.mj_y = ScreenHeight;
        hintWindow.beginDic = beginDic;
        hintWindow.clickBlock = ^{
            //点击之后，停止定时器和UI，请求结果数据
            if (timer != nil) {
                dispatch_source_cancel(timer);
                timer = nil;
            }
            [KKHintTool dismiss];
            NSNumber * cId = beginDic[@"id"];
            if (cId == nil) {
                return;
            }
            [KKHouseTool enterChampionWihtCid:cId];
//            dispatch_main_async_safe(^{
//                [KKAlert showAnimateWithStauts:nil];
//                [KKNetTool getChampionInfoWithCid:cId successBlock:^(NSDictionary *dic) {
//                    [KKAlert dismiss];
//                    KKChampionshipViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"championship"];
//                    vc.dataDic = dic;
//                    KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:vc];
//                    [KKDataTool shareTools].window.rootViewController = nav;
//                    [[KKDataTool shareTools].window makeKeyAndVisible];
//                } erreorBlock:^(NSError *error) {
//                    [KKAlert dismiss];
//                }];
//            })
        };
        //关闭
        hintWindow.closeBlock = ^{
            if (timer != nil) {
                dispatch_source_cancel(timer);
                timer = nil;
            }
            [KKHintTool dismiss];
        };
        //显示出来
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews animations:^{
            hintWindow.mj_y = ScreenHeight - bottom - kSmallHouseHeight;
        } completion:^(BOOL finished) {}];
    });
    //添加计时器，5s之后自动消失
    [KKHintTool addTimer];
}
+(void)showChampionMatchEnd:(NSDictionary *)endDic
{
    UIViewController * wVc = [KKDataTool shareTools].windowRootVc;
//    if (wVc) {
//        return;
//    }
    UIViewController * sVc = [KKDataTool shareTools].showWindowRootVc;
//    if (sVc) {
//        return;
//    }
    if (wVc && sVc) {
        return;
    }
    //关闭定时器
    if (timer != nil) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
    CGFloat bottom = [KKHintTool bottomHeight];
    CGFloat time = 0;
    //如果现实其它的结果，先消失
    if (hintWindow != nil) {
        [KKHintTool dismiss];
        time = 0.25;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KKEndChampionNotification object:endDic[@"id"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        hintWindow = [KKResultHintWindow new];
        hintWindow.backgroundColor = [UIColor whiteColor];
        [hintWindow makeKeyAndVisible];
        hintWindow.frame = CGRectMake(8, ScreenHeight - bottom - kSmallHouseHeight, ScreenWidth - 16, kSmallHouseHeight);
        hintWindow.mj_y = ScreenHeight;
        hintWindow.endDic = endDic;
        hintWindow.clickBlock = ^{
            //点击之后，停止定时器和UI，请求结果数据
            if (timer != nil) {
                dispatch_source_cancel(timer);
                timer = nil;
            }
            dispatch_main_async_safe(^{
                [KKHintTool dismiss];
                [KKHouseTool enterChampionWihtCid:endDic[@"id"]];
            })
        };
        //关闭
        hintWindow.closeBlock = ^{
            if (timer != nil) {
                dispatch_source_cancel(timer);
                timer = nil;
            }
            [KKHintTool dismiss];
        };
        //显示出来
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews animations:^{
            hintWindow.mj_y = ScreenHeight - bottom - kSmallHouseHeight;
        } completion:^(BOOL finished) {}];
    });
    [KKHintTool addTimer];
}
+(UIViewController *)wRootVc
{
    UINavigationController * nc = (UINavigationController *)[KKDataTool shareTools].windowRootVc;
    if (nc) {
        return nc.childViewControllers.firstObject;
    }
    return nil;
}
+(UIViewController *)swRootVc
{
    UINavigationController * nc = (UINavigationController *)[KKDataTool shareTools].showWindowRootVc;
    if (nc) {
        return nc.childViewControllers.firstObject;
    }
    return nil;
}
+(UIViewController *)currentVc
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return [delegate currentVc];
}
+(CGFloat)bottomHeight
{
    UIViewController * vc = [self currentVc];
    BOOL showTabbar = !vc.tabBarController.tabBar.hidden;
    CGFloat bottom = 0;
    if (showTabbar) {
        bottom = [KKDataTool tabBarH];
    } else {
        bottom = isIphoneX?34:0;
    }
    return bottom;
}
+(void)dismiss
{
    if (hintWindow == nil) {
        return;
    }
    dispatch_main_async_safe(^{
        [hintWindow resignKeyWindow];
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionLayoutSubviews animations:^{
            hintWindow.mj_y = ScreenHeight;
        } completion:^(BOOL finished) {
            hintWindow.hidden = YES;
            hintWindow = nil;
        }];
    })
}
+(void)addTimer
{
    //添加计时器，5s之后自动消失
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __block int timeout = 6;
    dispatch_source_set_event_handler(timer, ^{
        timeout--;
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(timer);
            timer = nil;
            [KKHintTool dismiss];
        }
    });
    dispatch_resume(timer);
}
@end
