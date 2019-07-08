//
//  KKLoginViewController.m
//  game
//
//  Created by GKK on 2018/8/7.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKLoginViewController.h"
#import "UIImage+KKCategory.h"
#import "KKAuthCodeView.h"
#import "KKUser.h"
#import "KKDataTool.h"
#import "KKWebViewController.h"
#import "KKChampionshipDetailNewViewController.h"

@interface KKLoginViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *authCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UITextView *protocolTextView;
@property (strong,nonatomic) dispatch_source_t timer;
@end

@implementation KKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableAttributedString *att =[[NSMutableAttributedString alloc] initWithAttributedString: self.protocolTextView.attributedText];
    NSRange range = [[att string]rangeOfString:@"《玩家条款》"];
    [att addAttribute:NSLinkAttributeName value:@"" range: range];
    self.protocolTextView.attributedText = att;
    [self.startBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:217/255.0 alpha:1]] forState:UIControlStateNormal];
    [self.startBtn setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateSelected];
    [self.startBtn setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateHighlighted];
    self.startBtn.userInteractionEnabled = NO;
    [self.authCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:217/255.0 alpha:1]] forState:UIControlStateNormal];
    [self.authCodeBtn setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateSelected];
    [self.authCodeBtn setBackgroundImage:[UIImage imageWithColor:kThemeColor] forState:UIControlStateHighlighted];
    self.authCodeBtn.userInteractionEnabled = NO;
}
- (IBAction)phoneTfChanged:(id)sender {
    NSString * phone = self.phoneTf.text;
    if (phone.length > 11) {
        self.phoneTf.text = [phone substringToIndex:11];
    }
    self.authCodeBtn.selected = (phone.length >4);
    self.authCodeBtn.userInteractionEnabled = [self.phoneTf.text isPhoneNumber] && (self.timer == nil);
    NSString * auth = self.authCodeTf.text;
    self.startBtn.userInteractionEnabled = ([self.phoneTf.text isPhoneNumber] && [auth isAuthCode]);
}
- (IBAction)authTfChanged:(id)sender {
    NSString * auth = self.authCodeTf.text;
    if (auth.length > 6) {
        self.authCodeTf.text = [auth substringToIndex:6];
    }
    self.startBtn.selected = (auth.length > 0);
    self.startBtn.userInteractionEnabled = ([self.phoneTf.text isPhoneNumber] && [auth isAuthCode]);
}

- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(NSURL*)URL inRange:(NSRange)characterRange {
    KKWebViewController * vc = [KKWebViewController new];
    [vc loadLocalFile:@"MatchGoServceProtocal.docx"];
    vc.webTitle = @"Match go软件许可及服务协议";
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction NS_AVAILABLE_IOS(10_0)
{
    KKWebViewController * vc = [KKWebViewController new];
    [vc loadLocalFile:@"MatchGoServceProtocal.docx"];
                vc.webTitle = @"Match go软件许可及服务协议";
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}
- (IBAction)clickCloseBtn:(id)sender {
    [KKDataTool destroyLoginVc];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)getAuthCode:(id)sender {
    [self.view endEditing:YES];
    KKAuthCodeView * codeView = [KKAuthCodeView shareCodeView];
    [self.view addSubview:codeView];
    codeView.ensureBlock = ^(NSMutableDictionary * paraDic) {
        NSString * phone = self.phoneTf.text;
        if ([phone isPhoneNumber] == NO) {
            [KKAlert showText:@"请输入正确的手机号" toView:self.view];
            return;
        }
        paraDic[@"mobile"] = self.phoneTf.text;
        [KKNetTool getLoginVcodeWithPara:paraDic SuccessBlock:^(NSDictionary *dic) {
            [self downCount:self.authCodeBtn];
        } erreorBlock:^(NSError *error) {
            if ([error isKindOfClass:[NSString class]]) {
                [KKAlert showText:(NSString *)error toView:self.view];
            } else {
                [KKAlert showText:@"获取验证码失败" toView:self.view];
            }
        }];
    };
}
- (void)downCount:(UIButton *)sender {
    __block int timeout = 59; //倒计时时间
    sender.userInteractionEnabled = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(weakSelf.timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(weakSelf.timer);
            weakSelf.timer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:@"重新发送" forState:UIControlStateNormal];
                sender.userInteractionEnabled = ([weakSelf.phoneTf.text isPhoneNumber]);
                sender.highlighted = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2ds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [sender setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (IBAction)clickStartBtn:(id)sender {
    NSString * chap = self.authCodeTf.text;
    NSString * mobile = self.phoneTf.text;
    if (![mobile isPhoneNumber]) {
        return;
    }
    if (![chap isAuthCode]) {
        return;
    }
    [KKNetTool loginWithPara:@{@"mobile":mobile,@"vcode":chap} SuccessBlock:^(NSDictionary *dic) {
        [KKAlert showText:@"登录成功"];
        [KKDataTool saveUser:[KKUser mj_objectWithKeyValues:dic]];
        NSDictionary * d = @{@"t":@100,@"u":[KKDataTool token],@"d":@{}};
        [[KKWSTool shareTools] sendMessage:d];
//        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:KKLoginNotification object:nil];
        [KKDataTool destroyLoginVc];
        [self getMyStartMatch];
    } erreorBlock:^(NSError *error) {
        if ([error isKindOfClass:[NSString class]]) {
            [KKAlert showText:(NSString *)error toView:self.view];
        } else {
            [KKAlert showText:@"登录失败" toView:self.view];
        }
    }];
}
- (void)getMyStartMatch
{
    //登录之后才能获取数据，否则就不请求
    if ([KKDataTool token]) {
        [KKNetTool myStartRoomWithSuccessBlock:^(NSDictionary *dic) {
            NSArray * users = dic[@"users"];
            for (NSDictionary * dic in users) {
                NSNumber * uid = dic[@"uid"];
                KKUser * user = [KKDataTool user];
                if (uid && [uid isEqual:user.userId]) {
                    NSNumber * state = dic[@"state"];
                    if (state.integerValue == 11) {
                        return;
                    }
                    break;
                }
            }
            NSDictionary * champion = dic[@"champion"];
            if (champion) {
                KKChampionshipDetailNewViewController * vc = [KKChampionshipDetailNewViewController new];
                vc.dataDic = dic;
                vc.isSmall = YES;
                KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:vc];
                [KKDataTool shareTools].window.rootViewController = nav;
                [[KKDataTool shareTools].window makeKeyAndVisible];
                return;
            }
            NSDictionary * match = dic[@"match"];
            if (match == nil) {
                match = dic[@"room"];
            }
            if (dic == nil || match == nil) {
                return;
            }
            dispatch_main_async_safe(^{
                NSNumber * matchType = match[@"matchtype"];
                KKBigHouseViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"bighouseVC"];
                vc.roomDic = dic;
                vc.gameType = matchType.integerValue;
                vc.isSmall = YES;
                KKNavigationController * nav = [[KKNavigationController alloc] initWithRootViewController:vc];
                [KKDataTool shareTools].window.rootViewController = nav;
                [[KKDataTool shareTools].window makeKeyAndVisible];
            })
        } erreorBlock:^(NSError *error) {
            //            NSLog(@"%@",error);
        }];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (self.timer) {
        dispatch_source_cancel(_timer);
        self.timer = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
//    NSLog(@"死了");
}

@end
