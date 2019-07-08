//
//  KKNotiMessageListViewController.m
//  game
//
//  Created by GKK on 2018/10/25.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKNotiMessageListViewController.h"
#import "KKNotiMessageTableViewCell.h"
#import "NotiMessageItem.h"
#import "KKNotiMessageFetchModel.h"

@interface KKNotiMessageListViewController ()
@property (nonatomic,strong) NSMutableArray * messageArr;
@property (assign,nonatomic) BOOL isHeaderRefresh;
@property (assign,nonatomic) BOOL isFooterRefresh;
@end
static NSString * const reuse = @"notiMessageCell";
@implementation KKNotiMessageListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 120;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.messageArr = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"KKNotiMessageTableViewCell" bundle:nil] forCellReuseIdentifier:reuse];
    __weak typeof(self) weakSelf = self;;
   self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isHeaderRefresh) {
            return;
        }
        weakSelf.isHeaderRefresh = YES;
        [weakSelf getMessageList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.isFooterRefresh) {
            return;
        }
        weakSelf.isFooterRefresh = YES;
        [weakSelf getMessageList];
    }];
    [self.tableView.mj_header beginRefreshing];
}
-(void)getMessageList
{
    NSNumber * offset;
    if (self.isHeaderRefresh) {
        offset = @0;
    } else {
       offset = [NSNumber numberWithInteger:self.messageArr.count];
    }
    NSDictionary * parm = @{@"limit":@30,@"offset":offset};
    KKNotiMessageFetchModel * model = [KKNotiMessageFetchModel new];
    model.requestParams = parm;
    [model fetchWithPath:[NSString stringWithFormat:@"%@account/messages",baseUrl] type:MTKFetchModelTypeGET completionWithData:^(BOOL isSucceeded, NSString * _Nonnull msg, NSError * _Nullable error, id  _Nullable responseObjectData) {
        if (isSucceeded) {
            if (self.isHeaderRefresh) {
                [self.messageArr removeAllObjects];
            }
            NSArray * notiArr = (NSArray *)responseObjectData;
            for (NSDictionary * dict in notiArr) {
                NotiMessageItem * item = [[NotiMessageItem alloc]initWithJSONDict:dict];
                [self.messageArr addObject:item];
            }
            [self checkEndArray:notiArr];
            [self endRefresh];
            [self.tableView reloadData];
        } else {
            [KKAlert showText:msg toView:self.view];
        }
    }];
    /*
     {
     content = "\U6b64\U5c40\U6d41\U5c40\Uff0c190\U91d1\U5e01\U5df2\U9000\U56de\U5230\U8d26\U6237\U91cc";
     data =             {
     matchid = 10069;
     };
     icon = "https://static1.ogame.app/cover/result/flow.png";
     id = 95;
     isread = 0;
     sendtime = 1545237268;
     title = "\U8bc4\U52062\U4eba\U8d5b\U6311\U6218\U6d41\U5c40";
     }
     */
}
- (void)checkEndArray:(NSArray *)array
{
    if (self.isFooterRefresh&&array.count<=0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else [self.tableView.mj_footer endRefreshing];
}
- (void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
//    [self.tableView.mj_footer endRefreshing];
    self.isHeaderRefresh = NO;
    self.isFooterRefresh = NO;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKNotiMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    NotiMessageItem * item = self.messageArr[indexPath.row];
    [cell assignWithItem:item];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotiMessageItem * item = self.messageArr[indexPath.row];
    NSNumber * matchid = item.data[@"matchid"];
    if (matchid) {
        [KKHouseTool enterRoomWithRoomid:matchid popToRootVC:false];
    }
}
@end
