//
//  KKPartedViewController.m
//  game
//
//  Created by GKK on 2018/8/23.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKPartedViewController.h"
#import "KKAgainstTableViewCell.h"
#import "KKSelAgainstTableViewCell.h"
#import "KKPopcontrol.h"
#import "KKRemoveView.h"
#import "KKBigHouseViewController.h"
#import "KKChoiceView.h"

@interface KKPartedViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *roomTableView;//比赛列表
@property (nonatomic,strong) UITableView * selTableView;//选择游戏下拉选项
@property (nonatomic,strong) NSMutableArray * dataArr;//所有的房间数据
@property (strong,nonatomic) NSArray * matchArr;//比赛数组，房间不足8个请求比赛
@property (nonatomic,strong) UILabel * titleLabel;//标题
@property (nonatomic,strong) UIImageView * gameIcon;//游戏图标
@property (nonatomic,strong) UIImageView * titleArrow;//游戏右边箭头
@property (nonatomic,strong) NSArray * selArr;//弹出的选项数组
@property (weak, nonatomic) IBOutlet KKPopcontrol *control1;//空位优先
@property (weak, nonatomic) IBOutlet KKPopcontrol *control2;//金币升降序
@property (weak, nonatomic) IBOutlet KKPopcontrol *control3;//筛选
@property (nonatomic,strong) KKPopcontrol * preControl;//当前选中的control
@property (nonatomic,strong) KKRemoveView * backView;//选择框的背景视图
@property (nonatomic,strong) UIControl * titleView;//点击选择游戏
@property (nonatomic,assign) NSInteger gameIndex;//选中的game下标
@property (nonatomic,assign) NSInteger priceType;//金币升序降序 -1表示没有选，0表示降序，1表示升序
@property (nonatomic,strong) NSString * para;//请求的参数
@property (nonatomic,assign) BOOL isRefresh;//是否正在下拉刷新
@property (strong,nonatomic) KKChoiceView * choiceView;//筛选页面
@property (strong,nonatomic) NSMutableArray * choices;//选中的游戏选项
@property (assign,nonatomic) NSInteger slots;//
@property (assign,nonatomic) BOOL isFooterRefresh;//是否在上拉加载
@property (strong,nonatomic) NSMutableDictionary * choiceDic;//以游戏id为key存储获取到的选项数据
@property (assign,nonatomic) BOOL isJingji;//当前选择的选项是否是竞技选项
@property (strong,nonatomic) NSArray * numselectArr;//人数数组
@property (assign,nonatomic) NSInteger gameId;
@end
//根据拼接的参数字符串判断的是否需要刷新，所以要注意参数拼接顺序，@"game=%@&matchtype=0&slots=%@&choices=%@&offset=0&limit=30"

@implementation KKPartedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.choices = @[].mutableCopy;
    _gameIndex = -1;
    _priceType = -1;
    self.gameId = 2;
    self.dataArr = [NSMutableArray new];
    //设置顶部游戏选择control
    self.titleView = [UIControl new];
    self.titleView.frame = CGRectMake(ScreenWidth * 0.5 - 60, 0, 120, 44);
    [self.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.titleView);
    }];
    [self.titleView addSubview:self.gameIcon];
    [self.gameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.width.height.mas_equalTo(18);
        make.right.mas_equalTo(self.titleLabel.mas_left).offset(-6);
    }];
    [self.titleView addSubview:self.titleArrow];
    [self.titleArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(3);
    }];
    [self.navigationController.navigationBar addSubview:self.titleView];
    [self.titleView addTarget:self action:@selector(selGameItem:) forControlEvents:UIControlEventTouchUpInside];
    //给选项卡赋值
    [self assignControl];
    //如果传过来的有参数，则拼接参数
    if (self.paraDic) {
        NSArray * choices = self.paraDic[@"choices"];
        if (choices) {
            [self.choices addObjectsFromArray:choices];
        }
        NSNumber * slots = self.paraDic[@"slots"];
        if (slots) {
            self.slots = slots.integerValue;
        }
        if (self.paraDic[@"game"]) {
            NSNumber * game = self.paraDic[@"game"];
            self.gameId = game.integerValue;
        } else {
            self.gameId = 2;
        }
        self.para = [NSString stringWithFormat:@"game=%ld&matchtype=0&slots=%ld&%@&offset=0&limit=30",self.gameId,(long)self.slots,[self getChoiceStr]];
    } else {
        self.gameId = 2;
        self.para = [NSString stringWithFormat:@"game=%ld&matchtype=0&slots=0&%@&offset=0&limit=30",(long)self.gameId,[self getChoiceStr]];
    }
    //根据当前游戏给UI赋值
