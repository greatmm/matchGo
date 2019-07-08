//
//  KKAddressDetailTableViewController.m
//  game
//
//  Created by Jack on 2018/8/8.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKAddressDetailTableViewController.h"
#import "KKInputTableViewCell.h"
#import "KKInputRightTitleTableViewCell.h"
#import "KKSelectPicker.h"
@interface KKAddressDetailTableViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,strong) NSDictionary * pDic;
@property (nonatomic,strong) NSDictionary * cDic;
@property (nonatomic,strong) NSDictionary * qDic;
@end

@implementation KKAddressDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收货地址";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveOneAddress)];    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kTitleColor,NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kTitleColor,NSFontAttributeName:[UIFont systemFontOfSize:12]} forState: UIControlStateSelected];
    self.tableView.tableFooterView = [UIView new];
    self.dataArr = [KKFileTool chineseCityArr];
    if (self.addressItem) {
        //如果有值，赋值
        [self assignTableView];
    }
}
- (void)assignTableView{
    KKInputTableViewCell * personCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    personCell.tf.text = self.addressItem.contact;
     KKInputRightTitleTableViewCell * phoneCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    phoneCell.tf.text = self.addressItem.phone;
    
   KKInputTableViewCell * addressCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    addressCell.tf.text = self.addressItem.address;
    UITableViewCell * defaultCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UISwitch * s = defaultCell.contentView.subviews[1];
    s.on = self.addressItem.isdefault.boolValue;
    KKInputTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UILabel * label =(UILabel *)cell.contentView.subviews.firstObject;
    label.text = self.addressItem.area;
}
//保存地址
-(void)saveOneAddress{
    [self.view endEditing:YES];
    KKInputTableViewCell * personCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString * nickName = personCell.tf.text;
    if (![HNUBZUtil checkStrEnable:nickName]) {
        [KKAlert showText:@"请输入联系人姓名" toView:self.view];
        return;
    }
    KKInputRightTitleTableViewCell * phoneCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString * phone = phoneCell.tf.text;
    if (![phone isPhoneNumber]) {
        [KKAlert showText:@"电话号码格式不正确" toView:self.view];
        return;
    }
    //原来就没有值，并且没有选择地址
    if (self.addressItem == nil && !(self.pDic && self.cDic && self.qDic)) {
        [KKAlert showText:@"请选择所在地区" toView:self.view];
        return;
    }
    //获取详细地址
    KKInputTableViewCell * addressCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString * detailAddress = addressCell.tf.text;
    if (![HNUBZUtil checkStrEnable:detailAddress]) {
        [KKAlert showText:@"请输入详细地址"];
        return;
    }
    //是否是默认地址
    UITableViewCell * defaultCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UISwitch * s = defaultCell.contentView.subviews[1];
    if (self.addressItem == nil) {
        [KKAlert showAnimateWithText:nil toView:self.view];
        MTKFetchModel * model = [[MTKFetchModel alloc] init];
        model.requestParams = @{@"contact":nickName,@"phone":phone,@"area":[NSString stringWithFormat:@"%@ %@ %@",self.pDic[@"name"],self.cDic[@"name"],self.qDic[@"name"]],@"address":detailAddress,@"isdefault":[NSNumber numberWithBool:s.on]};
                                
    [model fetchWithPath:[NSString stringWithFormat:@"%@%@",baseUrl,addAddressUrl] type:MTKFetchModelTypePOST completion:^(BOOL isSucceeded, NSString * _Nonnull msg, NSError * _Nullable error) {
        [KKAlert dismissWithView:self.view];
        if (isSucceeded) {
            [KKAlert showText:@"添加地址成功" toView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addressChanged" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [KKAlert showText:msg toView:self.view];
        }
                                    
    }];
    } else {
        [KKAlert showAnimateWithText:nil toView:self.view];
        NSString * area = self.addressItem.area;
        if (self.pDic && self.cDic && self.qDic) {
           area = [NSString stringWithFormat:@"%@ %@ %@",self.pDic[@"name"],self.cDic[@"name"],self.qDic[@"name"]];
        }
        MTKFetchModel * model = [[MTKFetchModel alloc] init];
        model.requestParams = @{@"contact":nickName,@"phone":phone,@"area":area,@"address":detailAddress,@"isdefault":[NSNumber numberWithBool:s.on]};
        [model fetchWithPath:[NSString stringWithFormat:@"%@%@/%@",baseUrl,addAddressUrl,self.addressItem.address_id] type:MTKFetchModelTypePOST completion:^(BOOL isSucceeded, NSString * _Nonnull msg, NSError * _Nullable error) {
            [KKAlert dismissWithView:self.view];
            if (isSucceeded) {
                [KKAlert showText:@"地址更新成功" toView:self.view];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addressChanged" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [KKAlert showText:msg toView:self.view];
            }
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
//如果是编辑，无删除按钮
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.addressItem?3:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 0) {
        return 1;
    }
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [UIView new];
    header.backgroundColor = kBackgroundColor;
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footer = [UIView new];
    footer.backgroundColor = kBackgroundColor;
    return footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == 2) {
        //选择地址
        [self showAddressSelecter];
        return;
    }
    if (indexPath.section == 2) {
        //是否删除
        [self showAlert];
    }
}
- (void)showAlert
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确认删除该地址?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self delOneAddress];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:ensure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)delOneAddress
{
    [KKAlert showAnimateWithText:nil toView:self.view];
    MTKFetchModel * model = [[MTKFetchModel alloc] init];
    [model fetchWithPath:[NSString stringWithFormat:@"%@%@/%@/del",baseUrl,addAddressUrl,self.addressItem.address_id] type:MTKFetchModelTypePOST completion:^(BOOL isSucceeded, NSString * _Nonnull msg, NSError * _Nullable error) {
        [KKAlert dismissWithView:self.view];
        if (isSucceeded) {
            [KKAlert showText:@"删除成功" toView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addressChanged" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [KKAlert showText:msg toView:self.view];
        }
    }];
}
- (void)showAddressSelecter{
    self.pDic = self.dataArr.firstObject;
    NSArray * arr = self.pDic[@"cityList"];
    self.cDic = arr.firstObject;
    NSArray * cArr = self.cDic[@"cityList"];
    self.qDic = cArr.firstObject;
    KKSelectPicker * picker = [KKSelectPicker sharedSelectPicker];
    picker.pickerView.delegate = self;
    picker.pickerView.dataSource = self;
    picker.cancelBlock = ^{
        self.pDic = nil;
        self.cDic = nil;
        self.qDic = nil;
    };
    picker.ensureBlock = ^(NSInteger index) {
        NSString * str = [NSString stringWithFormat:@"%@ %@ %@",self.pDic[@"name"],self.cDic[@"name"],self.qDic[@"name"]];
        KKInputTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UILabel * label =(UILabel *)cell.contentView.subviews.firstObject;
        label.text = str;
    };
}
#pragma mark - pickerView代理方法
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataArr.count;
    } else if(component == 1){
        NSArray * arr = self.pDic[@"cityList"];
        return arr.count;
    } else {
        NSArray * arr = self.cDic[@"cityList"];
        return arr.count;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSDictionary * dic = self.dataArr[row];
        return dic[@"name"];
    } else if (component == 1){
        NSArray * arr = self.pDic[@"cityList"];
        NSDictionary * dic = arr[row];
        return dic[@"name"];
    } else {
        NSArray * arr = self.cDic[@"cityList"];
        NSDictionary * dic = arr[row];
        return dic[@"name"];
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.pDic = self.dataArr[row];
        NSArray * arr = self.pDic[@"cityList"];
        self.cDic = arr.firstObject;
        NSArray * cArr = self.cDic[@"cityList"];
        self.qDic = cArr.firstObject;
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    } else if (component == 1){
        NSArray * arr = self.pDic[@"cityList"];
        self.cDic = arr[row];
        NSArray * cArr = self.cDic[@"cityList"];
        self.qDic = cArr.firstObject;
        [pickerView reloadComponent:2];
    } else {
        NSArray * cArr = self.cDic[@"cityList"];
        self.qDic = cArr[row];
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
@end
