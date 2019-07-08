//
//  KKNewShareView.h
//  game
//
//  Created by greatkk on 2019/1/15.
//  Copyright © 2019 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
typedef NS_ENUM(NSInteger, KKShareType) {
    KKShareTypeInviteCode = 0,
    KKShareTypeRoomCode ,
    KKShareTypeResult
};
NS_ASSUME_NONNULL_BEGIN

@interface KKNewShareView : UIView
@property (strong,nonatomic) void(^shareBlock)(NSInteger shareType);
@property (strong,nonatomic) NSString * codeStr;
@property (assign,nonatomic) KKShareType shareType;
@end

NS_ASSUME_NONNULL_END
