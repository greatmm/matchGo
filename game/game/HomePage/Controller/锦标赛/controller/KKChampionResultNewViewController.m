//
//  KKChampionResultNewViewController.m
//  game
//
//  Created by linsheng on 2018/12/18.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKChampionResultNewViewController.h"
#import "SwipeTableView.h"
#import "UIView+STFrame.h"
#import "KKChampionMoneyRankTableViewCell.h"
#import "KKChampionMyResultTableViewCell.h"
#import "LGPhotoPickerBrowserViewController.h"
#import "HNUBZScrollManager.h"
#import "KKChampionResultHeadView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKChampionModel.h"
#import "KKExplainViewController.h"

@interface KKChampionResultNewViewController ()<SwipeTableViewDataSource,SwipeTableViewDelegate,UITableViewDelegate,UITableViewDataSource,LGPhotoPickerBrowserViewControllerDelegate,LGPhotoPickerBrowserViewControllerDataSource,HNUBZChoiceViewDelegate>
@property (nonatomic, strong) UIImageView * headerImageView;
@property (strong,nonatomic) UITableView * leftTableView;
@property (strong,nonatomic) UITableView * rightTableView;
@property (strong,nonatomic) UIView * line;
@property (assign,nonatomic) NSInteger currentIndex;//当前在哪儿，我的战绩还是获奖排行
@property (strong,nonatomic) UIButton * leftBtn;
@property (strong,nonatomic) UIButton * rightBtn;
//@property (strong,nonatomic) UIButton * explainBtn;//说明按钮
@property (strong,nonatomic) UIButton * backBtn;//返回按钮
@property (strong,nonatomic) UIButton * segBackBtn;//中部返回按钮
@property (strong,nonatomic) UIView * headerView;//排名，玩家，胜利次数，获得红包
@property (strong,nonatomic) NSArray * topArr;//获奖排行
@property (strong,nonatomic) NSDictionary * mineDic;//自己是否在排行榜内
@property (assign,nonatomic) NSInteger rank;//自己排第几
@property (strong,nonatomic) NSMutableArray * myResultArr;//我的战绩数组
@property (assign,nonatomic) BOOL isHeaderRefresh;
@property (assign,nonatomic) BOOL isFooterRefresh;
@property (strong,nonatomic) NSArray * showImgArr;
@property (strong,nonatomic) HNUBZScrollManager *scrollManagerMain;
@property (strong,nonatomic) KKChampionResultHeadView *headView;

@end

