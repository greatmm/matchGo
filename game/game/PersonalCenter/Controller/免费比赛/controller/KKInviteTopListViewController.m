//
//  KKInviteTopListViewController.m
//  game
//
//  Created by greatkk on 2019/1/14.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKInviteTopListViewController.h"
#import "KKInviteTopModel.h"
#import "KKInviteTopTableViewCell.h"
#import "KKInviteTopDataManager.h"
#import "UITableView+Common.h"
@interface KKInviteTopListViewController ()<UITableViewDataSource>

@end

@implementation KKInviteTopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubview];
}
-(void)initSubview
{
    self.dataManagerMain = [[KKInviteTopDataManager alloc] initWithUrl:[NSString stringWithFormat:@"%@inviter/top",baseUrl] model:[KKInviteTopModel class] cell:[KKInviteTopTableViewCell class]];
//    self.dataManagerMain.modelForLoading.dictKey = @"invitees";
    self.tableViewMain.showsVerticalScrollIndicator = false;
    self.tableViewMain.isShowNothingReminderView = false;
    [self initSuperInfoWithMJ:false];
    [self requestData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

@end