//    GameItem * item = [KKDataTool shareTools].gameItem;
//    NSInteger gameId = item.gameId.integerValue;
    if (self.gameId == 1) {
        self.gameIndex = 3;
        self.titleLabel.text = @"绝地求生";
        self.gameIcon.image = [UIImage imageNamed:@"Chiji_Icon"];
    } else if (_gameId == 2) {
        self.gameIndex = 0;
        self.titleLabel.text = @"王者荣耀";
        self.gameIcon.image = [UIImage imageNamed:@"GK_Icon"];
    } else if(_gameId == 3){
        self.gameIndex = 1;
        self.titleLabel.text = @"刺激战场";
        self.gameIcon.image = [UIImage imageNamed:@"Qiusheng_Icon"];
    } else {
        self.gameIndex = 2;
        self.titleLabel.text = @"英雄联盟";
        self.gameIcon.image = [UIImage imageNamed:@"LOL_Icon"];
    }
    //添加房间列表刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRoomList) name:kRoomListChanged object:nil];
    __weak typeof(self) weakSelf = self;
    self.roomTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isRefresh) {
            return;
        }
        weakSelf.isRefresh = YES;
        [weakSelf refreshPara];
    }];
    self.roomTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isFooterRefresh) {
            return;
        }
        weakSelf.isFooterRefresh = YES;
        [weakSelf refreshPara];
    }];
    self.choiceDic = [NSMutableDictionary new];
}
#pragma mark - 拼接choice参数，把choice数组转换成字符串
- (NSString *)getChoiceStr
{
    NSMutableString * choice;
    if (self.choices.count) {
        choice = [NSMutableString new];
        for (NSNumber * number in self.choices) {
            [choice appendString:[NSString stringWithFormat:@"%@,",number]];
        }
        [choice deleteCharactersInRange:NSMakeRange(choice.length - 1, 1)];
        return [NSString stringWithFormat:@"choices=%@",choice];
    } else {
        return @"choicetype=0";
    }
}
#pragma mark - 点击顶部游戏选择
- (void)selGameItem:(UIControl *)sender
{
    //如果打开就关闭，如果关闭就打开
    if (_selTableView) {
        [self removeSelTable];
    } else {
        [self showSelTable];
    }
}
#pragma mark - 获取选项数据
-(void)getChoiceData
{
    //如果已经请求过了，则直接对数据处理
    NSDictionary * dict = self.choiceDic[[NSNumber numberWithInteger:self.gameId]];
    if (dict) {
        [self showChoiceViewWithDic:dict];
        return;
    }
    //没请求过，则请求数据，成功之后再对数据处理，这里请求的都是自建房的选项，所以mId写死@1
    [KKAlert showAnimateWithStauts:nil];
    [KKNetTool getChoicesGamesWithGameid:[NSNumber numberWithInteger:self.gameId] mId:@1 SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismiss];
        NSArray * choices = dic[@"choices"];
        self.numselectArr = dic[@"numselect"];
        NSMutableArray * items = [ChoiceItem mj_objectArrayWithKeyValuesArray:choices];
        [self dealChoiceItemArr:items];
    } erreorBlock:^(NSError *error) {
        [KKAlert dismiss];
    }];
}
#pragma mark - 把选项分为娱乐和竞技
- (void)dealChoiceItemArr:(NSArray *)arr
{
    NSMutableArray * jingjiArr = [NSMutableArray new];
    NSMutableArray * yuleArr = [NSMutableArray new];
    for (ChoiceItem * item in arr) {
        if (item.choicetype.integerValue == 1) {
            [yuleArr addObject:item];
        } else {
            [jingjiArr addObject:item];
        }
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (jingjiArr.count) {
        dict[@"jingji"] = jingjiArr;
    }
    if (yuleArr.count) {
        dict[@"yule"] = yuleArr;
    }
    self.choiceDic[[NSNumber numberWithInteger:self.gameId]] = dict;
    [self showChoiceViewWithDic:dict];
}
#pragma mark - 显示筛选页
- (void)showChoiceViewWithDic:(NSDictionary *)dict
{
    self.choiceView.frame = [UIScreen mainScreen].bounds;
//    self.choiceView.mj_x = ScreenWidth;
    __weak typeof(self) weakSelf = self;
    self.choiceView.clickEnsureBtnBlock = ^(NSInteger slots, BOOL isJingji, NSMutableArray * _Nonnull choiceNumberArr) {
        weakSelf.slots = slots;
        weakSelf.choices = choiceNumberArr;
        [weakSelf.roomTableView.mj_header beginRefreshing];
    };
    NSNumber * choice = self.choices.firstObject;
    NSArray * yuleArr = dict[@"yule"];
    if (yuleArr && yuleArr.count) {
        if (choice) {
            for (ChoiceItem * item in yuleArr) {
                if (item.code.integerValue == choice.integerValue) {
                    self.choiceView.isJingji = NO;
                    break;
                }
            }
        }
    } else {
        self.choiceView.isJingji = YES;
    }
    self.choiceView.yuleChoiceArr = dict[@"yule"];
    self.choiceView.jingjiChoiceArr = dict[@"jingji"];
//    self.choiceView.selChoiceNumberArr = self.choices;
    NSMutableArray * arr = @[@0].mutableCopy;
    [arr addObjectsFromArray:self.numselectArr];
    self.choiceView.peopleCountArr = arr;
    self.choiceView.selPeopleIndex = [arr indexOfObject:[NSNumber numberWithInteger:self.slots]];
    [self.choiceView relaodData];
    [[UIApplication sharedApplication].delegate.window addSubview:self.choiceView];
    [self.choiceView show];
//    self.choiceView.backgroundColor = [UIColor whiteColor];
//    [UIView animateWithDuration:0.25 animations:^{
//        self.choiceView.mj_x = 0;
//    } completion:^(BOOL finished) {
//        self.choiceView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    }];
//    if ([[KKDataTool shareTools] wVc] || [[KKDataTool shareTools] showWVc]) {
//        CGFloat houseBtm = isIphoneX?(34+59):(59);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"btmHeightChanged" object:nil userInfo:@{@"btmH":[NSNumber numberWithFloat:houseBtm]}];
//    }
    
}
#pragma mark - 根据选中的游戏下标返回游戏id
//-(NSInteger)gameId
//{
//    return <#expression#>
//    if (self.gameIndex < 0 || self.gameIndex > 3) {
//        return 0;
//    }
//    if (self.gameIndex == 3) {
//        return 1;
//    }
//    return self.gameIndex + 2;
//}
#pragma mark - 懒加载
-(KKChoiceView *)choiceView
{
    if (_choiceView == nil) {
        _choiceView = [KKChoiceView shareChoiceView];
    }
    return _choiceView;
}
-(NSArray *)selArr
{
    if (_selArr) {
        return _selArr;
    }
    _selArr = @[@"王者荣耀",@"刺激战场",@"英雄联盟",@"绝地求生"];
    return _selArr;
}
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = kTitleColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.text = @"对战";
    }
    return _titleLabel;
}
-(UIImageView *)gameIcon
{
    if (_gameIcon == nil) {
        _gameIcon = [UIImageView new];
        _gameIcon.image = [UIImage imageNamed:@"GK_Icon"];
        _gameIcon.userInteractionEnabled = YES;
    }
    return _gameIcon;
}
-(UIImageView *)titleArrow
{
    if (_titleArrow == nil) {
        _titleArrow = [UIImageView new];
        _titleArrow.image = [UIImage imageNamed:@"arrowDown_blue"];
        [_titleArrow setHighlightedImage:[UIImage imageNamed:@"arrowUp_blue"]];
        _titleArrow.userInteractionEnabled = YES;
    }
    return _titleArrow;
}

