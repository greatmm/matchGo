//
//  KKSetLocationTableViewController.m
//  game
//
//  Created by Jack on 2018/8/10.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKSetLocationTableViewController.h"
#import "KKFileTool.h"
#import "KKBaseTableViewCell.h"
@interface KKSetLocationTableViewController ()
@property(nonatomic,strong)NSArray * dataArr;//当前选择级别的所有数据
@property(nonatomic,strong)NSDictionary * pDic;//选择的省
@property(nonatomic,strong)NSDictionary * cityDic;//选择的市
@property(nonatomic,strong)NSDictionary * couDic;//选择的区
@end

@implementation KKSetLocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.dataArr = [KKFileTool chineseCityArr];
    self.navigationItem.title = @"设置地区";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
}
- (void)goBack{
    if (self.cityDic) {
        self.cityDic = nil;
        self.dataArr = self.pDic[@"cityList"];
        [self resetTableView];
        return;
    }
    if (self.pDic) {
        self.pDic = nil;
        self.dataArr = [KKFileTool chineseCityArr];
        [self resetTableView];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)resetTableView{
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuse = @"cityName";
    KKBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[KKBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        cell.textLabel.textColor = kTitleColor;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    NSDictionary * dic = self.dataArr[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArr[indexPath.row];
    if (self.pDic == nil) {
        self.pDic = dic;
    } else if(self.cityDic == nil){
        self.cityDic = dic;
    } else {
        self.couDic = dic;
        NSString * str = [NSString stringWithFormat:@"%@ %@ %@",self.pDic[@"name"],self.cityDic[@"name"],self.couDic[@"name"]];
        MTKFetchModel * model = [[MTKFetchModel alloc] init];
        model.requestParams = @{@"location":str};
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
        return;
    }
    self.dataArr = dic[@"cityList"];
    [self resetTableView];
}

@end
