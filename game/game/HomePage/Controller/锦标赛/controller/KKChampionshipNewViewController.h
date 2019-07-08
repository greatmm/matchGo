//
//  KKChampionshipNewViewController.h
//  game
//
//  Created by linsheng on 2019/1/14.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKBaseViewController.h"
#import "KKChampionshipsMatchModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol KKChampionshipNewViewControllerDelegate <NSObject>
//这坨代码只是为了快速迭代 回头整理
- (void)show;
- (void)openRoom;
- (void)dismiss;
- (void)setBtmH:(CGFloat)btmH;
- (void)setIsLeave:(BOOL)isLeave;
- (void)lookupResult;
@end
@interface KKChampionshipNewViewController : KKBaseViewController
@property (strong, nonatomic) KKChampionshipsModel *modelChampionships;
@property (strong,nonatomic) NSDictionary * dataDic;
@property (assign,nonatomic) BOOL isSmall;
@property (assign,nonatomic) BOOL secondWindow;
@property (strong,nonatomic) NSNumber * cId;//锦标赛id
@property (strong,nonatomic) NSNumber * __nullable matchId;//当前比赛id

@property (nonatomic,assign) BOOL isOpen;//是否是打开状态;
//零时方案 对外控制用
@property (weak, nonatomic) IBOutlet UIView *navView;
//放大时的view
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (assign,nonatomic) NSInteger gameId;//当前哪个游戏
//@property (strong, nonatomic) UIView *smallView;//小房间
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign,nonatomic) BOOL isLeave;//是否是返回首页
@property (weak, nonatomic) id  <KKChampionshipNewViewControllerDelegate>delegate;//小房间
@property (strong, nonatomic) KKSmallHouseViewController *smallHouse;
- (void)openRoom;//放大，在外边要调用
- (void)dismiss;//消失
- (void)dealData;//更新数据
- (void)refreshData;
- (void)destoryTimer;
@end

NS_ASSUME_NONNULL_END
