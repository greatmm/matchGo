//
//  KKBaseViewController.m
//  EasyToWork
//
//  Created by GKK on 2017/11/30.
//  Copyright © 2017年 MM. All rights reserved.
//

#import "KKBaseViewController.h"

@interface KKBaseViewController ()

@end

@implementation KKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.houseBtm = isIphoneX?34:0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)dealloc
{
    KKLog(@"--%@--dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if ([[KKDataTool shareTools] wVc] || [[KKDataTool shareTools] showWVc]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"btmHeightChanged" object:nil userInfo:@{@"btmH":[NSNumber numberWithFloat:_houseBtm]}];
//    }
}

#pragma mark get/set;
- (void)setTableviewContain
{
    hnuSetWeakSelf;
    [self.tableViewMain mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.left.right.equalTo(weakSelf.view);
         make.bottom.equalTo(weakSelf.view).offset(-kIPhonexSaleButtomHeight);
     }];

}
- (void)setBoolLogOutShow:(BOOL)boolLogOutShow
{
    _boolLogOutShow=boolLogOutShow;
    if (_boolLogOutShow) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:KKLoginNotification object:nil];
    }
}
- (UITableView *)tableViewMain
{
    if (!_tableViewMain) {
        //self.view.bounds
        _tableViewMain = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-kIPhonexSaleButtomHeight) style:UITableViewStylePlain];
        _tableViewMain.delegate = self;
        _tableViewMain.dataSource = _dataManagerMain;
        _tableViewMain.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableViewMain];

    }
    return _tableViewMain;
}
- (KKRemindDefaultView *)viewLogoutShow
{
    if (!_viewLogoutShow) {
        _viewLogoutShow=[[KKRemindDefaultView alloc] init];
        hnuSetWeakSelf;
        _viewLogoutShow.remindDefaultViewButtonBlock = ^(NSString *title)
        {
            if (![KKDataTool token]) {
                kkLoginMacro;
            }
            else [weakSelf requestData];
        };
        [_viewLogoutShow resetToNeedLoginView];
        _viewLogoutShow.hidden=true;
        
        [self.view addSubview:_viewLogoutShow];
        [_viewLogoutShow mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.left.bottom.right.equalTo(weakSelf.view);
         }];
    }
    return _viewLogoutShow;
}
#pragma mark Method
- (void)initSuperInfoWithMJ
{
    [self initSuperInfoWithMJ:true];
}
- (void)initSuperInfoWithMJ:(BOOL)mj
{
    hnuSetWeakSelf;
    _dataManagerMain.blockCompletion = ^(BOOL isSucceeded, NSString *msg,NSError * error,BOOL end)
    {
        [weakSelf reloadDataWithEnd:end];
    };
   
    if (mj) {
        self.tableViewMain.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestData];
        }];
        if (_dataManagerMain.int_pageNumber>0) {
            _tableViewMain.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [weakSelf requestMoreData];
            }];
        }
    }
   
}
- (void)requestData
{
    
    if (_boolLogOutShow) {
        if (![KKDataTool token]) {
            self.viewLogoutShow.hidden=false;
            return;
        }
        if (_viewLogoutShow) {
            _viewLogoutShow.hidden=true;
        }
    }
    [KKAlert showAnimateWithText:@"加载中" toView:self.view];
    self.dataManagerMain.boolFristReloadData=true;
    [_dataManagerMain startLoadWithDictionary:nil];
}
- (void)requestMoreData
{
    [_dataManagerMain startLoadWithDictionary:nil];
}
- (void)reloadDataWithEnd:(BOOL)end
{
    [KKAlert dismissWithView:self.view];
    [self.tableViewMain reloadData];
    [self.tableViewMain.mj_header endRefreshing];
    if (_dataManagerMain.int_pageNumber>0) {
        if (end) {
            [self.tableViewMain.mj_footer endRefreshingWithNoMoreData];
        }
        else [self.tableViewMain.mj_footer endRefreshing];
    }
}
@end
