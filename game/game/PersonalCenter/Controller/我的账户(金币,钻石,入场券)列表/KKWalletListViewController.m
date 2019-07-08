//
//  KKWalletListViewController.m
//  game
//
//  Created by GKK on 2018/10/23.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKWalletListViewController.h"
#import "UIColor+KKCategory.h"
#import "KKWalletListTableViewCell.h"
#import "KKChongzhiViewController.h"
//#import "KKShareView.h"
#import "KKShareTool.h"
@interface KKWalletListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIView * noRecordView;
@property (nonatomic,strong) NSMutableArray * recordArr;
@property (assign,nonatomic) NSInteger accountType;//请求接口后边的值 1金币，2钻石 3门票 4收入 5提现
@property (assign,nonatomic) BOOL isHeaderRefresh;//头是否在刷新
@property (assign,nonatomic) BOOL isFooterRefresh;//尾部是否在刷新
@end

@implementation KKWalletListViewController
- (IBAction)clickBtn:(id)sender {
    if (self.type == 2) {
        [KKShareTool shareInvitecodeWithViewController:self];
        return;
    }
    KKChongzhiViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"chongzhiVC"];
    if (self.type == 1) {
        //钻石
        vc.isChongzhi = NO;
    } else {
        //金币
        vc.isChongzhi = YES;
    }
    __weak typeof(self) weakSelf = self;
    vc.chongzhiBlock = ^{
        [weakSelf refreshData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(UIView *)noRecordView
{
    if (_noRecordView) {
        return _noRecordView;
    }
    _noRecordView = [UIView new];
    _noRecordView.frame = self.tableView.bounds;
    UIImageView * imgView = [UIImageView new];
    imgView.image = [UIImage imageNamed:@"noRecord"];
    [_noRecordView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_noRecordView).offset(75);
        make.centerX.mas_equalTo(self->_noRecordView);
        make.width.height.mas_equalTo(168);
    }];
    [_noRecordView addSubview:imgView];
    UILabel * l = [UILabel new];
    NSArray * arr = @[@"您暂无钻石记录",@"您暂无金币记录",@"您暂无入场券记录"];
    l.text = arr[self.type];
    l.font = [UIFont systemFontOfSize:14];
    l.textColor = kTitleColor;
    [_noRecordView addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom);
        make.centerX.mas_equalTo(imgView);
    }];
    return _noRecordView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * tit1;
    NSString * tit2;
    NSString * tit3;
    if (@available(iOS 11.0, *)) {
        tit1 = @"        充值";
        tit2 = @"    获得金币";
        tit3 = @"    获得更多";
    }else {
        tit1 = @"      充值";
        tit2 = @" 获得金币";
        tit3 = @" 获得更多";
    }
    NSArray * arr = @[@{@"title":tit1,@"titleColor":@"#6A56F3",@"backColor":@"#7F8BF7",@"hintTitle":@"钻石数量"},@{@"title":tit2,@"titleColor":@"#845118",@"backColor":@"#E1964A",@"hintTitle":@"金币"},@{@"title":tit3,@"titleColor":@"#397CFC",@"backColor":@"#397CFC",@"hintTitle":@"入场券"}];
    NSDictionary * btnDic = arr[self.type];
    [self.btn setTitle:btnDic[@"title"] forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor colorWithHexString:btnDic[@"titleColor"]] forState:UIControlStateNormal];
    self.textLabel.text = btnDic[@"hintTitle"];
    self.btn.backgroundColor = [UIColor colorWithHexString:btnDic[@"backColor"] alpha:0.25];
    self.recordArr = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isHeaderRefresh) {
            return;
        }
        weakSelf.isHeaderRefresh = YES;
        [weakSelf getCurrentcy];
    }];
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        if (weakSelf.isFooterRefresh) {
            return;
        }
        weakSelf.isFooterRefresh = YES;
        [weakSelf getCurrentcy];
    }];
    [self.tableView.mj_header beginRefreshing];
    if (self.numberStr) {
        self.numberLabel.text = self.numberStr;
    } else {
        self.numberLabel.text = @"";
    }
//    if (self.type == 1) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"addMoney" object:nil];
//    } else {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"chongzhiSuccess" object:nil];
//    }
}
- (void)refreshData
{
    [KKNetTool getMyWalletSuccessBlock:^(NSDictionary *dic) {
        dispatch_main_async_safe((^{
            NSArray * keys = @[@"diamond",@"gold",@"ticket"];
            NSNumber * n = dic[keys[self.type]];
            self.numberStr = [KKDataTool decimalNumber:n fractionDigits:0];
            if (self.numberStr) {
                self.numberLabel.text = self.numberStr;
            } else {
                self.numberLabel.text = @"";
            }
        }))
    } erreorBlock:^(NSError *error) {}];
    [self.tableView.mj_header beginRefreshing];
}
- (void)getCurrentcy
{
    NSNumber * offset;
    if (self.isHeaderRefresh) {
        offset = @0;
    } else {
        offset = [NSNumber numberWithInteger:self.recordArr.count];
    }
    [KKNetTool getRecordWithCurrency:[self getCurrencyNumber] para:@{@"offset":offset} SuccessBlock:^(NSDictionary *dic) {
        if (self.isHeaderRefresh) {
            [self.recordArr removeAllObjects];
        }
        NSArray * arr = (NSArray *)dic;
        [self.recordArr addObjectsFromArray:arr];
        [self stopRefresh];
        [self.tableView reloadData];
    } erreorBlock:^(NSError *error) {
        [self stopRefresh];
    }];
}
- (void)stopRefresh
{
    self.isFooterRefresh = NO;
    self.isHeaderRefresh = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
- (NSNumber *)getCurrencyNumber
{
    if (self.accountType != 0) {
        return [NSNumber numberWithInteger:self.accountType];
    }
    NSNumber * number;
    // 0钻石 1金币 2金币 3提现记录 4收入记录
    switch (self.type) {
        case 0:
            number = @2;
            break;
        case 1:
            number = @1;
            break;
        case 2:
            number = @3;
            break;
        case 3:
            number = @5;
            break;
        default:
            number = @4;
            break;
    }
    self.accountType = number.integerValue;
    return number;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIView * supView = self.numberLabel.superview;
    [supView addShadowWithFrame:supView.bounds shadowOpacity:0.15 shadowColor:kTitleColor shadowOffset:CGSizeMake(0, 3)];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.recordArr.count == 0) {
        return 1;
    }
    return self.recordArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.recordArr.count == 0) {
        return CGRectGetHeight(tableView.bounds);
    }
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.recordArr.count == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"bigCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bigCell"];
            [cell.contentView addSubview:self.noRecordView];
        }
        return cell;
    }
    static NSString * reuse = @"wallectCell";
    KKWalletListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    cell.accountType = self.accountType;
    [cell assignWithDic:self.recordArr[indexPath.row]];
    return cell;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
