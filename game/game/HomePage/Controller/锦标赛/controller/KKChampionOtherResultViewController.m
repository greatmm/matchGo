//
//  KKChampionOtherResultViewController.m
//  game
//
//  Created by linsheng on 2019/1/15.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionOtherResultViewController.h"
#import "KKChampionOtherResultManager.h"
#import "KKChampionRankinglistHeadView.h"
@interface KKChampionOtherResultViewController ()
@property (nonatomic, strong) KKChampionRankinglistHeadView *headerView;
@end

@implementation KKChampionOtherResultViewController
- (id)initWithCid:(NSNumber *)cid gameId:(NSNumber *)gameId model:(KKChampionTopModel *)model champion:(nonnull KKChampionshipsModel *)champion
{
    if (self=[super initWithCid:cid gameId:gameId type:KKChampionshipsTypeLadder]) {
        self.dataManagerMain=[[KKChampionOtherResultManager alloc] initWithCid:cid gameId:gameId model:model];
        ((KKChampionOtherResultManager *)self.dataManagerMain).modelChampions=champion;
    }
    return self;
}
- (void)viewDidLoad {
    self.title=@"查看战绩";
    [super viewDidLoad];
    self.tableViewMain.tableHeaderView=self.headerView;
    // Do any additional setup after loading the view.
}
#pragma mark set/get
-(UIView *)headerView
{
    if (_headerView) {
        return _headerView;
    }
    _headerView = [[KKChampionRankinglistHeadView alloc] init];
    [_headerView setType:((KKChampionOtherResultManager *)self.dataManagerMain).model.type];
    return _headerView;
}
#pragma mark TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 65+16;
    }
    return 74;
}
@end