- (UITableView *)selTableView
{
    if (_selTableView == nil) {
        _selTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _selTableView.delegate = self;
        _selTableView.dataSource = self;
        _selTableView.showsVerticalScrollIndicator = NO;
        _selTableView.backgroundColor = [UIColor whiteColor];
        _selTableView.bounces = NO;
    }
    return _selTableView;
}
- (KKRemoveView *)backView
{
    if (_backView == nil) {
        _backView = [KKRemoveView new];
        _backView.backgroundColor = [UIColor colorWithRed:20/255.0 green:25/255.0 blue:30/255.0 alpha:0.75];
        [self.view addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(-1 * [KKDataTool navBarH]);
        }];
        [_backView addSubview:self.selTableView];
        [self.selTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self->_backView);
            make.height.mas_equalTo(0);
        }];
        __weak typeof(self) weakSelf = self;
        _backView.removeBlock = ^{
            [weakSelf removeSelTable];
        };
    }
    return _backView;
}
#pragma mark - 刷新房间列表
-(void)refreshRoomList
{
    [self.roomTableView.mj_header beginRefreshing];
}

#pragma mark - setter方法改变UI，改变游戏和价格排序
-(void)setGameIndex:(NSInteger)gameIndex
{
    if (_gameIndex != gameIndex) {
        _gameIndex = gameIndex;
        [self clearData];
        [self resetUi];
    }
    [self.roomTableView.mj_header beginRefreshing];
}
-(void)setPriceType:(NSInteger)priceType
{
    if (_priceType == priceType) {
        return;
    }
    _priceType = priceType;
    //金币排序有变化，需要刷新接口
    NSArray * imgNames = @[@"priceNormal",@"priceDown",@"priceUp"];
    self.control2.arrowImageName = imgNames[_priceType + 1];
}
#pragma mark - 根据参数获取房屋列表数据
- (void)getRoomsWithPara:(NSString *)para
{
    [KKNetTool getAllRoomsWithPara:para successBlock:^(NSDictionary *dic) {
        NSArray * arr = (NSArray *)dic;
        if (self.isRefresh) {
            [self.dataArr removeAllObjects];
        }
        [self stopRefresh];
        [self.dataArr addObjectsFromArray:arr];
        if (self.dataArr.count < 8) {
            [KKNetTool getAllMatchesWithPara:para successBlock:^(NSDictionary *dic) {
                NSArray * arr = (NSArray *)dic;
                self.matchArr = arr;
                [self.roomTableView reloadData];
            } erreorBlock:^(NSError *error) {
            }];
        } else {
            self.dataArr = nil;
        }
        [self.roomTableView reloadData];
    } erreorBlock:^(NSError *error) {
        [self stopRefresh];
    }];
}
#pragma mark - 解决titleView的子试图跳转之后还在或者没有的问题
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.titleView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.titleView removeFromSuperview];
    if (_selTableView) {
        [self removeSelTable];
    }
}

