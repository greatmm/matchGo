//
//  KKSettingTableViewController.m
//  game
//
//  Created by Jack on 2018/8/8.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKSettingTableViewController.h"
#import "KKWebViewController.h"
#warning todo 缺：关于赛事狗说明
@interface KKSettingTableViewController ()

@end

@implementation KKSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.navigationController.navigationBar.hidden = NO;
    self.tableView.backgroundColor = [UIColor colorWithWhite:252/255.0 alpha:1];
    self.tableView.rowHeight = 50;

    //添加退出按钮
    UIView * footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, ScreenWidth, 132);
    self.tableView.tableFooterView = footerView;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn setTitleColor:kOrangeColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView);
        make.centerX.mas_equalTo(footerView);
        make.bottom.mas_equalTo(footerView);
        make.height.mas_equalTo(52);
    }];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [self showLogoutBtn];//是否显示退出按钮
    //计算缓存大小
    float size = [self getCatchSize];
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fMB",size];
    //获取当前版本号
    NSString * version = [KKDataTool appVersion];
    UITableViewCell * cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    cell1.detailTextLabel.text = [NSString stringWithFormat:@"版本v%@",version];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLogoutBtn) name:KKLoginNotification object:nil];
}
- (void)showLogoutBtn
{
    self.tableView.tableFooterView.hidden = ([KKDataTool token] == nil);
}
- (float)getCatchSize
{
    NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
    float MBCache = bytesCache/1024.0/1024.0;
    return MBCache;
}
//清除缓存
- (void)clearCache
{
    [KKAlert showAnimateWithText:nil toView:self.view];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [KKAlert dismissWithView:self.view];
            dispatch_async(dispatch_get_main_queue(), ^{
                UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                cell.detailTextLabel.text = @"0MB";
            });
        }];
    });
}
//退出登录清理缓存及一些处理
- (void)loginOut {
    [[NSNotificationCenter defaultCenter] postNotificationName:KKLogoutNotification object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        kkLoginMacro
        NSArray * arr = @[@"peronalInfo",@"AddressList"];
        UIViewController * cv = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:arr[indexPath.row]];
        [self.navigationController pushViewController:cv animated:YES];
        return;
    }
    if (indexPath.row == 0) {
        if ([self getCatchSize] == 0.00) {
            [KKAlert showText:@"暂无缓存" toView:self.view];
        } else {
            [self clearCache];
        }
        return;
    }
//    switch (indexPath.row) {
//
//        case 2:
//        {
//
//        }
//        case 3:{
//            return;
//        }
//            case 4:
//        {
//            KKWebViewController * vc = [KKWebViewController new];
//            [vc loadLocalFile:@"MatchGoServceProtocal.docx"];
//            vc.webTitle = @"Match go软件许可及服务协议";
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
//            case 5:
//        {
//            KKWebViewController * vc = [KKWebViewController new];
//            [vc loadLocalFile:@"MatchGoGuider.docx"];
//            vc.webTitle = @"Match go隐私保护指引";
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
//        default:
//            break;
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}
@end
