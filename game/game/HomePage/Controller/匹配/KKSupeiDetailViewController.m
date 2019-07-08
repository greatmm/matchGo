//
//  KKSupeiDetailViewController.m
//  game
//
//  Created by GKK on 2018/8/14.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKSupeiDetailViewController.h"
#import "KKSelectButton.h"
#import "KKSliderView.h"
#import "KKHintView.h"
#import "ChoiceItem.h"
#import "KKBindAccountViewController.h"
#import "KKMatchViewController.h"
#import "KKBigHouseViewController.h"
#import "KKChongzhiViewController.h"
#import <UIButton+WebCache.h>
#import "KKAlertViewStyleTwoBtmBtn.h"
#import "KKExplainViewController.h"
#import "KKBZSliderView.h"
#import "KKBZChoicesRequestModel.h"
@interface KKSupeiDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;//游戏图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;//适配iPhoneX

@property (strong, nonatomic) NSMutableArray<KKSelectButton*> *btns;//所有的游戏匹配项button
@property (nonatomic,strong) NSMutableArray * selBtnArr;//选中的游戏匹配项button
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//多少金币（0-100）
@property (weak, nonatomic) IBOutlet KKBZSliderView *sliderView;//双向滑动view

@property (nonatomic,assign) NSInteger bind;//是否绑定了账号，-1 表示请求失败，0表示没有绑定，1表示绑定过了
@property (nonatomic,assign) NSNumber * maxPick;//匹配选项要选择几个（多了少了都不行）
@property (nonatomic,strong) NSMutableArray<ChoiceItem *>* yuleChoiceItemArr;//匹配选项娱乐
@property (nonatomic,strong) NSMutableArray<ChoiceItem *>* jingjiChoiceItemArr;//匹配选项竞技
@property (weak, nonatomic) IBOutlet UIView *choiceBtnView; //游戏类型选项btn父视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choiceHeightCons;//游戏类型父视图高度
@property (weak, nonatomic) IBOutlet UIControl *jingjiControl;
@property (weak, nonatomic) IBOutlet UIControl *yuleControl;
@property (nonatomic,strong) NSDictionary * gamerDic;//绑定游戏的信息
@property (weak, nonatomic) IBOutlet UIButton *startBtn;//底部开始按钮
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UILabel *choiceNumberLabel;//比赛内容几选
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray * tipsArr;//滚动的内容
@property (nonatomic,strong)  dispatch_source_t timer;//tips滚动定时器
@end

@implementation KKSupeiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (isIphoneX) {
        self.imgHeight.constant = ScreenWidth/430 * 254;
        [self.view layoutIfNeeded];
        NSArray * imgArr = @[@"PUBGBigBGX",@"GKBigBGX",@"ZCBigBGX",@"LOLBigBGX"];
        self.imageView.image = [UIImage imageNamed:imgArr[[KKDataTool gameId] - 1]];
    } else {
        self.imgHeight.constant = ScreenWidth/375 * 197;
        [self.view layoutIfNeeded];
        NSArray * imgArr = @[@"PUBGBigBG",@"GKBigBG",@"ZCBigBG",@"LOLBigBG"];
        self.imageView.image = [UIImage imageNamed:imgArr[[KKDataTool gameId] - 1]];
    }
    self.bind = -1;
    self.selBtnArr = [NSMutableArray new];
    self.btns = [NSMutableArray new];
    self.startBtn.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    [self.startBtn setTitleColor:kSubtitleColor forState:UIControlStateNormal];
    self.startBtn.userInteractionEnabled = NO;
//    __weak typeof(self) weakSelf = self;
    hnuSetWeakSelf;
    self.sliderView.silderValueChange = ^(NSUInteger minValue) {
//        NSString * str = weakSelf.numberLabel.text;
//        NSArray * arr = [str componentsSeparatedByString:@"~"];
        weakSelf.numberLabel.text = [NSString stringWithFormat:@"%ld~%ld金币/场",weakSelf.sliderView.currentMin,weakSelf.sliderView.currentMax];
    };
