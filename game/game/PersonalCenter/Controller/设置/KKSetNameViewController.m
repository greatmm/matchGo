//
//  KKSetNameViewController.m
//  game
//
//  Created by Jack on 2018/8/9.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKSetNameViewController.h"

@interface KKSetNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (nonatomic,strong) NSString * nickName;
@end

@implementation KKSetNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置名字";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveName)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.view.backgroundColor = kBackgroundColor;
    self.nickName = [KKDataTool user].nickname;
    if (self.nickName) {
        self.tf.text = self.nickName;
    }
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
}
- (void)saveName{
   NSString * fName = [self deleteWhitespaceWith:self.nickName];
    if ([fName isEqualToString:[KKDataTool user].nickname]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [KKAlert showAnimateWithText:nil toView:self.view];
    MTKFetchModel * model = [[MTKFetchModel alloc] init];
    model.requestParams = @{@"nickname":fName};
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
- (NSString *)deleteWhitespaceWith:(NSString *)str
{
    while ([str characterAtIndex:0] == ' ') {
        str = [str substringFromIndex:1];
    }
    while ([str characterAtIndex:str.length - 1] == ' ') {
        str = [str substringToIndex:str.length - 1];
    }
    return str;
}
- (IBAction)textFieldTextChanged:(id)sender {
    self.nickName = self.tf.text;
    self.navigationItem.rightBarButtonItem.enabled = ![self.nickName isEmpty];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
