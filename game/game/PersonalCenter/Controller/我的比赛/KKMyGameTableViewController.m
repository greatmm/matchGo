//
//  KKMyGameTableViewController.m
//  game
//
//  Created by GKK on 2018/8/21.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKMyGameTableViewController.h"
#import "KKMyGameTableViewCell.h"
#import "KKNavigationController.h"
#import "KKRoomItem.h"
#import "KKChampionshipViewController.h"
#import "KKBigHouseViewController.h"
#import "KKChampionSummaryModel.h"
#import "KKChampionshipDetailNewViewController.h"
@interface KKMyGameTableViewController ()
@property (nonatomic,strong) NSMutableArray * roomArr;
@property (nonatomic,assign) BOOL isFooterRefresh;
@property (nonatomic,assign) BOOL isHeaderRefresh;
@property (strong,nonatomic) UIView * noGameView;//没有比赛的提示view
@end

@implementation KKMyGameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的竞赛";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToPersonalCenter)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.roomArr = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isHeaderRefresh) {
            return;
        }
        weakSelf.isHeaderRefresh = YES;
        [weakSelf getRoomList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isFooterRefresh) {
            return;
        }
        weakSelf.isFooterRefresh = YES;
        [weakSelf getRoomList];
    }];
    [self getRoomList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGames) name:@"myGameChanged" object:nil];;
}
-(UIView *)noGameView
{
    if (_noGameView) {
        return _noGameView;
    }
    _noGameView = [UIView new];
    _noGameView.frame = CGRectMake(0, 0, ScreenWidth, 300);
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noTop"]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [_noGameView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_noGameView).offset(10);
        make.centerX.mas_equalTo(self->_noGameView);
        make.height.with.mas_equalTo(100);
    }];
    UILabel * l = [UILabel new];
    l.text = @"暂无比赛记录";
    l.textColor = kTitleColor;
    l.font = [UIFont systemFontOfSize:14];
    [_noGameView addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(imgView);
    }];
    return _noGameView;
}
- (void)updateGames
{
    [self.tableView.mj_header beginRefreshing];
}
//确保返回的是个人中心，匹配也可能跳到游戏列表
- (void)backToPersonalCenter
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.tabBarController setSelectedIndex:3];
}
//获取所有的比赛列表
- (void)getRoomList
{
    NSNumber * offset = [NSNumber numberWithInteger:self.roomArr.count];
    if (self.isHeaderRefresh) {
        offset = @0;
    }
    NSDictionary * para = @{@"offset":offset,@"limit":@30};
    if (self.isChampion) {
        [KKNetTool getMyChampionRoomsWithPara:para SuccessBlock:^(NSDictionary *dic) {
            if (self.isHeaderRefresh) {
                [self.roomArr removeAllObjects];
            }
//            NSLog(@"锦标赛数据%@",dic);
            [self dealChampionData:dic];
            [self endRefresh];
        } erreorBlock:^(NSError *error) {
            [self endRefresh];
        }];
    } else {
        [KKNetTool getMyRoomsWithPara:para SuccessBlock:^(NSDictionary *dic) {
            if (self.isHeaderRefresh) {
                [self.roomArr removeAllObjects];
            }
            NSArray * rooms = dic[@"rooms"];
//            for (NSDictionary * dic in rooms) {
//                NSLog(@"rooms:%@",dic);
//            }
            [self.roomArr addObjectsFromArray:[KKRoomItem mj_objectArrayWithKeyValuesArray:rooms]];
            NSArray * arr = dic[@"matches"];
            NSArray * items = [KKRoomItem mj_objectArrayWithKeyValuesArray:arr];
//            for (NSDictionary * dic in arr) {
//                NSLog(@"matches:%@",dic);
//            }
            [self.roomArr addObjectsFromArray:items];
            [self.tableView reloadData];
            [self endRefresh];
        } erreorBlock:^(NSError *error) {
            [self endRefresh];
        }];
    }
}
//把锦标赛数据处理一下
- (void)dealChampionData:(NSDictionary *)dataDic
{
    NSArray * champions = dataDic[@"champions"];
    NSMutableArray * cArr = [NSMutableArray new];
    for (NSDictionary * dict in champions) {
        KKMyChampionModel * model = [[KKMyChampionModel alloc] initWithJSONDict:dict];
        [cArr addObject:model];
    }
    NSMutableArray * sArr = [NSMutableArray new];
    NSArray * summaries = dataDic[@"summaries"];
    for (NSDictionary * dict in summaries) {
        KKChampionSummaryModel * model = [[KKChampionSummaryModel alloc] initWithJSONDict:dict];
        [sArr addObject:model];
    }
    for (KKChampionSummaryModel * model in sArr) {
        for (KKMyChampionModel * cModel in cArr) {
            if ([model.championid isEqual:cModel.cid]) {
                model.championModel = cModel;
                break;
            }
        }
    }
    [self.roomArr addObjectsFromArray:sArr];
    [self.tableView reloadData];
}
//结束刷新
- (void)endRefresh
{
    self.isHeaderRefresh = NO;
    self.isFooterRefresh = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.roomArr.count > 0) {
        return self.roomArr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.roomArr.count == 0) {
        static NSString * reuse = @"noRecord";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
            [cell.contentView addSubview:self.noGameView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    static NSString * reuse = @"myGame";
    KKMyGameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    //锦标赛与其它比赛数据略有不同，所以写了两个赋值方法
    if (self.isChampion) {
        KKChampionSummaryModel * model = self.roomArr[indexPath.row];
        [cell assignWithModel:model];
    } else {
        KKRoomItem * item = self.roomArr[indexPath.row];
        [cell assignWithItem:item];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.roomArr.count == 0) {
        return 300;
    }
    return 116;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.roomArr.count == 0) {
        return;
    }
    //锦标赛与其它比赛点击效果不同
    if (self.isChampion) {
        KKChampionSummaryModel * model = self.roomArr[indexPath.row];
        KKMyChampionModel * cModel = model.championModel;
        NSNumber * status = cModel.status;
        if (status.integerValue == 2) {
            //进行中，进入锦标赛
            NSNumber * cid = cModel.cid;
            [self gotoChampionWithCid:cid];
            return;
        }
        KKChampionshipDetailNewViewController * vc = [KKChampionshipDetailNewViewController new];
        vc.cId = cModel.cid;
        vc.gameId = cModel.game;
        vc.boolSelectResult=true;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    //自建房或者匹配赛
    KKRoomItem * item = self.roomArr[indexPath.row];
    KKMyGameTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger type = cell.type;
    //出结果的比赛
    if (!(type == 5 || type == 6 || type == 14)) {
            [KKHouseTool enterRoomWithRoomid:item.roomId popToRootVC:NO];
    } else {
        //没出结果的比赛，获取比赛信息,如果是数字则说明已开始，是对战
        [KKHouseTool enterRoomWithRoomid:item.roomId popToRootVC:NO];
    }
}
//点击进行中的锦标赛进入锦标赛
- (void)gotoChampionWithCid:(NSNumber *)cId
{
    if (cId == nil) {
        return;
    }
    [KKHouseTool enterChampionWihtCid:cId];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
