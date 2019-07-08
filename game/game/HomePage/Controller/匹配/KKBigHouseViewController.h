//
//  KKBigHouseViewController.h
//  game
//
//  Created by greatkk on 2018/11/22.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKBigHouseViewController : UIViewController

@property (nonatomic,strong) NSNumber * matchId;
@property (assign,nonatomic) NSInteger gameType;//比赛类型，匹配，自建房，锦标赛
//@property (nonatomic,assign) BOOL fromList;//从列表中跳过来的
@property (nonatomic,assign) BOOL isSmall;//最小化
@property (nonatomic,assign) BOOL secondWindow;//第一个还是第二个房间 yes表示第二个 no表示第一个
@property (strong,nonatomic) NSDictionary * roomDic;//带有数据的跳转
@property(nonatomic,strong) NSNumber * pwd;//房间密码
@property (assign,nonatomic) BOOL showResult;//是否显示结果页
@property (nonatomic,assign) BOOL isOpen;//是否是打开状态
@property (assign,nonatomic) BOOL isCreate;//刚创建成功进来，显示分享view
- (void)openRoom;//放大
- (void)dismiss;//消失
- (void)dismissAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
