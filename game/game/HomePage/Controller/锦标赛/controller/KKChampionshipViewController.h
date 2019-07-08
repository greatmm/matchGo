//
//  KKChampionshipViewController.h
//  game
//
//  Created by greatkk on 2018/11/1.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface KKChampionshipViewController : UIViewController
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
@property (strong, nonatomic) UIView *smallView;//小房间
- (void)openRoom;//放大，在外边要调用
- (void)dismiss;//消失
- (void)dealData;//更新数据
- (void)refreshData;
- (void)destoryTimer;
@end

NS_ASSUME_NONNULL_END
