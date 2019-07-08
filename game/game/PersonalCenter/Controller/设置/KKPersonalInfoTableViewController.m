//
//  KKPersonalInfoTableViewController.m
//  game
//
//  Created by Jack on 2018/8/8.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKPersonalInfoTableViewController.h"
#import "KKAvatarTableViewCell.h"
#import "KKSetLocationTableViewController.h"
#import "KKUser.h"
#import "KKAlipayBindViewController.h"
@interface KKPersonalInfoTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation KKPersonalInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    self.houseBtm = -1 * kSmallHouseHeight;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPersonInfo) name: @"changePersonInfo" object:nil];
    [self getPersonInfo];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    KKNavigationController * nav = (KKNavigationController *)self.navigationController;
    [nav addShadow];
}
//获取账户信息
- (void)getPersonInfo
{
    [KKNetTool getAccountSuccessBlock:^(NSDictionary *dic) {
        //获取到了数据，更新用户
//        NSLog(@"获取到的用户数据%@",dic);
        KKUser * user = [KKUser mj_objectWithKeyValues:dic];
        [KKDataTool saveUser:user];
        [self reloadDataWithDic:dic];
    } erreorBlock:^(NSError *error) {
        //没有就取缓存
        KKUser * user = [KKDataTool user];
        if (user) {
            [self reloadDataWithUser:user];
        } else {
            [KKAlert showText:@"获取数据失败"];
        }
    }];
}
//首次用字典更新
-(void)reloadDataWithDic:(NSDictionary *)user{
    dispatch_async(dispatch_get_main_queue(), ^{
        KKAvatarTableViewCell * cell0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell0.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon"]];
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.detailTextLabel.text = user[@"nickname"];
        UITableViewCell * cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        NSString * sex = @"";
        NSNumber * s = user[@"sex"];
        if (s.integerValue == 1) {
            sex = @"男";
        } else if(s.integerValue == 2){
            sex = @"女";
        }
        cell1.detailTextLabel.text = sex;
//        NSLog(@"%@",cell1.detailTextLabel);
        UITableViewCell * cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell2.detailTextLabel.text = user[@"location"];
        [self.tableView reloadData];
    });
}
//更新界面
-(void)reloadDataWithUser:(KKUser *)user{
    dispatch_async(dispatch_get_main_queue(), ^{
        KKAvatarTableViewCell * cell0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell0.avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.detailTextLabel.text = user.nickname;
        UITableViewCell * cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        NSString * sex = @"";
        if (user.sex.integerValue == 1) {
            sex = @"男";
        } else if(user.sex.integerValue == 2){
            sex = @"女";
        }
        cell1.detailTextLabel.text = sex;
        UITableViewCell * cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell2.detailTextLabel.text = user.location;
        [self.tableView reloadData];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    return header;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [self showAlertController];
        }
            return;
        case 1:
        {
            UIViewController * cv = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"settingName"];
            [self.navigationController pushViewController:cv animated:YES];
        }
            return;
        case 2:
        {
            UIViewController * cv = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"setSex"];
            [self.navigationController pushViewController:cv animated:YES];
        }
            return;
        case 3:
        {
            KKSetLocationTableViewController * cv = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"setLocation"];
            [self.navigationController pushViewController:cv animated:YES];
        }
            break;
        case 4:
        {
            KKAlipayBindViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"alipayBind"];
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            UIViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"setPwd"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:{
            
        }
            return;
    }
}
//更新头像
- (void)showAlertController{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
        }];
        [alertC addAction:cameraAction];
    }
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerWithType:sourceType];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:photoAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)showImagePickerWithType:(UIImagePickerControllerSourceType)imagePickerType{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = imagePickerType;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [KKNetTool uploadAvatarWithImg:image SuccessBlock:^(NSDictionary *dic) {
        NSString * d = (NSString *)dic;
        KKUser * user = [KKDataTool user];
        user.avatar = d;
        [KKDataTool saveUser:user];
        KKAvatarTableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:d] placeholderImage:[UIImage imageNamed:@"icon"]];
    } erreorBlock:^(NSError *error) {
        [KKAlert showText:@"上传头像失败"];
    }];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
