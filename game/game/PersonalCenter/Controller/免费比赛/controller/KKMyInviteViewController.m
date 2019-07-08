//
//  KKMyInviteViewController.m
//  game
//
//  Created by greatkk on 2019/1/14.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKMyInviteViewController.h"
#import "KKMyInviteTableViewCell.h"
#import "KKInviter.h"
#import "KKMyInviterDataManager.h"
#import "UITableView+Common.h"
@interface KKMyInviteViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation KKMyInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubview];
}
-(void)initSubview
{
    self.dataManagerMain = [[KKMyInviterDataManager alloc] initWithUrl:[NSString stringWithFormat:@"%@account/invitees",baseUrl] model:[KKInviter class] cell:[KKMyInviteTableViewCell class]];
    self.dataManagerMain.modelForLoading.dictKey = @"invitees";
    UIImageView * imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inviteExplain"]];
    UIView * footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth * 197/375 + 10);
    footerView.backgroundColor = [UIColor colorWithWhite:252/255.0 alpha:1];
    imgView.frame = CGRectMake(0, 10, ScreenWidth, ScreenWidth * 197/375.0);
    [footerView addSubview:imgView];
    self.tableViewMain.tableFooterView = footerView;
    self.tableViewMain.showsVerticalScrollIndicator = false;
    [self initSuperInfoWithMJ:false];
    [self requestData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}
@end
