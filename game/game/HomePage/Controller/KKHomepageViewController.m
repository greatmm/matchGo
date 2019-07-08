//
//  KKHomepageViewController.m
//  game
//
//  Created by GKK on 2018/8/13.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKHomepageViewController.h"
#import "KKHomeGameCollectionViewCell.h"
#import "KKSupeiCollectionViewCell.h"
#import "KKHomepageCollectionReusableView.h"
#import "SDCycleScrollView.h"
#import "KKSupeiDetailViewController.h"
#import "GameItem.h"
#import "BannerItem.h"
#import "KKWSTool.h"
#import "KKPartedViewController.h"
#import "KKBigHouseViewController.h"
#import "KKChampionshipViewController.h"
#import "KKHomePageControl.h"
#import "KKBigHouseViewController.h"
#import "KKWebViewController.h"
#import "KKChampionListViewController.h"
#import "KKChampionListModel.h"
#import "KKCreateRoomCollectionViewCell.h"
#import "KKPublishAgainstViewController.h"
#import "KKEnterPwdView.h"
@interface KKHomepageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *cv;//整个UI添加一个UICollectionView
@property (nonatomic,strong) SDCycleScrollView * bannerView;//轮播图
@property (nonatomic,strong) NSMutableArray * games;//四个游戏
@property (nonatomic,assign) BOOL isRefresh;//是否在刷新
@property (nonatomic,strong) NSArray * banners;//轮播图数组，包含其它数据比如参数
@property (nonatomic,strong) NSMutableArray * bannerImages;//轮播图图片url数组
@property (nonatomic,strong) NSArray * groups;//下边的分组
@property (strong,nonatomic) KKHomePageControl * pageControl;//显示的原点
@property (strong,nonatomic) NSMutableArray * championArr;//所有的锦标赛数据
@end