#pragma mark - 点击顶部三个选项卡
- (IBAction)clickControl:(KKPopcontrol *)sender {
    switch (sender.tag) {
        case 0:
        {
            if (sender.selected) {
                return;
            }
            //空位优先
            sender.selected = YES;
            self.control2.selected = NO;
            if (self.priceType == -1) {
                return;
            }
            //取消金币排序,刷新接口
            self.priceType = -1;
            [self.roomTableView.mj_header beginRefreshing];
        }
            break;
        case 1:
        {
            if (sender.selected) {
                //升序降序切换
                self.priceType = 1 - self.priceType;
            } else {
                //选择金币排序，清除空位优先排序
                sender.selected = YES;
                self.priceType = 0;
                self.control1.selected = NO;
            }
            [self.roomTableView.mj_header beginRefreshing];
        }
            break;
        case 2:
        {
            [self getChoiceData];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 刷新参数
- (void)refreshPara
{
    NSString * game = [NSString stringWithFormat:@"%ld",(long)self.gameId];
    NSString * slot = [NSString stringWithFormat:@"%ld",(long)self.slots];
    NSInteger offset = self.dataArr.count;
    if (self.isRefresh) {
        offset = 0;
    }
    NSString * p = [NSString stringWithFormat:@"game=%@&matchtype=0&slots=%@&%@&offset=%ld&limit=30",game,slot,[self getChoiceStr],(long)offset];
    NSString * order;
    if (self.priceType == 0) {
        order = @"2";
    } else if(self.priceType == 1){
        order = @"1";
    }
    if (order) {
        p = [NSString stringWithFormat:@"%@&ord=%@",p,order];
    }
//    if ([self.para isEqualToString:p]) {
//        [self stopRefresh];
//        return;
//    }
    self.para = p;
}
#pragma mark - 停止刷新
-(void)stopRefresh
{
    [self.roomTableView.mj_header endRefreshing];
    [self.roomTableView.mj_footer endRefreshing];
    self.isFooterRefresh = NO;
    self.isRefresh = NO;
}
#pragma mark - 设置参数，刷新房间数据
-(void)setPara:(NSString *)para
{
    if (_para == para) {
        return;
    }
    _para = para;
    [self getRoomsWithPara:_para];
//    NSLog(@"参数：%@",_para);
}
#pragma mark - 显示游戏选择下拉框
- (void)showSelTable
{
    CGFloat toTop = 0;
    self.titleArrow.highlighted = YES;
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.superview).offset(toTop);
    }];
    [self.selTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44 * self.selArr.count);
    }];
    [self.selTableView reloadData];
}
#pragma mark - 移除游戏选择下拉框
- (void)removeSelTable
{
    [self.selTableView removeFromSuperview];
    _selTableView = nil;
    [self.backView removeFromSuperview];
    _backView = nil;
    self.titleArrow.highlighted = NO;
}