//    self.sliderView.maxValueChangeBlock = ^(NSInteger maxValue) {
//        NSString * str = weakSelf.numberLabel.text;
//        NSArray * arr = [str componentsSeparatedByString:@"~"];
//        weakSelf.numberLabel.text = [NSString stringWithFormat:@"%@~%ld金币/场",arr.firstObject,(long)maxValue];
//    };
    //游戏对应的图标
    self.jingjiControl.userInteractionEnabled = NO;
    self.yuleControl.userInteractionEnabled = NO;
    self.jingjiControl.layer.borderColor = kThemeColor.CGColor;
    self.yuleControl.layer.borderColor = kThemeColor.CGColor;
    self.tipsArr = [NSMutableArray new];
    [self assignTips];
    [self addTimer];
    [self getChoiceItem];//获取匹配选项
    [self getAccountBind];//获取是否绑定了账号
    self.houseBtm = isIphoneX?(59 + 34):59;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
}
- (IBAction)clickInfoBtn:(id)sender {
    KKExplainViewController * explainVc = [KKExplainViewController new];
    explainVc.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pipeiExplain.png" ofType:nil]];
    [self.navigationController pushViewController:explainVc animated:YES];
    explainVc.navigationItem.title = @"怎么玩1V1挑战赛";
}

#pragma mark - 添加tips定时器
- (void)addTimer
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),5*NSEC_PER_SEC, 0); //每5秒执行
    __block int index = 0;
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setContentOffset:CGPointMake(0, 46 * index) animated:YES];
            index ++;
            if (index == 40001) {
                index = 0;
            }
        });
    });
    dispatch_resume(_timer);
}
-(void)assignTips
{
    NSString * s = @"玩家非同场单排赛竞技，战绩最优者获胜";
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:s];
    [str addAttributes:@{NSForegroundColorAttributeName:kOrangeColor} range:[s rangeOfString:@"单排赛"]];
    NSString * s1 = @"比赛内容请选择3项，更快匹配到对手";
    NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc] initWithString:s1];
    [str1 addAttributes:@{NSForegroundColorAttributeName:kOrangeColor} range:[s1 rangeOfString:@"选择3项"]];
    NSString * s2 = @"绑定信息需与比赛信息一致，否则被判输哟";
    NSMutableAttributedString * str2 = [[NSMutableAttributedString alloc] initWithString:s2];
    [str2 addAttributes:@{NSForegroundColorAttributeName:kOrangeColor} range:[s2 rangeOfString:@"绑定信息"]];
    NSString * s3 =  @"在规定时间内开始比赛和提交战绩，才能获得奖励哟";
    NSMutableAttributedString * str3 = [[NSMutableAttributedString alloc]initWithString:s3];
    [str3 addAttributes:@{NSForegroundColorAttributeName:kOrangeColor} range:[s3 rangeOfString:@"开始比赛"]];
    [str3 addAttributes:@{NSForegroundColorAttributeName:kOrangeColor} range:[s3 rangeOfString:@"提交战绩"]];
    NSArray * arr = @[str,str1,str2,str3];
    [self.tipsArr addObjectsFromArray:arr];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)clickBackBtn:(id)sender {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 懒加载

-(NSMutableArray<ChoiceItem *> *)jingjiChoiceItemArr
{
    if (_jingjiChoiceItemArr == nil) {
        _jingjiChoiceItemArr = [NSMutableArray new];
    }
    return _jingjiChoiceItemArr;
}
-(NSMutableArray<ChoiceItem *> *)yuleChoiceItemArr
{
    if (_yuleChoiceItemArr == nil) {
        _yuleChoiceItemArr = [NSMutableArray new];
    }
    return _yuleChoiceItemArr;
}
#pragma mark - 获取某个游戏的账号绑定列表,判断该游戏是否绑定过账号
- (void)getAccountBind
{
    GameItem * item = [KKDataTool shareTools].gameItem;
    [KKNetTool getBindAccountListWithGameid:item.gameId SuccessBlock:^(NSDictionary *dic) {
        NSArray * arr = (NSArray *)dic;
        if (arr.count) {
            self.bind = 1;
            self.gamerDic = arr.firstObject;
        } else {
            self.bind = 0;
        }
    } erreorBlock:^(NSError *error) {
        self.bind = -1;
    }];
}

#pragma mark - 获取游戏匹配选项
- (void)getChoiceItem
{
    [KKAlert showAnimateWithStauts:nil];
    GameItem * item = [KKDataTool shareTools].gameItem;
    //mId：2表示是匹配
    [KKNetTool getChoicesGamesWithGameid:item.gameId mId:@2 SuccessBlock:^(NSDictionary *dic) {
        KKBZChoicesRequestModel *model=[[KKBZChoicesRequestModel alloc] initWithJSONDict:dic];
        [self.sliderView resetWithData:model.gold];
        [KKAlert dismiss];
        NSArray * choices = dic[@"choices"];
        self.maxPick = dic[@"maxpick"];
        if (self.maxPick) {
            NSString * s1 = [NSString stringWithFormat:@"比赛内容请选择%@项，更快匹配到对手",self.maxPick];
            NSMutableAttributedString * str1 = [[NSMutableAttributedString alloc] initWithString:s1];
            [str1 addAttributes:@{NSForegroundColorAttributeName:kOrangeColor} range:[s1 rangeOfString:[NSString stringWithFormat:@"选择%@项",self.maxPick]]];
            self.tipsArr[1] = str1;
        }
        if (self.maxPick) {
            self.choiceNumberLabel.text = [NSString stringWithFormat:@"比赛内容%@选",self.maxPick];
        }
        
        NSMutableArray * items = [ChoiceItem mj_objectArrayWithKeyValuesArray:choices];
        for (ChoiceItem * item in items) {
            if (item.choicetype.integerValue == 2) {
                [self.jingjiChoiceItemArr addObject:item];
            } else {
                [self.yuleChoiceItemArr addObject:item];
            }
        }
        self.jingjiControl.userInteractionEnabled = self.jingjiChoiceItemArr.count>0;
        self.yuleControl.userInteractionEnabled = self.yuleChoiceItemArr.count > 0;
        [self clickTypeControl:self.jingjiControl];
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
    }];
}
#pragma mark - 点击选项choice
- (IBAction)clickTypeControl:(UIControl *)sender
{
    //如果点击的是已经选中的返回
    if (sender.selected) {
        return;
    }
    //点击了竞技模式
    if (sender.tag == 0) {
        self.jingjiControl.selected = YES;
        self.jingjiControl.layer.borderWidth = 1;
        self.jingjiControl.backgroundColor = [UIColor whiteColor];
        [self createBtnsWithTitleArr:self.jingjiChoiceItemArr];
        self.yuleControl.selected = NO;
        self.yuleControl.layer.borderWidth = 0;
        self.yuleControl.backgroundColor = [UIColor colorWithWhite:249/255.0 alpha:1];
    } else {
        self.yuleControl.selected = YES;
        self.yuleControl.layer.borderWidth = 1;
        self.yuleControl.backgroundColor = [UIColor whiteColor];
        [self createBtnsWithTitleArr:self.yuleChoiceItemArr];
        self.jingjiControl.layer.borderWidth = 0;
        self.jingjiControl.selected = NO;
        self.jingjiControl.backgroundColor = [UIColor colorWithWhite:249/255.0 alpha:1];
    }
    [self checkBtmbtn];
}
//检测底部按钮是否可用
- (void)checkBtmbtn
{
    //如果选项够数了则可以点击，否则不可以点击
    if (self.selBtnArr.count == self.maxPick.integerValue) {
        self.startBtn.backgroundColor = kThemeColor;
        [self.startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.startBtn.userInteractionEnabled = YES;
    } else {
        self.startBtn.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        [self.startBtn setTitleColor:kSubtitleColor forState:UIControlStateNormal];
        self.startBtn.userInteractionEnabled = NO;
    }
}
#pragma mark - 绑定账号之后，更新绑定信息
- (void)bindAccount{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateAccountBind];
    });
}
//更新账号信息
- (void)updateAccountBind
{
    GameItem * item = [KKDataTool shareTools].gameItem;
    [KKAlert showAnimateWithStauts:@"正在查询账号信息"];
    [KKNetTool getBindAccountListWithGameid:item.gameId SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSArray * arr = (NSArray *)dic;
        if (arr.count) {
            self.bind = 1;
            self.gamerDic = arr.firstObject;
            [self startPipei:nil];
        } else {
            self.bind = 0;
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
        self.bind = -1;
    }];
}
#pragma mark - 点击底部按钮，开始夺金挑战按钮
- (IBAction)startPipei:(id)sender {
    //没有绑定账号先绑定账号，如果没有请求成功则再次请求是否绑定接口
    if (self.bind == 0) {
        KKHintView * hintView = [KKHintView shareHintView];
        [hintView assignWithGameId:[KKDataTool shareTools].gameItem.gameId.integerValue];
        hintView.ensureBlock = ^{
            KKBindAccountViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"bindAccountVC"];
            __weak typeof(self) weakSelf = self;
            vc.bindBlock = ^{
                [weakSelf updateAccountBind];
            };
            vc.gameId = [KKDataTool shareTools].gameItem.gameId.integerValue;
            [self.navigationController pushViewController:vc animated:YES];
        };
        return;
    }
    if (self.bind == -1) {
        //请求账号信息失败，更新一下
        [self updateAccountBind];
        return;
    }
    if (self.jingjiControl.selected == NO && self.yuleControl.selected == NO) {
        [KKAlert showText:@"请选择比赛类型"];
        return;
    }
    //选择的匹配选项不够提示
    if (self.selBtnArr.count != self.maxPick.integerValue) {
        [KKAlert showText:[NSString stringWithFormat:@"请选择%@种游戏内容",self.maxPick]];
        return;
    }
    NSNumber * choicetype;
    NSArray * pickArr;
    if (self.jingjiControl.selected) {
        pickArr = self.jingjiChoiceItemArr;
        choicetype = @2;
    } else {
        choicetype = @1;
        pickArr = self.yuleChoiceItemArr;
    }
    //拼接游戏内容选项
    NSMutableString * pick = [NSMutableString new];
    for (KKSelectButton * btn in self.selBtnArr) {
        NSInteger tag = btn.tag;
        ChoiceItem * item = pickArr[tag];
        [pick appendString:[NSString stringWithFormat:@"%@,",item.code]];
    }
    [pick deleteCharactersInRange:NSMakeRange(pick.length - 1, 1)];
   //获取选择的金币范围
    NSInteger max = self.sliderView.currentMax;
    NSInteger min = self.sliderView.currentMin;
    //参数都正确开始匹配
    [self startMatchGameWithParm:@{@"gamerid":self.gamerDic[@"id"],@"choicetype":choicetype,@"pick":pick,@"gold":[NSString stringWithFormat:@"%ld,%ld",(long)min,(long)max]}];
}