@implementation KKHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.houseBtm = [KKDataTool tabBarH];
    self.cv.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"大厅" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kTitleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kTitleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} forState: UIControlStateHighlighted];
    if (@available(iOS 11.0, *)) {
        self.cv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self registerCell];
    self.games = [NSMutableArray new];
    self.championArr = [NSMutableArray new];
    self.bannerImages = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    self.cv.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isRefresh) {
            return;
        }
        weakSelf.isRefresh = YES;
        if (weakSelf.games.count == 0) {
            [weakSelf getGames];
            [weakSelf getData];
            [weakSelf getLatestChampions];
        }  else {
            [weakSelf getData];
            [weakSelf getLatestChampions];
//            weakSelf.isRefresh = NO;
//            [weakSelf.cv.mj_header endRefreshing];
        }
    }];
    [self.cv.mj_header beginRefreshing];
    [self getStartRooms];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkChanged) name:KKNetworkUpdateNotification object:nil];
}
- (void)netWorkChanged
{
    [self.cv.mj_header beginRefreshing];
    [self getStartRooms];
}
- (void)registerCell
{
    [self.cv registerNib:[UINib nibWithNibName:@"KKCreateRoomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"createRoom"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (self.isRefresh == false) {
        [self getLatestChampions];
    }
}
#pragma mark - 获取轮播图和下边的组数据
- (void)reloadData
{
    [self.cv.mj_header beginRefreshing];
}
- (void)getData
{
    [KKNetTool getHomeDataSuccessBlock:^(NSDictionary *dic) {
        [self.cv.mj_header endRefreshing];
        self.isRefresh = NO;
        NSArray * slide = dic[@"slides"];
        self.groups = dic[@"groups"];
        self.banners = [BannerItem mj_objectArrayWithKeyValuesArray:slide];
        [self.bannerImages removeAllObjects];
        if (self->_pageControl) {
            [self->_pageControl removeFromSuperview];
            self->_pageControl = nil;
        }
        if (self->_bannerView) {
            [self->_bannerView removeFromSuperview];
            self->_bannerView = nil;
        }
        if (self.banners) {
            for (BannerItem * item in self.banners) {
                [self.bannerImages addObject:item.image];
            }
            self.bannerView.imageURLStringsGroup = self.bannerImages;
            if (self.banners.count > 1) {
                [self.bannerView addSubview:self.pageControl];
                self.pageControl.numberOfPages = self.banners.count;
                [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.bannerView).offset(-10);
                    make.bottom.mas_equalTo(self.bannerView).mas_offset(-10);
                }];
            }
        }
        [self.cv reloadData];
    } erreorBlock:^(NSError *error) {
        [self.cv.mj_header endRefreshing];
        self.isRefresh = NO;
    }];
}
#pragma mark - 获取锦标赛数据
- (void)getLatestChampions
{
    [KKNetTool getLatestChampionsSuccessBlock:^(NSDictionary *dic) {
        NSMutableArray * arr = [NSMutableArray new];
        NSArray * array = (NSArray *)dic;
        for (NSDictionary * dict in array) {
            KKChampionListModel * model = [[KKChampionListModel alloc] initWithJSONDict:dict];
            [arr addObject:model];
        }
        self.championArr = arr;
        [self.cv reloadData];
    } erreorBlock:^(NSError *error) {
        DLOG(@"%@",error);
    }];
}
#pragma mark - 获取游戏数据
- (void)getGames
{
    //游戏列表
    [KKNetTool getGamesSuccessBlock:^(NSDictionary *dic) {
        NSArray * arr = (NSArray *)dic;
        for (NSDictionary * dict in arr) {
            GameItem * item = [GameItem mj_objectWithKeyValues:dict];
            [self.games addObject:item];
        }
        [KKDataTool saveGamesWithArr:arr];
        [KKDataTool shareTools].gameItem = self.games.firstObject;
//        [self.cv reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]];
        [self.cv reloadData];
    } erreorBlock:^(NSError *error) {
    }];
}
#pragma mark - 获取正在进行中的房间
- (void)getStartRooms
{
    //登录之后才能获取数据，否则就不请求
    if ([KKDataTool token]) {
        [KKNetTool myStartRoomWithSuccessBlock:^(NSDictionary *dic) {
            NSArray * users = dic[@"users"];
            for (NSDictionary * dic in users) {
                NSNumber * uid = dic[@"uid"];
                KKUser * user = [KKDataTool user];
                if (uid && [uid isEqual:user.userId]) {
                    NSNumber * state = dic[@"state"];
                    if (state.integerValue == 11) {
                        return;
                    }
                    break;
                }
            }
            NSDictionary * champion = dic[@"champion"];
            if (champion) {
                [KKHouseTool enterChampionWihtChamDic:dic];
//                KKChampionshipViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"championship"];
//                vc.dataDic = dic;
//                vc.isSmall = YES;
//                KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:vc];
//                [KKDataTool shareTools].window.rootViewController = nav;
//                [[KKDataTool shareTools].window makeKeyAndVisible];
                return;
            }
            NSDictionary * match = dic[@"match"];
            if (match == nil) {
                match = dic[@"room"];
            }
            if (dic == nil || match == nil) {
                return;
            }
            dispatch_main_async_safe(^{
                NSNumber * matchType = match[@"matchtype"];
                KKBigHouseViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"bighouseVC"];
                vc.roomDic = dic;
                vc.gameType = matchType.integerValue;
                vc.isSmall = YES;
                KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:vc];
                [KKDataTool shareTools].window.rootViewController = nav;
                [[KKDataTool shareTools].window makeKeyAndVisible];
            })
        } erreorBlock:^(NSError *error) {
//            NSLog(@"%@",error);
        }];
    }
}
#pragma mark - 懒加载
-(SDCycleScrollView *)bannerView
{
    if (_bannerView == nil) {
        _bannerView = [SDCycleScrollView new];
        _bannerView.delegate = self;
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth - 32, (ScreenWidth - 32) * 153/343) delegate:self placeholderImage:nil];
        _bannerView.backgroundColor = kBackgroundColor;
        _bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _bannerView.currentPageDotColor = kThemeColor;
        _bannerView.pageDotColor = kSubtitleColor;
        _bannerView.layer.cornerRadius = 5;
        _bannerView.layer.masksToBounds = YES;
        _bannerView.placeholderImage = [UIImage imageNamed:@"defaultImage"];
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _bannerView.autoScrollTimeInterval = 5;
    }
    return _bannerView;
}
-(KKHomePageControl *)pageControl
{
    if (_pageControl) {
        return _pageControl;
    }
    _pageControl = [KKHomePageControl new];
    [_pageControl setValue:[UIImage imageNamed:@"dot_sel"] forKey:@"_currentPageImage"];
    [_pageControl setValue:[UIImage imageNamed:@"dot_white"] forKey:@"_pageImage"];
    return _pageControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - collectionView 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.groups) {
        return 3 + self.groups.count;
    }
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.groups && section > 2) {
        NSDictionary * dic = self.groups[section - 3];
        NSArray * items = dic[@"items"];
        if (items) {
            return items.count;
        }
        return 0;
    }
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString * reuse = @"banner";
            UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
            [cell.contentView addSubview:self.bannerView];
            return cell;
        }
        case 1:
        {
            static NSString * reuse = @"homeGame";
            KKHomeGameCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
            if (self.championArr.count) {
                [cell addShadowWithFrame:cell.bounds shadowOpacity:0.05 shadowColor:nil shadowOffset:CGSizeMake(0, 3)];
            } else {
                [cell removeShadow];
            }
//            cell.dataArr = self.games;
            cell.dataArr = self.championArr;
            return cell;
        }
        case 2:{
            KKCreateRoomCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"createRoom" forIndexPath:indexPath];
            __weak typeof(self) weakSelf = self;
            cell.createRoomBlock = ^{
                NSArray * games = [KKDataTool games];
                if (games == nil || games.count == 0) {
                    [KKAlert showText:@"暂无游戏可选"];
                    return ;
                }
                //创建房间
                [weakSelf publishRoom];
            };
            cell.joinRoomBlock = ^{
                //加入密码房
                [weakSelf showPwdView];
            };
            return cell;
        }
        default:
        {
            static NSString * reuse = @"supei";
            KKSupeiCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
            NSArray * arr = self.groups[indexPath.section - 3][@"items"];
            [cell assignWithDic:arr[indexPath.row]];
            return cell;
        }
    }
}
#pragma mark - 跳至发布创建房间控制器
- (void)publishRoom
{
    KKPublishAgainstViewController * vc = [[UIStoryboard storyboardWithName:@"KKParted" bundle:nil] instantiateViewControllerWithIdentifier:@"publishAgainstVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 弹出密码输入框,输入密码
- (void)showPwdView
{
    kkLoginMacro
    KKEnterPwdView * pwdView = [KKEnterPwdView shareView];
    pwdView.frame = [UIScreen mainScreen].bounds;
    pwdView.cancelBlock = ^{
        [[KKDataTool shareTools] destroyAlertWindow];
    };
    pwdView.ensureBlock = ^(NSString * pwdStr){
        dispatch_main_async_safe(^{
            [KKHouseTool enterPwdroomWithPwd:pwdStr];
        })
        [[KKDataTool shareTools] destroyAlertWindow];
    };
    [KKDataTool shareTools].alertWindow.backgroundColor = [UIColor clearColor];
    [[KKDataTool shareTools].alertWindow addSubview:pwdView];
    [[KKDataTool shareTools].alertWindow makeKeyAndVisible];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        return nil;
    }
    if (indexPath.section == 0) {
        return nil;
    }
    if (indexPath.section == 1 && self.championArr.count == 0) {
        return nil;
    }
    static NSString * reuse = @"cvHeader";
    KKHomepageCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuse forIndexPath:indexPath];
    switch (indexPath.section) {
        case 1:
        {
            header.textLabel.text = @"锦标赛";
            header.moreControl.hidden = NO;
            __weak typeof(self) weakSelf = self;
            header.clickMoreBlock = ^{
                [weakSelf moreChampions];
            };
        }
            break;
        case 2:
        {
            header.textLabel.text = @"对战";
            header.moreControl.hidden = YES;
            header.clickMoreBlock = nil;
        }
            break;
        default:
        {
            NSDictionary * dict = self.groups[indexPath.section - 3][@"main"];
            header.textLabel.text = dict[@"title"];
            header.moreControl.hidden = NO;
            NSDictionary * parm = dict[@"params"];
            __weak typeof(self) weakSelf = self;
            header.clickMoreBlock = ^{
                [weakSelf moreGamesWith:parm];
            };
        }
            break;
    }
    return header;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(ScreenWidth - 32, (ScreenWidth - 32) * 153/343);
        case 1:{
            if (self.championArr.count == 0) {
                return CGSizeMake(ScreenWidth - 32, 1);
            }
            return CGSizeMake(ScreenWidth - 32, 71 + ((ScreenWidth - 32)/2 - 10) * 153/343.0);
//            return CGSizeMake(ScreenWidth - 32, 77);
        }
        case 2:{
            return CGSizeMake(ScreenWidth, 104);
        }
        default:
        {
            CGFloat width = (ScreenWidth - 48)/2;
            CGFloat height = width * 330/498 + 44;
            return CGSizeMake(width, height);
        }
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
    if (section == 1) {
        return UIEdgeInsetsMake(0, 16, 0, 16);
    }
    return UIEdgeInsetsMake(0, 16, 20, 16);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeZero;
    }
    if (section == 1 && self.championArr.count == 0) {
        return CGSizeMake(ScreenWidth, 0);
    }
    return  CGSizeMake(ScreenWidth, 60);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 3) {
        return;
    }
    NSArray * arr = self.groups[indexPath.section - 3][@"items"];
    NSDictionary * dict = arr[indexPath.row];
    [self moreGamesWith:dict];
}
#pragma mark - 跳至筛选页
- (void)moreGamesWith:(NSDictionary *)dict
{
    KKPartedViewController * partedVC = [[UIStoryboard storyboardWithName:@"KKParted" bundle:nil] instantiateViewControllerWithIdentifier:@"partedVC"];
    NSArray * games = [KKDataTool games];
    partedVC.paraDic = dict[@"params"];
    NSNumber * game = dict[@"game"];
    GameItem * item = games.firstObject;
    if (game.integerValue < 5 && game.integerValue > 0) {
        item = [KKDataTool itemWithGameId:game.integerValue];
    }
    [KKDataTool shareTools].gameItem = item;
    [self.navigationController pushViewController:partedVC animated:YES];
}
#pragma mark - 更新pagecontrol的下标
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    _pageControl.currentPage = index;
}
#pragma mark - 跳转至锦标赛更多
- (void)moreChampions
{
    KKChampionListViewController * vc = [KKChampionListViewController new];
    vc.championArr = self.championArr;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 点击轮播图
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerItem * item = self.banners[index];
    NSNumber * type = item.link_type;//1 url，2自建房筛选， 3锦标赛
//    //LinkTypeURL 类型URL
//    LinkTypeURL LinkType = 1
//    //LinkTypeMatches 类型比赛列表
//    LinkTypeMatches LinkType = 2
//    //LinkTypeActivityMatches 类型活动比赛列表
//    LinkTypeActivityMatches LinkType = 3
//    //LinkTypeChampion 类型锦标赛
//    LinkTypeChampion LinkType = 4
    if (type) {
        NSInteger t = type.integerValue;
        NSDictionary * para = item.params;
        if (t == 1) {
            KKWebViewController * webVc = [KKWebViewController new];
            [self.navigationController pushViewController:webVc animated:YES];
            [webVc loadUrl:para[@"url"]];
        } else if (t == 2) {
            KKPartedViewController * partedVC = [[UIStoryboard storyboardWithName:@"KKParted" bundle:nil] instantiateViewControllerWithIdentifier:@"partedVC"];
            NSArray * games = [KKDataTool games];
            partedVC.paraDic = para;
            NSNumber * game = item.game;
            GameItem * item = games.firstObject;
            if (game.integerValue < 5 && game.integerValue > 0) {
                item = [KKDataTool itemWithGameId:game.integerValue];
            }
            [KKDataTool shareTools].gameItem = item;
            [self.navigationController pushViewController:partedVC animated:YES];
        } else if (t == 4) {

            NSNumber * cId =para[@"championid"];

            [KKHouseTool enterChampionWihtCid:cId];
        }
    }
}
@end
