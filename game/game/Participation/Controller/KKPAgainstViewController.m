//
//  KKPAgainstViewController.m
//  game
//
//  Created by GKK on 2018/10/17.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKPAgainstViewController.h"
#import "ChoiceItem.h"
#import "KKChoiceControl.h"
#import "KKSelectButton.h"
#import "KKSingleSlider.h"
#import "KKShareView.h"
#import "KKHintView.h"
#import "KKBindAccountViewController.h"
#import "KKBigHouseViewController.h"
#import <UIButton+WebCache.h>
#import "KKChongzhiViewController.h"
#import "KKAlertViewStyleTwoBtmBtn.h"
#import "KKBZSliderView.h"
#import "KKBZChoicesRequestModel.h"
@interface KKPAgainstViewController ()
@property (weak, nonatomic) IBOutlet UIView *choiceView;//游戏选项
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choiceViewHeight;//游戏选项view的高度
@property (weak, nonatomic) IBOutlet UIView *gamePeopleView;//选择比赛人数
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gamePeopleHeight;//选择人数view的高度
@property (weak, nonatomic) IBOutlet KKBZSliderView *sliderView;//滑竿
@property (weak, nonatomic) IBOutlet UISwitch *passwordSwitch;//是否有密码
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;//房间名称
@property (weak, nonatomic) IBOutlet KKChoiceControl *leftControl;//竞技模式
@property (weak, nonatomic) IBOutlet KKChoiceControl *rightControl;//娱乐模式
@property (nonatomic,strong) NSMutableArray * leftChoiceArr;//左边选项数组
@property (nonatomic,strong) NSMutableArray * rightChoiceArr;//右边选项数组
@property (strong,nonatomic) NSArray * selCountArr;//选择人数的数组
@property (nonatomic,strong) KKSelectButton * currentChoiceBtn;//当前选中的choice
@property (nonatomic,strong) KKSelectButton * currentPopleBtn;//当前选中的人数
@property (nonatomic,strong) NSNumber * gamerId;//绑定游戏的账号id（创建房间要用到）
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;//是否有密码
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;//50金币/场
//@property (nonatomic, strong) KKBZSliderView *kkSliderView;
@end

@implementation KKPAgainstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addSubview:self.kkSliderView];
//    [self setConstraints];
    [self getChoiceItem];//获取游戏内容选项
    self.leftControl.selected = YES;//默认选中竞技模式（所有的游戏都有竞技模式）
    self.roomNameLabel.text = @"";
    __weak typeof(self) weakSelf = self;
    _sliderView.silderValueChange=^(NSUInteger value)
    {
        weakSelf.feeLabel.text=[NSString stringWithFormat:@"%lu金币/场",value];
    };
    //滑竿滑动时的回调，更新金币费用
