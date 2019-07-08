//
//  KKShareTool.m
//  game
//
//  Created by greatkk on 2019/1/7.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKShareTool.h"
#import "KKNewShareView.h"

@implementation KKShareTool
+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType viewController:(UIViewController *)viewController
{
    NSString * nickName = @"赛事狗";
    if ([KKDataTool user] && [KKDataTool user].nickname) {
        nickName = [KKDataTool user].nickname;
    }
    [[self class] shareWebPageWithPlatformType:platformType viewController:viewController title:[NSString stringWithFormat:@"%@邀请您到赛事狗一起参加电竞嘉年华啦~",nickName] des:@"天天参加锦标赛就得奖励，赛事狗就是这么实在" webpageUrl:@"https://www.matchgo.co/"];
}
+ (void)shareWebPageWithPlatformType:(UMSocialPlatformType)platformType viewController:(UIViewController *)viewController title:(NSString *)title des:(NSString *)des webpageUrl:(NSString *)webpageUrl
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString * nickName = @"赛事狗";
    if ([KKDataTool user] && [KKDataTool user].nickname) {
        nickName = [KKDataTool user].nickname;
    }
    NSString * t = [NSString stringWithFormat:@"%@邀请您到赛事狗一起参加电竞嘉年华啦~",nickName];
    if ([HNUBZUtil checkStrEnable:title]) {
        t = title;
    }
    NSString * d = @"天天参加锦标赛就得奖励，赛事狗就是这么实在";
    if ([HNUBZUtil checkStrEnable:des]) {
        d = des;
    }
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:t descr:d thumImage:[UIImage imageNamed:@"shareIcon"]];
    NSString * w = @"https://www.matchgo.co/";
    if ([HNUBZUtil checkStrEnable:webpageUrl]) {
        w = webpageUrl;
    }
    w = [w stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];;
    //设置网页地址
    shareObject.webpageUrl = w;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
        if (error) {
            DLOG(@"分享错误原因：%@",error);
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                DLOG(@"分享结果:%@--%@",resp.message,resp.originalResponse);
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}
//分享官网
+ (void)shareHostUrlWithViewController:(UIViewController *)viewController
{
    KKNewShareView * shareView = [[KKNewShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [viewController.view.window addSubview:shareView];
    shareView.shareBlock = ^(NSInteger shareType) {
        [KKShareTool shareWebPageToPlatformType:shareType viewController:viewController];
    };
}
//是否能分享，是否安装了微信或qq
+ (BOOL)judgeShouldShare
{
    return [WXApi isWXAppInstalled] || [QQApiInterface isQQInstalled];
}
+ (void)shareInvitecodeWithViewController:(UIViewController *)viewController
{
    //没有安装微信qq不能分享
    if ([[self class] judgeShouldShare] == false) {
        [KKAlert showText:@"您的设备暂不能分享" toView:viewController.view];
        return;
    }
    //未登录，分享官网
    if ([KKDataTool token] == nil) {
        [[self class] shareHostUrlWithViewController:viewController];
        return;
    }
    KKUser * user = [KKDataTool user];
    if (user.inv_code) {
        [[self class] showShareViewWithCodeStr:user.inv_code viewController:viewController shareType:KKShareTypeInviteCode];
    } else {
        [KKAlert showAnimateWithText:nil toView:viewController.view.window];
        [KKDataTool refreshUserInfoWithSuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismissWithView:viewController.view.window];
            [[self class] showShareViewWithCodeStr:[KKDataTool user].inv_code viewController:viewController shareType:KKShareTypeInviteCode];
        } erreorBlock:^(NSError *error) {
            [KKAlert dismissWithView:viewController.view.window];
            if ([HNUBZUtil checkStrEnable:(NSString *)error]) {
                [KKAlert showText:(NSString *)error toView:viewController.view.window];
            }
        }];
    }
}
+ (void)showShareViewWithCodeStr:(NSString *)codeStr viewController:(UIViewController *)viewController shareType:(KKShareType)shareType
{
    KKNewShareView * shareView = [[KKNewShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [viewController.view.window addSubview:shareView];
    shareView.codeStr = codeStr;
    shareView.shareType = shareType;
    shareView.shareBlock = ^(NSInteger shareType) {
//    https://www.matchgo.co/shareroom.html?u=测试用户&c=12345
//    https://www.matchgo.co/share.html?u=测试用户&c=0FAC
        NSString * shareUrl = @"https://www.matchgo.co/";
        if ([HNUBZUtil checkStrEnable:codeStr]) {
            NSString * nickName = @"赛事狗";
            if ([KKDataTool user] && [KKDataTool user].nickname) {
                nickName = [KKDataTool user].nickname;
            }
            if (codeStr.length == 5) {
                shareUrl = [NSString stringWithFormat:@"https://www.matchgo.co/shareroom.html?u=%@&c=%@",nickName,codeStr];
            } else {
                shareUrl = [NSString stringWithFormat:@"https://www.matchgo.co/share.html?u=%@&c=%@",nickName,codeStr];
            }
        }
        [KKShareTool shareWebPageWithPlatformType:shareType viewController:viewController title:@"" des:@"" webpageUrl:shareUrl];
//        [KKShareTool shareWebPageToPlatformType:shareType viewController:viewController];
    };
}
+ (void)shareRoomcode:(NSString *)roomCode viewController:(UIViewController *)viewController
{
    //没有安装微信qq不能分享
    if ([[self class] judgeShouldShare] == false) {
        [KKAlert showText:@"您的设备暂不能分享" toView:viewController.view];
        return;
    }
    //未登录，分享官网
    if ([KKDataTool token] == nil) {
        [[self class] shareHostUrlWithViewController:viewController];
        return;
    }
    [[self class] showShareViewWithCodeStr:roomCode viewController:viewController shareType:KKShareTypeRoomCode];
}
@end
