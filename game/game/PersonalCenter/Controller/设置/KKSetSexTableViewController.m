//
//  KKSetSexTableViewController.m
//  game
//
//  Created by Jack on 2018/8/9.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKSetSexTableViewController.h"
#import "KKUser.h"
@interface KKSetSexTableViewController ()
@property(nonatomic,assign) NSInteger index;
@end

@implementation KKSetSexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor whiteColor];
     self.index = 2;
    KKUser * user = [KKDataTool user];
    if (user && user.sex.integerValue != 0) {
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:user.sex.integerValue - 1 inSection:0]];
    }
    self.navigationItem.title = @"设置性别";
    self.view.backgroundColor = kBackgroundColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveSex)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
}
- (void)saveSex{
    KKUser * user = [KKDataTool user];
    if (user.sex.integerValue == self.index + 1) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [KKAlert showAnimateWithText:nil toView:self.view];
    MTKFetchModel * model = [[MTKFetchModel alloc] init];
    model.requestParams = @{@"sex":[NSNumber numberWithInteger:self.index + 1]};
    [model fetchWithPath:[NSString stringWithFormat:@"%@%@",baseUrl,accountUrl] type:MTKFetchModelTypePOST completion:^(BOOL isSucceeded, NSString * _Nonnull msg, NSError * _Nullable error) {
        [KKAlert dismissWithView:self.view];
        if (isSucceeded) {
            [KKAlert showText:@"设置成功" toView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changePersonInfo" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [KKAlert showText:msg toView:self.view];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [UIView new];
    header.backgroundColor = kBackgroundColor;
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.index) {
        return;
    }
    self.index = indexPath.row;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    NSArray <UITableViewCell*>* arr = self.tableView.visibleCells;
    arr[indexPath.row].accessoryType = UITableViewCellAccessoryCheckmark;
    arr[1 - indexPath.row].accessoryType = UITableViewCellAccessoryNone;
}
@end