//    self.sliderView.minValueChangeBlock = ^(NSInteger minValue) {
//        weakSelf.feeLabel.text = [NSString stringWithFormat:@"%ld金币/场",minValue];
//    };
    
}
#pragma mark
//- (void)setConstraints
//{
//    hnuSetWeakSelf;
//    [_kkSliderView mas_makeConstraints:^(MASConstraintMaker *make)
//     {
//         make.bottom.equalTo(weakSelf.view).mas_offset(-100);
//         make.width.mas_equalTo(kScreenWidth);
//         make.height.mas_equalTo(50);
//     }];
//}
#pragma mark - 懒加载属性
-(NSMutableArray *)leftChoiceArr
{
    if (_leftChoiceArr == nil) {
        _leftChoiceArr = [NSMutableArray new];
    }
    return _leftChoiceArr;
}
-(NSMutableArray *)rightChoiceArr
{
    if (_rightChoiceArr == nil) {
        _rightChoiceArr = [NSMutableArray new];
    }
    return _rightChoiceArr;
}
//- (KKBZSliderView *)kkSliderView
//{
//    if(!_kkSliderView)
//    {
//        _kkSliderView=[[KKBZSliderView alloc] init];
//        hnuSetWeakSelf;
//        _kkSliderView.silderValueChange=^(NSUInteger value)
//        {
//            weakSelf.feeLabel.text=[NSString stringWithFormat:@"%lu金币/场",value];
//        };
//    }
//    return _kkSliderView;
//}
#pragma mark - 获取游戏选项
- (void)getChoiceItem
{
    //viewwillapear 需要刷新数据
    [KKAlert showAnimateWithStauts:nil];
    [KKNetTool getChoicesGamesWithGameid:[NSNumber numberWithInteger:self.gameId] mId:@1 SuccessBlock:^(NSDictionary *dic) {
        KKBZChoicesRequestModel *model=[[KKBZChoicesRequestModel alloc] initWithJSONDict:dic];
        [self.sliderView resetWithData:model.gold];
        [KKAlert dismiss];
        self.selCountArr = dic[@"numselect"];//房间人数数组
        [self createPeopleCountWithArr:self.selCountArr];//创建人数选择按钮
        NSArray * choices = dic[@"choices"];
        NSMutableArray * items = [ChoiceItem mj_objectArrayWithKeyValuesArray:choices];
        [self dealChoiceItemArr:items];
        [self createBtnsWithTitleArr:self.leftChoiceArr];
    } erreorBlock:^(NSError *error) {
        //        NSLog(@"%@",error);
        [KKAlert dismiss];
        //            [KKAlert showText:@"获取数据失败"];
    }];
}
#pragma mark - 创建选项按钮
- (void)createBtnsWithTitleArr:(NSArray *)titleArr{
    
    [self.choiceView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count = titleArr.count;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (ScreenWidth - 60)/3;
    CGFloat h = 44;
    if (count == 0) {
        self.choiceViewHeight.constant = 0;
        [self.view layoutIfNeeded];
        return;
    }
    for (int i = 0; i < count; i ++) {
        NSInteger row = i/3;
        NSInteger list = i%3;
        x = (w + 14) * list;
        y = (h + 10) * row;
        ChoiceItem * item = titleArr[i];
        NSString * title = item.choice;
        KKSelectButton * btn = [KKSelectButton buttonWithType:UIButtonTypeCustom];
        btn.selected = NO;
        btn.tag = i;
        [btn configurateTitleUi];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn configurateImageUi];
        [btn sd_setImageWithURL:[NSURL URLWithString:item.icon] forState:UIControlStateNormal placeholderImage:btn.currentImage];
        btn.frame = CGRectMake(x, y, w, h);
        [btn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.choiceView addSubview:btn];
    }
    self.choiceViewHeight.constant = y + h;
    [self.view layoutIfNeeded];
    KKSelectButton * btn = (KKSelectButton *)self.choiceView.subviews.firstObject;
    [self clickSelectBtn:btn];//默认选中第一个
}
#pragma mark - 切换选项
- (void)clickSelectBtn:(KKSelectButton *)btn
{
    if (_currentChoiceBtn == btn) {
        return;
    }
    btn.selected = YES;
    _currentChoiceBtn.selected = NO;
    _currentChoiceBtn = btn;
    [self changeRoomName];
}
#pragma mark - 改变房间名
- (void)changeRoomName
{
    if (self.currentPopleBtn && self.currentChoiceBtn) {
        NSString * people = [NSString stringWithFormat:@"%@人赛",self.selCountArr[self.currentPopleBtn.tag]];
        NSArray * choiceArr;
        if (self.rightControl.selected) {
            choiceArr = self.rightChoiceArr;
        } else {
            choiceArr = self.leftChoiceArr;
        }
        ChoiceItem * item = choiceArr[self.currentChoiceBtn.tag];
        self.roomNameLabel.text = [NSString stringWithFormat:@"%@%@",item.choice,people];
    } else {
        self.roomNameLabel.text = @"";
    }
}
#pragma mark - 创建人数选项
- (void)createPeopleCountWithArr:(NSArray *)titleArr
{
    NSInteger count = titleArr.count;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (ScreenWidth - 60)/3;
    CGFloat h = 44;
    if (count == 0) {
        self.choiceViewHeight.constant = 0;
        [self.view layoutIfNeeded];
        return;
    }
    for (int i = 0; i < count; i ++) {
        NSInteger row = i/3;
        NSInteger list = i%3;
        x = (w + 14) * list;
        y = (h + 10) * row;
        NSNumber * peopleNumber = titleArr[i];
        NSString * title = [NSString stringWithFormat:@"%@人",peopleNumber];
        KKSelectButton * btn = [KKSelectButton buttonWithType:UIButtonTypeCustom];
        btn.selected = NO;
        btn.tag = i;
        [btn configurateTitleUi];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.frame = CGRectMake(x, y, w, h);
        [btn addTarget:self action:@selector(clickPeopleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.gamePeopleView addSubview:btn];
    }
    self.gamePeopleHeight.constant = y + h;
    [self.gamePeopleView layoutIfNeeded];
    [self clickPeopleBtn:self.gamePeopleView.subviews.firstObject];
}
#pragma mark - 点击人数选项
- (void)clickPeopleBtn:(KKSelectButton *)btn
{
    if (_currentPopleBtn == btn) {
        return;
    }
    btn.selected = YES;
    _currentPopleBtn.selected = NO;
    _currentPopleBtn = btn;
    [self changeRoomName];
}
#pragma mark - 对请求到的游戏内容进行分组，分为竞技选项和娱乐选项
- (void)dealChoiceItemArr:(NSArray *)arr
{
    [self.rightChoiceArr removeAllObjects];
    [self.leftChoiceArr removeAllObjects];
    for (ChoiceItem * item in arr) {
        if (item.choicetype.integerValue == 1) {
            [self.rightChoiceArr addObject:item];
        } else {
            [self.leftChoiceArr addObject:item];
        }
    }
}
#pragma mark - 点击竞技模式和娱乐模式
- (IBAction)clickChoiceTypeControl:(UIControl *)sender {
    if (sender.selected) {
        return;
    }
    if (sender.tag == 0 && self.leftChoiceArr.count == 0) {
        [KKAlert showText:@"敬请期待" toView:self.view];
        return;
    }
    if (sender.tag == 1 && self.rightChoiceArr.count == 0) {
        [KKAlert showText:@"敬请期待" toView:self.view];
        return;
    }
    sender.selected = YES;
    self.currentChoiceBtn = nil;
    [self changeRoomName];
    if (sender.tag == 0) {
        self.rightControl.selected = NO;
        [self createBtnsWithTitleArr:self.leftChoiceArr];
    } else {
        self.leftControl.selected = NO;
        [self createBtnsWithTitleArr:self.rightChoiceArr];
    }
}
#pragma mark - 创建房间
- (void)createRoom
{
    if (self.leftChoiceArr.count == 0 && self.selCountArr == nil) {
        [self getChoiceItem];
        return;
    }
    //游戏内容及比赛人数都有默认值，金币数也有默认值，防止选为0
    if (self.sliderView.currentMin == 0) {
        [KKAlert showText:@"请选择金币数量" toView:self.view];
        return;
    }
    //获取绑定的账号信息
    if (self.gamerId) {
        [self addRoom];
    } else {
        [self getAccountBind];
    }
}

#pragma mark - 获取账号信息
- (void)getAccountBind
{
    [KKNetTool getBindAccountListWithGameid:[NSNumber numberWithInteger:self.gameId] SuccessBlock:^(NSDictionary *dic) {
        NSArray * arr = (NSArray *)dic;
        if (arr.count) {
            NSDictionary * dict = arr.firstObject;
            self.gamerId = dict[@"id"];
            [self addRoom];
        } else {
            [self showBindAccount];
        }
    } erreorBlock:^(NSError *error) {
        //        NSLog(@"%@",error);
    }];
}
#pragma mark - 显示绑定账号提示view
- (void)showBindAccount
{
    KKHintView * hintView = [KKHintView shareHintView];
    [hintView assignWithGameId:self.gameId];
    hintView.ensureBlock = ^{
        KKBindAccountViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"bindAccountVC"];
        vc.gameId = self.gameId;
        [self.navigationController pushViewController:vc animated:YES];
    };
}
#pragma mark - 点击开关
- (IBAction)clickPwdSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.pwdLabel.text = @"是否公开：否";
    } else {
        self.pwdLabel.text = @"是否公开：是";
    }
}
#pragma mark - 创建一个房间
- (void)addRoom
{
    //拼凑参数
    ChoiceItem * item;
    if (self.leftControl.selected) {
        item = self.leftChoiceArr[self.currentChoiceBtn.tag];
    } else {
        item = self.rightChoiceArr[self.currentChoiceBtn.tag];
    }
    NSNumber * pick = item.code;
    NSString * roomName = self.roomNameLabel.text;
    NSNumber * gamerId = self.gamerId;
    NSInteger t = self.sliderView.currentMin;
    NSNumber * ticket = [NSNumber numberWithInteger:t];
    NSNumber *  choiceType = self.leftControl.selected?@2:@1;
    NSNumber * slot;
    if (self.selCountArr) {
        slot = self.selCountArr[self.currentPopleBtn.tag];
    } else {
        slot = @2;
    }
    int p = self.passwordSwitch.on?1:0;
    NSNumber * private = [NSNumber numberWithInt:p];
    NSDictionary * parm = @{@"gamerid":gamerId,@"name":roomName,@"gold":ticket,@"pick":pick,@"choicetype":choiceType,@"slots":slot,@"private":private};
    //创建房间之后的处理
    [KKAlert showAnimateWithText:nil toView:self.view];
    [KKNetTool createRoomWithParm:parm successBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:self.view];
        NSMutableDictionary * dict = dic.mutableCopy;
        dict[@"share"] = @1;
        //直接进入房间
        [self enterRoomWithRoomInfo:dict];
        //        if (p) {
        //            //有密码要弹出分享框，显示密码
        //            dispatch_main_async_safe(^{
        //                NSNumber * pwd =dic[@"ID"];
        //                [self showShareViewWithPwd:pwd roomInfo:dic];
        //            })
        //        } else {
        //            //无密码的直接进入房间
        //            [self enterRoomWithRoomInfo:dic];
        //        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:self.view];
        if ([error isKindOfClass:[NSString class]]) {
            if ([(NSString *)error isEqualToString:@"金币余额不足"]) {
                [self showZuanHintView];
            }
        }
    }];
}
#pragma mark - 显示提示充值

