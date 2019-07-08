//
//  ConstFile.h
//  KKBaseFileOC
//
//  Created by GKK on 2018/8/6.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const baseUrl;
UIKIT_EXTERN NSString * const imgBaseUrl;
#pragma mark - 登录，验证码...
UIKIT_EXTERN NSString * const captchaUrl;//获取图形校验码
UIKIT_EXTERN NSString * const vCodeUrl;//发送登录验证码
UIKIT_EXTERN NSString * const loginUrl;//登录
UIKIT_EXTERN NSString * const accountUrl;//账户
UIKIT_EXTERN NSString * const addressesUrl;//地址列表
UIKIT_EXTERN NSString * const addAddressUrl;//增加一个地址
UIKIT_EXTERN NSString * const avatarUrl;//上传头像地址

#pragma mark - 首页
UIKIT_EXTERN NSString * const gamesUrl;//首页游戏列表
UIKIT_EXTERN NSString * const gameUrl;//游戏信息

#pragma mark - websocket
UIKIT_EXTERN NSString * const wsUrl;//获取ws列表








#pragma mark - 通知
UIKIT_EXTERN NSString * const kGameMatchResultSuccess;
UIKIT_EXTERN NSString * const kGameMatchResultFail;
UIKIT_EXTERN NSString * const kEnterGame;
UIKIT_EXTERN NSString * const kCancelMatch;//对方取消确认
UIKIT_EXTERN NSString * const kGameResult;//游戏结果
UIKIT_EXTERN NSString * const kBindAccountResult;//绑定账号结果
UIKIT_EXTERN NSString * const kJoinRoom;//有人加入房间
UIKIT_EXTERN NSString * const kLeaveRoom;//有人离开房间
UIKIT_EXTERN NSString * const kRoomListChanged;//房间列表有变化
UIKIT_EXTERN NSString * const kChampionMatchStart;//锦标赛开始
UIKIT_EXTERN NSString * const kChampionMatchEnd;//锦标赛结算结束
UIKIT_EXTERN NSString * const kFreeMatchTickets;//免费比赛页，返回成功邀请的人数和入场券数
#pragma mark 游戏scheme 
UIKIT_EXTERN NSString * const kWZRYUrl;
UIKIT_EXTERN NSString * const kCJZCUrl;


#pragma mark - h5url地址
UIKIT_EXTERN NSString * const kMatchGoPrivacyUrl;//隐私保护协议
UIKIT_EXTERN NSString * const kMatchGoPayprotocolUrl;//充值协议
UIKIT_EXTERN NSString * const kMatchGoEulaUrl;//软件许可协议
UIKIT_EXTERN NSString * const kInviteExplainUrl;//邀请码url