#pragma mark - 给选项卡赋值
-(void)assignControl
{
    self.control1.titleLabel.text = @"空位优先";
    self.control2.titleLabel.text = @"金币";
    self.control2.showArrow = YES;
    self.control2.arrowImageView.image = [UIImage imageNamed:@"priceNormal"];
    self.control3.titleLabel.text = @"筛选";
    self.control3.showArrow = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _selTableView) {
        return self.selArr.count;
    }
    if (self.matchArr) {
        return self.dataArr.count + self.matchArr.count;
    }
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _selTableView) {
        return 44;
    }
    return 115;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _selTableView) {
        static NSString * const iden = @"reuse";
        KKSelAgainstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[KKSelAgainstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
            cell.textLabel.textColor = kTitleColor;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageView.image = [UIImage imageNamed:@"PUBGSmall"];
            cell.imageView.mj_size = CGSizeMake(28, 28);
        }
        cell.textLabel.text = self.selArr[indexPath.row];
        NSArray * imgArr = @[@"WZRYSmall",@"CJZCSmall",@"LOLSmall",@"PUBGSmall"];
        cell.imageView.image = [UIImage imageNamed:imgArr[indexPath.row]];
        cell.showRightView = indexPath.row == self.gameIndex;
        return cell;
    }
    static NSString * const reuse = @"againstCell";
    KKAgainstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    NSDictionary * dic;
    if (indexPath.row < self.dataArr.count) {
        dic = self.dataArr[indexPath.row];
    } else {
        dic = self.matchArr[indexPath.row - self.dataArr.count];
    }
    [cell assignWithDic:dic];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _selTableView) {
            self.gameIndex = indexPath.row;
        switch (indexPath.row) {
            case 0:
                self.gameId = 2;
                break;
            case 1:
                self.gameId = 3;
                break;
            case 2:
                self.gameId = 4;
                break;
           case 3:
                self.gameId = 1;
                break;
            default:
                break;
        }
            NSArray * imgArr = @[@"WZRYSmall",@"CJZCSmall",@"LOLSmall",@"PUBGSmall"];
            self.gameIcon.image = [UIImage imageNamed:imgArr[indexPath.row]];
            self.titleLabel.text = self.selArr[indexPath.row];
            [self removeSelTable];
    } else {
        if (indexPath.row >= self.dataArr.count) {
            //已经开始的比赛直接返回
            return;
        }
        kkLoginMacro
        NSDictionary * dic = self.dataArr[indexPath.row];
        //当前存在的房间控制器，如果已存在小房间，则直接打开
        UIViewController * wv = [[KKDataTool shareTools] wVc];
        if ([wv isKindOfClass:[KKBigHouseViewController class]]) {
            KKBigHouseViewController * bigH = (KKBigHouseViewController *)wv;
            if ([bigH.matchId isEqual:dic[@"id"]]) {
                [bigH openRoom];
                return;
            }
        }
//        [KKNetTool getRoomInfoWithRoomId:dic[@"id"] SuccessBlock:^(NSDictionary *dic) {
//            DLOG(@"%@",dic);
//        } erreorBlock:^(NSError *error) {
//        }];
        
        UIViewController * swv = [[KKDataTool shareTools] showWVc];
        if ([swv isKindOfClass:[KKBigHouseViewController class]]) {
            KKBigHouseViewController * bigH = (KKBigHouseViewController *)swv;
            if ([bigH.matchId isEqual:dic[@"id"]]) {
                [bigH openRoom];
                return;
            }
        }
        KKBigHouseViewController * infoVC = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"bighouseVC"];
        infoVC.matchId = dic[@"id"];
        KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:infoVC];
        if (wv != nil) {
            infoVC.secondWindow = YES;
        }
        if (infoVC.secondWindow) {
            [KKDataTool shareTools].showWindow.rootViewController = nav;
            [KKDataTool shareTools].showWindow.hidden = NO;
            [[KKDataTool shareTools].showWindow makeKeyAndVisible];
            [KKDataTool shareTools].window.hidden = NO;
            [[KKDataTool shareTools] setShowWindowHeight:NO];
        } else {
            [KKDataTool shareTools].window.rootViewController = nav;
            [KKDataTool shareTools].window.hidden = NO;
            [[KKDataTool shareTools].window makeKeyAndVisible];
            [KKDataTool shareTools].showWindow.hidden = NO;
            [[KKDataTool shareTools] setShowWindowHeight:YES];
        }
//        //进入房间之后，回到根控制器
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popToRootViewControllerAnimated:NO];
//        });
    }
}
#pragma mark - 切换了游戏，更新UI清理缓存数据
- (void)clearData
{
    self.priceType = -1;
    self.slots = 0;
    [self.choices removeAllObjects];
    self.matchArr = nil;
    
}
#pragma mark - 清空选择，重设UI
- (void)resetUi
{
    //selected只用来改变文字颜色
    self.control1.selected = NO;
    self.control2.selected = NO;
    self.control3.selected = NO;
    self.control3.arrowImageName = @"arrowDown_gray";
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