#pragma mark - 开始匹配
- (void)startMatchGameWithParm:(NSDictionary *)parm
{
    __weak typeof(self) weakSelf = self;
    //先创建匹配控制器，如果发起匹配请求失败要移除（如果请求成功之后再添加，可能会出现漏掉通知的bug）
    KKMatchViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"matchVC"];
    [self addChildViewController:vc];
    vc.ensureBlock = ^(NSNumber * _Nonnull roomId) {
        [weakSelf getRoomInfoWithRoomId:roomId];
    };
    vc.view.frame = self.view.bounds;
    [KKNetTool startMatchWithPara:parm SuccessBlock:^(NSDictionary *dic) {
        [self.view addSubview:vc.view];
    } erreorBlock:^(NSError *error) {
        [vc removeFromParentViewController];
        if ([error isKindOfClass:[NSString class]]) {
            NSString * err = (NSString *)error;
            if ([err isEqualToString:@"金币余额不足"]){
                [self showZuanHintView];
            } else {
                [KKAlert showText:(NSString *)error toView:self.view];
            }
        }
    }];
}
//显示提示充值
- (void)showZuanHintView
{
    [KKAlert showAnimateWithText:nil toView:self.view];
    [KKNetTool getMyWalletSuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:self.view];
        NSNumber * diamond = dic[@"diamond"];
        NSNumber * gold = dic[@"gold"];
        NSInteger max = self.sliderView.currentMax;
        KKAlertViewStyleTwoBtmBtn * roomHintView = [KKAlertViewStyleTwoBtmBtn shareAlertViewStyleTwoBtmBtn];
        roomHintView.frame = self.view.bounds;
        [self.view addSubview:roomHintView];
        NSInteger goldLack = gold.integerValue + diamond.integerValue * 10 - max;
        if (goldLack > 0) {
            //钻石兑换之后足够
            roomHintView.titleLabel.text = @"";
            roomHintView.subtitleLabel.text = @"金币不足，需要将钻石换为金币,继续参加比赛";
            [roomHintView.rightBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
            roomHintView.clickRightBtnBlock = ^{
               [self gotoChongzhiWithType:NO lackCount:max - gold.integerValue];
            };
//            roomHintView.label1.text = @"金币不足，需要将钻石换为金币";
//            roomHintView.label2.text = @"继续参加比赛";
//            roomHintView.accountLabel.text = [NSString stringWithFormat:@"账户余额:%@",diamond];
//            [roomHintView.btmBtn setTitle:@"兑换金币" forState:UIControlStateNormal];
//            roomHintView.ensureBlock = ^{
//                [self gotoChongzhiWithType:NO lackCount:max - gold.integerValue];
//            };
        } else {
            roomHintView.titleLabel.text = @"";
            roomHintView.subtitleLabel.text = @"金币不足，将无法参赛,请先充值";
            [roomHintView.rightBtn setTitle:@"立即充值" forState:UIControlStateNormal];
            roomHintView.clickRightBtnBlock = ^{
                [self gotoChongzhiWithType:YES lackCount:0];
            };
//            roomHintView.label1.text = @"金币不足，将无法参赛";
//            roomHintView.label2.text = @"请先充值";
//            roomHintView.accountLabel.text = [NSString stringWithFormat:@"账户余额:%@",gold];
//            roomHintView.zuanIcon.image = [UIImage imageNamed:@"coin_big"];
//            roomHintView.ensureBlock = ^{
//                [self gotoChongzhiWithType:YES lackCount:0];
//            };
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:self.view];
        [KKAlert showText:@"获取账户余额出错" toView:self.view];
    }];
}
//是否是充值 ，如果是兑换需要传缺多少金币
- (void)gotoChongzhiWithType:(BOOL)chongzhi lackCount:(NSInteger)lackCount
{
    KKChongzhiViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"chongzhiVC"];
    vc.isChongzhi = chongzhi;
    vc.lackGold = lackCount;
    __weak typeof(self) weakSelf = self;
    vc.chongzhiBlock = ^{
        [weakSelf startPipei:nil];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 开始竞赛之后，获取房间信息 显示大房间
-(void)getRoomInfoWithRoomId:(NSNumber *)roomId
{
    [KKAlert showAnimateWithStauts:nil];
    [KKNetTool getMatchInfoWithMatchId:roomId SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        KKBigHouseViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"bighouseVC"];
        vc.roomDic = dic;
        KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:vc];
        [KKDataTool shareTools].window.rootViewController = nav;
        [[KKDataTool shareTools].window makeKeyAndVisible];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    } erreorBlock:^(NSError *error) {
         [KKAlert dismiss];
    }];
}

