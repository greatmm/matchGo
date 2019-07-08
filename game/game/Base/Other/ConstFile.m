//
//  ConstFile.m
//  KKBaseFileOC
//
//  Created by GKK on 2018/8/6.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "ConstFile.h"


#ifdef kkDEBUGEnvironment
NSString * const baseUrl = @"https://test1.ogame.app/";
#else
NSString * const baseUrl = @"https://api.matchgo.co/";
#endif
NSString * const captchaUrl = @"captcha";
NSString * const vCodeUrl = @"login/vcode";
NSString * const loginUrl = @"login";
NSString * const accountUrl = @"account";
NSString * const addressesUrl = @"account/addresses";
NSString * const addAddressUrl = @"account/address";
NSString * const avatarUrl = @"account/avatar";
NSString * const gamesUrl = @"games";
NSString * const gameUrl = @"game/";
NSString * const wsUrl = @"services/ws";

NSString * const kGameMatchResultSuccess = @"kGameMatchResultSuccess";
NSString * const kGameMatchResultFail = @"kGameMatchResultFail";
NSString * const kEnterGame = @"kEnterGame";
NSString * const kGameResut = @"kGameResut";
NSString * const kCancelMatch = @"kCancelMatch";
NSString * const kBindAccountResult = @"kBindAccountResult";
NSString * const kJoinRoom = @"kJoinRoom";
NSString * const kLeaveRoom = @"kLeaveRoom";
NSString * const kRoomListChanged = @"kRoomListChanged";
NSString * const kChampionMatchStart = @"kChampionMatchStart";
NSString * const kChampionMatchEnd = @"kChampionMatchEnd";

NSString * const kFreeMatchTickets = @"kFreeMatchTickets";

NSString * const kWZRYUrl = @"tencent1104466820://";
NSString * const kCJZCUrl = @"tencent1106467070://";


NSString * const kMatchGoPrivacyUrl = @"https://www.matchgo.co/privacy";
NSString * const kMatchGoPayprotocolUrl = @"https://www.matchgo.co/payprotocol";
NSString * const kMatchGoEulaUrl = @"https://www.matchgo.co/eula";
NSString * const kInviteExplainUrl = @"https://www.matchgo.co/h5/share_rule.html";
