//
//  KKPartedHomeViewController.m
//  game
//
//  Created by GKK on 2018/10/11.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKPartedHomeViewController.h"
#import "KKPartedViewController.h"
#import "KKBigHouseViewController.h"
#import "BannerItem.h"
#import "KKPartedHomeCollectionViewCell.h"
#import "KKPublishAgainstViewController.h"
#import "SDCycleScrollView.h"
#import "KKCreateRoomCollectionViewCell.h"
#import "KKEnterPwdView.h"
#import "KKHomePageControl.h"
#import "KKWebViewController.h"
#import "KKChampionshipDetailNewViewController.h"

@interface KKPartedHomeViewController ()<UICollectionViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cv;//整个是个collectionView
@property (nonatomic,strong) SDCycleScrollView * bannerView;//轮播图
@property (nonatomic,strong) NSArray * banners;//轮播数据
@property (nonatomic,strong) NSMutableArray * bannerImages;//轮播图url数组
@property (nonatomic,strong) NSArray * groups;//下边的为你推荐数据
@property (strong,nonatomic) KKHomePageControl * pageControl;//显示的原点
@property (assign,nonatomic) BOOL isRefresh;//是否在刷新
@end

static NSString * const iden = @"partedHomeCVCell";
@implementation KKPartedHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.houseBtm = [KKDataTool tabBarH];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"对战" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kTitleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kTitleColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:20]} forState: UIControlStateHighlighted];
    [self assignUi];
    __weak typeof(self) weakSelf = self;
    self.cv.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isRefresh) {
            return;
        }
        weakSelf.isRefresh = YES;
        [weakSelf getData];
    }];
    [self.cv.mj_header beginRefreshing];
}
#pragma mark - 懒加载属性
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
-(NSMutableArray *)bannerImages
{
    if (_bannerImages) {
        return _bannerImages;
    }
    _bannerImages = [NSMutableArray new];
    return _bannerImages;
}
#pragma mark - 跳至发布创建房间控制器
- (void)publishRoom
{
    KKPublishAgainstViewController * vc = [[UIStoryboard storyboardWithName:@"KKParted" bundle:nil] instantiateViewControllerWithIdentifier:@"publishAgainstVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 请求接口，获取数据
- (void)getData
{
    [KKNetTool getMatchDatasuccessBlock:^(NSDictionary *dic) {
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
#pragma mark - 初始化操作，注册cell
- (void)assignUi
{
    [self.cv registerNib:[UINib nibWithNibName:@"KKPartedHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:iden];
    [self.cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"banner"];
    [self.cv registerNib:[UINib nibWithNibName:@"KKCreateRoomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"createRoom"];
    [self.cv registerNib:[UINib nibWithNibName:@"KKAagCVHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cvHeader"];
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
#pragma mark - collectionView代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.groups) {
        return 3;
    }
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section != 2) {
        return 1;
    }
    if (self.groups) {
        return self.groups.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * reuse = @"banner";
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
        [cell.contentView addSubview:self.bannerView];
        return cell;
    }
    if (indexPath.section == 1) {
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
    KKPartedHomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    cell.tag = indexPath.row;
    [cell assignWithDic:self.groups[indexPath.row]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(ScreenWidth - 32, (ScreenWidth - 32) * 153/343 + 20);
    }
    if (indexPath.section == 1) {
        return CGSizeMake(ScreenWidth, 104);
    }
    return CGSizeMake(ScreenWidth, 116);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return CGSizeMake(ScreenWidth, 50);
    }
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 2) {
        return nil;
    }
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cvHeader" forIndexPath:indexPath];
        return header;
    }
    return nil;
}
#pragma mark - 更新pagecontrol的下标
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    _pageControl.currentPage = index;
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
            NSNumber * cId = para[@"championid"];
            //当前存在的房间控制器，如果已存在小房间，则直接打开
            UIViewController * wv = [[KKDataTool shareTools] wVc];
            if ([wv isKindOfClass:[KKChampionshipDetailNewViewController class]]) {
                KKChampionshipDetailNewViewController * championVC = (KKChampionshipDetailNewViewController *)wv;
                if ([championVC.cId isEqual:cId]) {
                    [championVC openRoom];
                    return;
                }
            }
            UIViewController * swv = [[KKDataTool shareTools] showWVc];
            if ([swv isKindOfClass:[KKChampionshipDetailNewViewController class]]) {
                KKChampionshipDetailNewViewController * championVC = (KKChampionshipDetailNewViewController *)swv;
                if ([championVC.cId isEqual:cId]) {
                    [championVC openRoom];
                    return;
                }
            }
            [KKNetTool getChampionInfoWithCid:cId successBlock:^(NSDictionary *dic) {
                KKChampionshipDetailNewViewController * vc = [KKChampionshipDetailNewViewController new];//[[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"championship"];
                vc.dataDic = dic;
                vc.matchId = dic[@"id"];
//                NSLog(@"锦标赛数据:%@",dic);
                KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:vc];
                if (wv != nil) {
                    vc.secondWindow = YES;
                }
                if (vc.secondWindow) {
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
            } erreorBlock:^(NSError *error) {
//                NSLog(@"失败%@",error);
            }];
        }
    }
}
@end