#pragma mark - 创建匹配选项
- (void)createBtnsWithTitleArr:(NSArray *)titleArr {
    [self.selBtnArr removeAllObjects];//清空所有选中的选项
    [self.choiceBtnView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//清除当前所有的选项按钮
    NSInteger count = titleArr.count;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (ScreenWidth - 60)/3;
    CGFloat h = 44;
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
        [self.choiceBtnView addSubview:btn];
    }
    self.choiceHeightCons.constant = y + h;
    [self.view layoutIfNeeded];
    NSInteger c = self.maxPick.integerValue;
    if (self.maxPick && count >= c) {
        for (NSInteger index = 0; index < c; index ++) {
            KKSelectButton * btn = self.choiceBtnView.subviews[index];
            [self clickSelectBtn:btn];
        }
    }
}
//点击选项按钮
- (void)clickSelectBtn:(KKSelectButton *)sender {
    if (sender.selected) {
        //如果已选中，则取消选中
        sender.selected = NO;
        [self.selBtnArr removeObject:sender];//(如果已选中则一定在选中数组中)
    } else {
        if (self.selBtnArr.count == self.maxPick.integerValue) {
            //如果已经达到了最多选项，再点击则取消第一个选中的
            KKSelectButton * btn = self.selBtnArr.firstObject;
            btn.selected = NO;
            [self.selBtnArr removeObject:btn];
        }
        sender.selected = YES;
        [self.selBtnArr addObject:sender];
    }
    //检测底部按钮是否可以点击
    [self checkBtmbtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10000;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tipsArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuse = @"scroll";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor colorWithWhite:153/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.attributedText = self.tipsArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
