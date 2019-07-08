//
//  KKManagerRolesTableViewController.m
//  game
//
//  Created by GKK on 2018/8/29.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKManagerRolesTableViewController.h"
#import "KKManageRoleTableViewCell.h"
#import "KKBindAccountViewController.h"
#import "KKAccountModel.h"
@interface KKManagerRolesTableViewController ()
@property (nonatomic,strong) NSMutableDictionary * listDic;//四个游戏的总数据
@property (strong,nonatomic) NSMutableArray * dataArr;//四个游戏绑定的总数据
@end

@implementation KKManagerRolesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"角色管理";
    self.listDic = [NSMutableDictionary new];
    self.dataArr = [NSMutableArray new];
    [self getGameAccountList];//获取所有绑定过的账号
}
//获取所有的游戏账号
- (void)getGameAccountList
{
    [KKAlert showText:nil toView:self.view];
    MTKFetchModel * model = [[MTKFetchModel alloc] init];
    [model fetchWithPath:[NSString stringWithFormat:@"%@game/bind",baseUrl] type:MTKFetchModelTypeGET completionWithData:^(BOOL isSucceeded, NSString * _Nonnull msg, NSError * _Nullable error, id  _Nullable responseObjectData) {
        [KKAlert dismissWithView:self.view];
        if (isSucceeded) {
            NSArray * arr = (NSArray *)responseObjectData;
            if ([arr isKindOfClass:[NSArray class]]) {
                [self.dataArr removeAllObjects];
                for (NSDictionary * dic in arr) {
                    KKAccountModel * model = [[KKAccountModel alloc] initWithJSONDict:dic];
                    [self.dataArr addObject:model];
                }
            }
            [self.tableView reloadData];
        } else {
            [KKAlert showText:msg toView:self.view];
        }
    }];
    
//    [KKNetTool getBindAccountListSuccessBlock:^(NSDictionary *dic) {
//        [KKAlert dismiss];
//        NSArray * arr = (NSArray *)dic;
//        NSDictionary * dict = arr.firstObject;
//        [dict createPropertyCode];
//        for (NSDictionary * d in arr) {
//            NSNumber * gameId = d[@"gameid"];
//            self.listDic[gameId.stringValue] = d;
//        }
//        [self.tableView reloadData];
//    } erreorBlock:^(NSError *error) {
//        [KKAlert dismiss];
//    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
//    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuse = @"manageCell";
    KKManageRoleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    NSArray * gameIds = @[@2,@3,@4,@1];
    NSNumber * gameId = gameIds[indexPath.row];
    cell.gameIcon.image = [KKDataTool gameIconWithGameId:gameId.integerValue];
    KKAccountModel * item;
    for (KKAccountModel * model in self.dataArr) {
        if ([model.gameid isEqual:gameId]) {
            item = model;
            break;
        }
    }
    if (item) {
        [cell assignWithItem:item];
    } else {
        NSArray * titleArr = @[@"王者荣耀",@"刺激战场",@"英雄联盟",@"绝地求生"];
        cell.gameLabel.text = titleArr[indexPath.row];
    }
    __weak typeof(self)weakSelf = self;
    
    cell.clickRightBtnBlock = ^{
        //绑定或修改账号
        KKBindAccountViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"bindAccountVC"];
        vc.gameId = gameId.integerValue;
        vc.item = item;
        vc.bindBlock = ^{
            [weakSelf getGameAccountList];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
