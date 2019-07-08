//
//  KKChampionRewardViewController.m
//  game
//
//  Created by linsheng on 2019/1/14.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionRewardViewController.h"
#import "KKRewardHeadView.h"
#import "KKChampionRewardTableViewCell.h"
#import "KKChampionRewardManager.h"
@interface KKChampionRewardViewController ()
@property (nonatomic, strong) KKRewardHeadView *headView;
@end

@implementation KKChampionRewardViewController

- (void)viewDidLoad {
    
    self.dataManagerMain=[[KKChampionRewardManager alloc] initWithUrl:@"champion/awards" model:[MTKJsonModel class] cell:[KKChampionRewardTableViewCell class]];
    self.dataManagerMain.modelForLoading.dictKey=@"top";
    [self initSuperInfoWithMJ:false];
    _headView=[KKRewardHeadView new];
    self.tableViewMain.tableHeaderView=_headView;
    [self requestData];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
//    if (<#condition#>) {
//        <#statements#>
//    }
    [_headView setAmount:_modelChampionships.showaward_total];
    [super viewWillAppear:animated];
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return H(42);
}

@end