- (void)showZuanHintView
{
    NSInteger max=self.sliderView.currentMin;
    hnuSetWeakSelf;
    [KKAlertViewStyleTwoBtmBtn showRechargeWithVC:self amount:max block:^(BOOL isSucceeded, NSString *msg,NSError * _Nullable error)
     {
         [weakSelf addRoom];
     }];
//    [KKAlert showAnimateWithText:nil toView:self.view];
//    [KKNetTool getMyWalletSuccessBlock:^(NSDictionary *dic) {
//        [KKAlert dismissWithView:self.view];
//        NSNumber * diamond = dic[@"diamond"];
//        NSNumber * gold = dic[@"gold"];
//        NSInteger max = self.sliderView.currentMin;
//        KKAlertViewStyleTwoBtmBtn * roomHintView = [KKAlertViewStyleTwoBtmBtn shareAlertViewStyleTwoBtmBtn];
//        roomHintView.frame = [UIScreen mainScreen].bounds;
//        [self.view.window addSubview:roomHintView];
//        NSInteger goldLack = gold.integerValue + diamond.integerValue * 10 - max;
//        if (goldLack > 0) {
//            //钻石兑换之后足够
//            roomHintView.titleLabel.text = @"";
//            roomHintView.subtitleLabel.text = @"金币不足，需要将钻石换为金币继续参加比赛";
//            [roomHintView.rightBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
//            roomHintView.clickRightBtnBlock = ^{
//                [self gotoChongzhiWithType:NO lackCount:max - gold.integerValue];
//            };
////            roomHintView.label1.text = @"金币不足，需要将钻石换为金币";
////            roomHintView.label2.text = @"继续参加比赛";
////            roomHintView.accountLabel.text = [NSString stringWithFormat:@"账户余额:%@",diamond];
////            [roomHintView.btmBtn setTitle:@"兑换金币" forState:UIControlStateNormal];
////            roomHintView.ensureBlock = ^{
////            [self gotoChongzhiWithType:NO lackCount:max - gold.integerValue];
////            };
//        } else {
//            roomHintView.titleLabel.text = @"";
//            roomHintView.subtitleLabel.text = @"金币不足，将无法参赛,请先充值";
//            [roomHintView.rightBtn setTitle:@"立即充值" forState:UIControlStateNormal];
//            roomHintView.clickRightBtnBlock = ^{
//                [self gotoChongzhiWithType:YES lackCount:0];
//            };
////            roomHintView.label1.text = @"金币不足，将无法参赛";
////            roomHintView.label2.text = @"请先充值";
////            roomHintView.accountLabel.text = [NSString stringWithFormat:@"账户余额:%@",gold];
////            roomHintView.zuanIcon.image = [UIImage imageNamed:@"coin_big"];
////            roomHintView.ensureBlock = ^{
////                [self gotoChongzhiWithType:YES lackCount:0];
////            };
//        }
//    } erreorBlock:^(NSError *error) {
//        [KKAlert dismissWithView:self.view];
//        if ([error isKindOfClass:[NSString class]]) {
//            [KKAlert showText:(NSString *)error toView:self.view];
//        }
//    }];
}
- (void)gotoChongzhiWithType:(BOOL)chongzhi lackCount:(NSInteger)lackCount
{
    KKChongzhiViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"chongzhiVC"];
    vc.isChongzhi = chongzhi;
    vc.lackGold = lackCount;
    __weak typeof(self) weakSelf = self;
    vc.chongzhiBlock = ^{
        [weakSelf addRoom];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 显示密码，给好友分享房间
- (void)showShareViewWithPwd:(NSNumber *)pwd roomInfo:(NSDictionary *)dic
{
//    KKShareView * shareView = [KKShareView shareView];
//    shareView.frame = [UIScreen mainScreen].bounds;
//    shareView.titleLabel.text = @"快点邀请好友加入吧";
//    shareView.pwdLabel.text = [NSString stringWithFormat:@"密码:%@",pwd];
//    //不管，分享不分享，最后都进入房间
//    shareView.closeBlock = ^{
//        [self enterRoomWithRoomInfo:dic];
//    };
//    [[UIApplication sharedApplication].delegate.window makeKeyWindow];
//    [[UIApplication sharedApplication].delegate.window addSubview:shareView];
}
#pragma mark - 创建房间成功之后，进入房间（创建房间之后要返回到rootViewController）
- (void)enterRoomWithRoomInfo:(NSDictionary *)dic
{
    [KKDataTool shareTools].gameItem = [KKDataTool itemWithGameId:self.gameId];
    [KKHouseTool enterBigHouseWithDic:dic popToRootVC:YES];
//    return;
//    NSDictionary * dict = dic[@"match"];
//    KKBigHouseViewController * infoVC = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"bighouseVC"];
//    infoVC.matchId = dict[@"id"];
//    infoVC.pwd = dic[@"ID"];
//    infoVC.roomDic = dic;
//    KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:infoVC];
//    [KKDataTool shareTools].window.rootViewController = nav;
//    [[KKDataTool shareTools].window makeKeyAndVisible];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    });
}
@end
