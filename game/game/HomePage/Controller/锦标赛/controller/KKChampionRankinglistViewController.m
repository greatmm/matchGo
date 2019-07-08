//
//  KKChampionRankinglistViewController.m
//  game
//
//  Created by linsheng on 2019/1/11.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionRankinglistViewController.h"
#import "KKChampionMoneyRankTableViewCell.h"
#import "KKChampionTopModel.h"
#import "KKChampionRankinglistManager.h"
#import "KKChampionOtherResultViewController.h"
#import "KKChampionRankinglistHeadView.h"
@interface KKChampionRankinglistViewController()
@property (nonatomic, strong) KKChampionRankinglistHeadView *headerView;
@property (strong,nonatomic) NSNumber * gameId;//游戏类型

@property (nonatomic, strong) KKChampionRankinglistManager *dataManagrLocal;
@end
@implementation KKChampionRankinglistViewController
- (id)initWithType:(KKChampionshipsType)type cid:(NSNumber *)cid gameid:(NSNumber *)gameid
{
    if (self=[super init]) {
        _dataManagrLocal=[[KKChampionRankinglistManager alloc] initWithType:type cid:cid];
        self.dataManagerMain=_dataManagrLocal;
        _gameId=gameid;
    }
    return self;
}
- (void)viewDidLoad
{
    self.boolLogOutShow=true;
    [self initSuperInfoWithMJ];
    [self requestData];
    [super viewDidLoad];
     [self setTableviewContain];
}

#pragma mark set/get
-(UIView *)headerView
{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[KKChampionRankinglistHeadView alloc] init];
    [_headerView setType:((KKChampionRankinglistManager *)self.dataManagerMain).type];
    return _headerView;
}
#pragma mark  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataManagerMain.array_main.count>0) {
        return 44;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataManagerMain.array_main.count>0) {
        return self.headerView;
    }
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        KKChampionTopModel *model=self.dataManagerMain.array_main[indexPath.row];
        if (model.firstShow) {
            return 65+16;
        }
    }
    return 65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self]
    KKChampionTopModel *model=self.dataManagerMain.array_main[indexPath.row];
    if (model.canLook) {
        KKChampionOtherResultViewController *vc=[[KKChampionOtherResultViewController alloc] initWithCid:((KKChampionRankinglistManager *)self.dataManagerMain).cId gameId:_gameId model:model champion:_dataManagrLocal.modelChampions];
        [self.navigationController pushViewController:vc animated:true];
    }
}
@end
