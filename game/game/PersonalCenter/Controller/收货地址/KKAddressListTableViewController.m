//
//  KKAddressListTableViewController.m
//  game
//
//  Created by Jack on 2018/8/8.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKAddressListTableViewController.h"
#import "KKAddressTableViewCell.h"
#import "KKAddressDetailTableViewController.h"
#import "KKAddressItem.h"
@interface KKAddressListTableViewController ()
@property (nonatomic,strong) NSMutableArray * addressArr;//所有的地址
@end
@implementation KKAddressListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收货地址";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增新地址" style:UIBarButtonItemStylePlain target:self action:@selector(addOneAddress)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kTitleColor,NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kTitleColor,NSFontAttributeName:[UIFont systemFontOfSize:12]} forState: UIControlStateSelected];
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    self.addressArr = [NSMutableArray new];
    [self getAddressList];//获取地址列表数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAddressList) name:@"addressChanged" object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//获取所有的地址
- (void)getAddressList
{
    [KKAlert showText:nil toView:self.view];
    MTKFetchModel * model = [[MTKFetchModel alloc] init];
    [model fetchWithPath:[NSString stringWithFormat:@"%@%@",baseUrl,addressesUrl] type:MTKFetchModelTypeGET completionWithData:^(BOOL isSucceeded, NSString * _Nonnull msg, NSError * _Nullable error, id  _Nullable responseObjectData) {
        [KKAlert dismissWithView:self.view];
        if (isSucceeded) {
            NSDictionary * dic = responseObjectData;
            NSArray * arr = (NSArray *)dic;
            if ([arr isKindOfClass:[NSArray class]]) {
                [self.addressArr removeAllObjects];
                for (NSDictionary * dict in arr) {
                    KKAddressItem * item = [[KKAddressItem alloc] initWithJSONDict:dict];
                    [self.addressArr addObject:item];
                }
            }
            [self.tableView reloadData];
        } else {
            [KKAlert showText:msg toView:self.view];
        }
    }];
}
//防止右上角新增新地址变暗
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
}
//跳到新增地址界面
- (void)addOneAddress{
    KKAddressDetailTableViewController * cv = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"addressDetail"];
    [self.navigationController pushViewController:cv animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuse = @"addressCell";
    KKAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.editBlock = ^{
        //点击编辑
        KKAddressDetailTableViewController * cv = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"addressDetail"];
        cv.addressItem = weakSelf.addressArr[indexPath.row];
        [weakSelf.navigationController pushViewController:cv animated:YES];
    };
    KKAddressItem * item = self.addressArr[indexPath.row];
    [cell assignWithItem:item];
    return cell;
}

@end