@implementation KKChampionResultNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.myResultArr = [NSMutableArray new];
    self.scrollManagerMain;
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.segBackBtn];
    [self getChampionTops];
    [self.leftTableView.mj_header beginRefreshing];
}
#pragma mark set/get
- (KKChampionResultHeadView *)headView
{
    if (!_headView) {
        _headView=[[KKChampionResultHeadView alloc] initWithDelegate:self];
        _headView.moreView=self.headerView;
//        [_headView.selectView addSubview:self.explainBtn];
//        [_headView.arrayTouchControl addObject:self.explainBtn];
//        [self.explainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self->_headView.selectView);
//            make.right.mas_equalTo(self->_headView);
//        }];
    }
    return _headView;
}
- (HNUBZScrollManager *)scrollManagerMain
{
    if (!_scrollManagerMain) {
        
        _scrollManagerMain=[[HNUBZScrollManager alloc] initWithViewController:@[[[HNUBZBasicView alloc] initWithFrame:self.view.bounds scroll:self.leftTableView],[[HNUBZBasicView alloc] initWithFrame:self.view.bounds scroll:self.rightTableView]] headView:self.headView mainView:self.view];
    }
    return _scrollManagerMain;
}
#pragma mark - 获奖排行
- (void)getChampionTops
{
    [KKNetTool getChampionTopUsersWithCid:self.cId SuccessBlock:^(NSDictionary *dic) {
//        NSLog(@"排行榜--%@",dic);
        self.topArr = dic[@"top"];
        KKChampionModel *model=[[KKChampionModel alloc] initWithJSONDict:dic[@"champion"]];
        if (self.topArr) {
            self.headerView.height = 44;
            NSInteger count = self.topArr.count;
            for (int i = 0; i < count; i ++) {
                NSDictionary * dic = self.topArr[i];
                NSNumber * uid = dic[@"uid"];
                NSNumber * userId = [KKDataTool user].userId;
                if (uid.integerValue == userId.integerValue) {
                    self.mineDic = dic;
                    self.rank = i + 1;
                    break;
                }
            }
        }
        if (model.images) {
            [self.headView.imageVMain sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        }
        [self.rightTableView reloadData];
    } erreorBlock:^(NSError *error) {
        if ([error isKindOfClass:[NSString class]]) {
            [KKAlert showText:(NSString *)error toView:self.view];
        }
    }];
}
-(UIView *)headerView
{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 00, kScreenWidth, 0)];
    _headerView.hidden=true;
    _headerView.backgroundColor = [UIColor whiteColor];
    UILabel * l = [UILabel new];
    l.text = @"排名";
    l.font = [UIFont systemFontOfSize:12];
    l.textColor = kTitleColor;
    [_headerView addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_headerView);
        make.left.mas_equalTo(self->_headerView).offset(15);
    }];
    UILabel * l1 = [UILabel new];
    l1.text = @"玩家";
    l1.font = [UIFont systemFontOfSize:12];
    l1.textColor = kTitleColor;
    [_headerView addSubview:l1];
    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_headerView);
        make.left.mas_equalTo(self->_headerView).offset(85);
    }];
    UILabel * l2 = [UILabel new];
    l2.text = @"胜利次数";
    l2.font = [UIFont systemFontOfSize:12];
    l2.textColor = kTitleColor;
    [_headerView addSubview:l2];
    [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_headerView);
        make.left.mas_equalTo(self->_headerView).offset(ScreenWidth * 0.5 + 25);
    }];
    UILabel * l3 = [UILabel new];
    l3.text = @"获得金币";
    l3.font = [UIFont systemFontOfSize:12];
    l3.textColor = kTitleColor;
    [_headerView addSubview:l3];
    [l3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->_headerView);
        make.right.mas_equalTo(self->_headerView).offset(-15);
    }];
    return _headerView;
}
//- (UIButton *)explainBtn
//{
//    if (_explainBtn) {
//        return _explainBtn;
//    }
//    _explainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_explainBtn setImage:[UIImage imageNamed:@"gameRule"] forState:UIControlStateNormal];
//    [_explainBtn addTarget:self action:@selector(clickExpainBtn) forControlEvents:UIControlEventTouchUpInside];
//    return _explainBtn;
//}
- (void)clickExpainBtn
{
    KKExplainViewController * explainVc = [KKExplainViewController new];
    explainVc.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"championExplain.png" ofType:nil]];
    [self.navigationController pushViewController:explainVc animated:YES];
    explainVc.navigationItem.title = @"怎么玩锦标赛";
}
- (UIButton *)backBtn
{
    if (_backBtn) {
        return _backBtn;
    }
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, [KKDataTool statusBarH], 44, 44);
    [_backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(clickBackbtn) forControlEvents:UIControlEventTouchUpInside];
    return _backBtn;
}
- (UIButton *)segBackBtn
{
    if (!_segBackBtn) {
        _segBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_segBackBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _segBackBtn.frame = CGRectMake(0, [KKDataTool statusBarH], 44, 44);
        [_segBackBtn addTarget:self action:@selector(clickBackbtn) forControlEvents:UIControlEventTouchUpInside];
        self.segBackBtn.hidden = YES;
    }
    return _segBackBtn;

}
- (void)clickBackbtn
{
    [self.navigationController popViewControllerAnimated:YES];
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



#pragma mark -
-(UITableView *)leftTableView
{
    if (_leftTableView) {
        return _leftTableView;
    }
    _leftTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _leftTableView.backgroundColor = [UIColor whiteColor];
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_leftTableView registerNib:[UINib nibWithNibName:@"KKChampionMyResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"myChampionResult"];
    __weak typeof(self) weakSelf = self;
    _leftTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isHeaderRefresh) {
            return;
        }
        weakSelf.isHeaderRefresh = YES;
        [weakSelf getMyGames];
    }];
    _leftTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isFooterRefresh) {
            return;
        }
        weakSelf.isFooterRefresh = YES;
        [weakSelf getMyGames];
    }];
    return _leftTableView;
}
#pragma mark - 我的战绩
- (void)getMyGames
{
    NSNumber * offset = [NSNumber numberWithInteger:self.myResultArr.count];
    if (self.isHeaderRefresh) {
        offset = @0;
    }
    NSDictionary * para = @{@"offset":offset,@"limit":@30};
    [KKNetTool getMyChampionRoomsWithCid:self.cId Para:para SuccessBlock:^(NSDictionary *dic) {
//        NSLog(@"我的战绩--%@",dic);
//        for (NSString * key in dic.allKeys) {
//            NSLog(@"%@==%@",key,dic[key]);
//        }
        if (self.isHeaderRefresh) {
            [self.myResultArr removeAllObjects];
        }
        NSArray * arr = dic[@"matches"];
        [self.myResultArr addObjectsFromArray:arr];
        [self.leftTableView reloadData];
        [self checkEndArray:arr];
        [self endRefresh];
    } erreorBlock:^(NSError *error) {
        [self endRefresh];
    }];
}
- (void)checkEndArray:(NSArray *)array
{
    if (self.isFooterRefresh&&array.count<=0) {
        [self.leftTableView.mj_footer endRefreshingWithNoMoreData];
    }
    else [self.leftTableView.mj_footer endRefreshing];
}
- (void)endRefresh
{
    self.isHeaderRefresh = NO;
    self.isFooterRefresh = NO;
    [self.leftTableView.mj_header endRefreshing];
//    [self.leftTableView.mj_footer endRefreshing];
}
-(UITableView *)rightTableView
{
    if (_rightTableView) {
        return _rightTableView;
    }
    _rightTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
//    _rightTableView.tableHeaderView=self.headerView;
    [_rightTableView registerNib:[UINib nibWithNibName:@"KKChampionMoneyRankTableViewCell" bundle:nil] forCellReuseIdentifier:@"championMoneyRankCell"];
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return _rightTableView;
}
- (void)showImageBrowse
{
    LGPhotoPickerBrowserViewController *BroswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
    BroswerVC.delegate = self;
    BroswerVC.dataSource = self;
    BroswerVC.showType = LGShowImageTypeImageURL;
    [self presentViewController:BroswerVC animated:YES completion:nil];
}
/**
 *  每个组多少个图片
 */
- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section
{
    return self.showImgArr.count;
}
///**
// *  每个对应的IndexPath展示什么内容
// */
- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath
{
    LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
    photo.photoURL = [NSURL URLWithString:self.showImgArr[indexPath.row]];
    return photo;
}
#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _rightTableView) {
        if (self.mineDic) {
            return self.topArr.count + 1;
        }
        return self.topArr.count;
    }
    return self.myResultArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _rightTableView) {
        KKChampionMoneyRankTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"championMoneyRankCell" forIndexPath:indexPath];
        if (self.mineDic) {
            if (indexPath.row == 0) {
                cell.rank = self.rank;
                [cell setShowLines:true];
                [cell assignWithDic:self.mineDic];
            } else {
                cell.rank = indexPath.row ;
                [cell setShowLines:false];
                [cell assignWithDic:self.topArr[indexPath.row - 1]];
            }
        } else {
               cell.rank = indexPath.row+1;
               [cell setShowLines:false];
               [cell assignWithDic:self.topArr[indexPath.row]];
            
        }
        return cell;
    }
    KKChampionMyResultTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myChampionResult" forIndexPath:indexPath];
    NSDictionary * dic = self.myResultArr[indexPath.row];
    cell.gameId = self.gameId.integerValue;
    [cell assignWithDic:dic];
    return cell;
}

#pragma mark  UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _rightTableView) {
        if (indexPath.row == 0) {
            return 65+16;
        }
        return 65;
    }
    return 74;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        NSDictionary * dic = self.myResultArr[indexPath.row];
        if (self.gameId.integerValue != 1) {
            NSString * images = dic[@"images"];
            if (images && images.length) {
                self.showImgArr = [images componentsSeparatedByString:@","];
                [self showImageBrowse];
            }
//            else {
//                [KKAlert showText:@"暂无结果图片" toView:self.view];
//            }
        }
    }
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (tableView==_rightTableView) {
//        return self.headerView;
//    }
//    return [UIView new];
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (tableView==_rightTableView) {
//         return self.headerView.height;
//    }
//    return 0;
//}
#pragma mark scrollview
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentY = scrollView.contentOffset.y;
//    NSLog(@"%f",contentY);
    if (contentY > -kNavigationAllHeight-kNavStatusBarHeight-((_headView.selectView.index==1)?_headerView.height:0)) {
        self.backBtn.hidden = YES;
        self.segBackBtn.hidden = NO;
    } else {
        self.backBtn.hidden = NO;
        self.segBackBtn.hidden = YES;
    }
}
#pragma mark HNUBZChoiceViewDelegate
- (void)bzChoiceTouchView:(HNUBZChoiceView *)choiceView title:(NSString *)title
{
//    _scrollManagerMain
    if ([title isEqualToString:@"back"]) {
        [self clickBackbtn];
    }
    if ([title isEqualToString:@"expain"]) {
        [self clickExpainBtn];
    }
    
}
#pragma mark HNUSelectViewDelegate
-(void)hnuSelectViewDidselectIndex:(NSUInteger)index
{
    if (_headerView.height>0) {
        [_headView uploadInfo];
        if (index==1) {
            if (_rightTableView.contentInset.top!=_headView.height) {
                float a=_headView.height-_rightTableView.contentInset.top;
                _rightTableView.contentInset=UIEdgeInsetsMake(_headView.height, _rightTableView.contentInset.left, _rightTableView.contentInset.bottom, _rightTableView.contentInset.right);
//                [_rightTableView scrollsToTop];
                if (a>0) {
                    _rightTableView.contentOffset=CGPointMake(0, _rightTableView.contentOffset.y-a);
                }
                
            }
        }
    }
    
    [_scrollManagerMain touchAtIndex:index];
}
@end
