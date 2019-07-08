//
//  KKBindAccountViewController.m
//  game
//
//  Created by greatkk on 2018/11/27.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBindAccountViewController.h"
#import "KKSelectButton.h"
#import "KKEnsureGameAccountView.h"
#import "KKSelectPicker.h"
#import "KKBottomButton.h"
#import "KKChampionshipHintView.h"
#import "KKBindItemView.h"
#import "KKAlertViewStyleTips.h"

@interface KKBindAccountViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
#warning 除了王者荣耀，其它游戏绑定及修改需要测试
@property (weak, nonatomic) IBOutlet UIImageView *gameBackImgView;//游戏背景图
@property (weak, nonatomic) IBOutlet UIImageView *gameHintView;//提示查找账号的截图
@property (weak, nonatomic) IBOutlet UIView *selectView;//选择选项的view
@property (weak, nonatomic) IBOutlet UILabel *topHintLabel;//如何找到我的绝地求生游戏ID
@property (weak, nonatomic) IBOutlet UILabel *btmHintLabel;//在英雄联盟客户端右上角，上图红框内即为你的英雄联盟召唤师昵称。
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectViewHeightConst;//选项的高度，不同游戏对应的不同

@property (strong,nonatomic) UITextField * roleTf;//输入角色ID
@property (weak, nonatomic) IBOutlet KKBottomButton *ensureBtn;//底部绑定按钮
@property (strong,nonatomic) UILabel *duanweiLabel;//显示选择的段位
@property (nonatomic,assign) NSInteger zhongduan;//苹果，安卓
@property (nonatomic,assign) NSInteger pingtai;//微信，qq
@property (nonatomic,strong) NSString * duanwei;//选择的段位
@property (nonatomic,strong) NSArray * duanweiArr;
@property (nonatomic,strong) KKEnsureGameAccountView * ensureView;//绑定结果展示页
@property (strong,nonatomic) KKSelectButton * androidBtn;//安卓设备
@property (strong,nonatomic) KKSelectButton * iphoneBtn;//iphone设备
@property (strong,nonatomic) KKSelectButton * qqBtn;//QQ平台
@property (strong,nonatomic) KKSelectButton * wechatBtn;//微信平台
@property (strong,nonatomic) dispatch_source_t timer;//定时器
@end

@implementation KKBindAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.houseBtm = isIphoneX?(34 + 59):(59);
    self.zhongduan = 2;//默认未选择设备
    self.pingtai = 2;//默认未选择平台
    [self assignUI];
    if (_gameId == 1) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBindAccountResult:) name:kBindAccountResult object:nil];//查询到账号信息之后发的消息，用于有接口的游戏
    }
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self checkEnsureBtn];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
//点击返回按钮
- (IBAction)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 根据不同的游戏id设置UI
-(void)assignUI
{
    if (_gameId < 1 || _gameId > 4) {
        return;
    }
    NSArray * backArr = @[@"PUBGBigBG",@"GKBigBG",@"ZCBigBG",@"LOLBigBG"];
    NSArray * hintArr = @[@"PUBGID",@"GKID",@"ZCID",@"LOLID"];
    NSArray * topArr = @[@"如何找到我的绝地求生游戏ID",@"如何找到我的王者荣耀名字",@"如何找到我的刺激战场角色昵称",@"如何找到我的lol召唤师昵称"];
    NSArray * btmArr = @[@"在绝地求生客户端右上角，上图红框内即为你的绝地求生游戏ID。",@"在王者荣耀客户端右上角，上图红框内即为你的王者荣耀名字。",@"在刺激战场客户端右上角，上图红框内即为你的刺激战场角色昵称。",@"在英雄联盟客户端右上角，上图红框内即为你的英雄联盟召唤师昵称。"];
    NSInteger index = _gameId - 1;
    self.gameBackImgView.image = [UIImage imageNamed:backArr[index]];
    self.gameHintView.image = [UIImage imageNamed:hintArr[index]];
    self.topHintLabel.text = topArr[index];
    self.btmHintLabel.text = btmArr[index];
    switch (_gameId) {
        case 1:
        {
            [self.selectView addSubview:self.roleTf];
            self.roleTf.placeholder = @"输入绝地求生游戏ID，请注意大小写";
            [self.roleTf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.mas_equalTo(self.selectView).offset(16);
                make.right.mas_equalTo(self.selectView).offset(-16);
                make.height.mas_equalTo(30);
            }];
            UIView * line = [UIView new];
            line.backgroundColor = [UIColor colorWithWhite:112/255.0 alpha:0.1];
            [self.selectView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.roleTf.mas_bottom).offset(10);
                make.height.mas_equalTo(1);
                make.left.right.mas_equalTo(self.roleTf);
            }];
            self.selectViewHeightConst.constant = 84;
            [self.view layoutIfNeeded];
            if (self.item) {
                if ([HNUBZUtil checkStrEnable:self.item.gamer]) {
                    self.roleTf.text = self.item.gamer;
                    [self checkEnsureBtn];
                }
            }
//            if (self.accountDic) {
//                self.roleTf.text = self.accountDic[@"gamer"];
//                [self checkEnsureBtn];
//            }
        }
            break;
        case 2:
        {
            //设备
            [self.selectView addSubview:self.iphoneBtn];
            [self.selectView addSubview:self.androidBtn];
            UILabel * l = [UILabel new];
            l.text = @"设备";
            l.font = [UIFont boldSystemFontOfSize:16];
            l.textColor = kTitleColor;
            [self.selectView addSubview:l];
            [self.iphoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.selectView).offset(16);
                make.width.mas_equalTo(ScreenWidth/3 - 16); make.right.mas_equalTo(self.selectView).offset(-16);
                make.height.mas_equalTo(44);
            }];
            [self.androidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.width.mas_equalTo(self.iphoneBtn);
                make.right.mas_equalTo(self.iphoneBtn.mas_left).offset(-16);
            }];
            [l mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.androidBtn);
                make.left.mas_equalTo(self.selectView).offset(16);
            }];
            //平台
            [self.selectView addSubview:self.wechatBtn];
            [self.selectView addSubview:self.qqBtn];
            UILabel * l1 = [UILabel new];
            l1.text = @"平台";
            l1.font = [UIFont boldSystemFontOfSize:16];
            l1.textColor = kTitleColor;
            [self.selectView addSubview:l1];
            [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.iphoneBtn.mas_bottom).offset(16);
                make.width.mas_equalTo(ScreenWidth/3 - 16); make.right.mas_equalTo(self.selectView).offset(-16);
                make.height.mas_equalTo(44);
            }];
            [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.width.mas_equalTo(self.qqBtn);
                make.right.mas_equalTo(self.qqBtn.mas_left).offset(-16);
            }];
            [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.wechatBtn);
                make.left.mas_equalTo(self.selectView).offset(16);
            }];
            [self.selectView addSubview:self.roleTf];
            self.roleTf.placeholder = @"输入王者荣耀名字，请注意大小写";
            [self.roleTf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.wechatBtn.mas_bottom).offset(16);
                make.left.mas_equalTo(self.selectView).offset(16);
                make.right.mas_equalTo(self.selectView).offset(-16);
                make.height.mas_equalTo(30);
            }];
            UIView * line = [UIView new];
            line.backgroundColor = [UIColor colorWithWhite:112/255.0 alpha:0.1];
            [self.selectView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.roleTf.mas_bottom).offset(10);
                make.height.mas_equalTo(1);
                make.left.right.mas_equalTo(self.roleTf);
            }];
            UIControl * control = [UIControl new];
            [control addTarget:self action:@selector(clickDuanweiControl:) forControlEvents:UIControlEventTouchUpInside];
            control.backgroundColor = kBackgroundColor;
            [self.selectView addSubview:control];
            [control mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(line).offset(16);
                make.left.right.mas_equalTo(line);
                make.height.mas_equalTo(44);
            }];
            [control addSubview:self.duanweiLabel];
            [self.duanweiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(control);
                make.left.mas_equalTo(control).offset(10);
            }];
            self.selectViewHeightConst.constant = 16 + 44 + 16 + 44 + 16 + 30 + 11 + 24 + 60;
            [self.view layoutIfNeeded];
            if (self.item) {
                if ([HNUBZUtil checkStrEnable:self.item.server]) {
                    NSString * server = self.item.server;
                    if ([server isEqualToString:@"QQ"]) {
                        [self clickBtn:self.qqBtn];
                    } else {
                        [self clickBtn:self.wechatBtn];
                    }
                }
                NSNumber * device = self.item.device;
                if (device.integerValue == 2) {
                    [self clickBtn:self.iphoneBtn];
                } else {
                    [self clickBtn:self.androidBtn];
                }
                if ([HNUBZUtil checkStrEnable:self.item.gamer]) {
                    self.roleTf.text = self.item.gamer;
                }
                NSString * ext = self.item.gamerank;
                if ([HNUBZUtil checkStrEnable:ext]) {
                    self.duanweiLabel.text = ext;
                    self.duanwei = ext;
                }
                [self checkEnsureBtn];
            }
//            if (self.accountDic) {
//                NSString * server = self.accountDic[@"server"];
//                if ([server isEqualToString:@"QQ"]) {
//                    [self clickBtn:self.qqBtn];
//                } else {
//                    [self clickBtn:self.wechatBtn];
//                }
//                NSNumber * device = self.accountDic[@"device"];
//                if (device.integerValue == 2) {
//                    [self clickBtn:self.iphoneBtn];
//                } else {
//                    [self clickBtn:self.androidBtn];
//                }
//                self.roleTf.text = self.accountDic[@"gamer"];
//                NSString * ext = self.accountDic[@"gamerank"];
//                if ([HNUBZUtil checkStrEnable:ext]) {
//                    self.duanweiLabel.text = ext;
//                    self.duanwei = ext;
//                }
//            }
        }
            break;
        case 3:
        {
            //设备
            [self.selectView addSubview:self.iphoneBtn];
            [self.selectView addSubview:self.androidBtn];
            UILabel * l = [UILabel new];
            l.text = @"设备";
            l.font = [UIFont boldSystemFontOfSize:16];
            l.textColor = kTitleColor;
            [self.selectView addSubview:l];
            [self.iphoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.selectView).offset(16);
                make.width.mas_equalTo(ScreenWidth/3 - 16); make.right.mas_equalTo(self.selectView).offset(-16);
                make.height.mas_equalTo(44);
            }];
            [self.androidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.width.mas_equalTo(self.iphoneBtn);
                make.right.mas_equalTo(self.iphoneBtn.mas_left).offset(-16);
            }];
            [l mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.androidBtn);
                make.left.mas_equalTo(self.selectView).offset(16);
            }];
            //平台
            [self.selectView addSubview:self.wechatBtn];
            [self.selectView addSubview:self.qqBtn];
            UILabel * l1 = [UILabel new];
            l1.text = @"平台";
            l1.font = [UIFont boldSystemFontOfSize:16];
            l1.textColor = kTitleColor;
            [self.selectView addSubview:l1];
            [self.qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.iphoneBtn.mas_bottom).offset(16);
                make.width.mas_equalTo(ScreenWidth/3 - 16); make.right.mas_equalTo(self.selectView).offset(-16);
                make.height.mas_equalTo(44);
            }];
            [self.wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.width.mas_equalTo(self.qqBtn);
                make.right.mas_equalTo(self.qqBtn.mas_left).offset(-16);
            }];
            [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.wechatBtn);
                make.left.mas_equalTo(self.selectView).offset(16);
            }];
            [self.selectView addSubview:self.roleTf];
            self.roleTf.placeholder = @"输入刺激战场角色昵称，请注意大小写";
            [self.roleTf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.wechatBtn.mas_bottom).offset(16);
                make.left.mas_equalTo(self.selectView).offset(16);
                make.right.mas_equalTo(self.selectView).offset(-16);
                make.height.mas_equalTo(30);
            }];
            UIView * line = [UIView new];
            line.backgroundColor = [UIColor colorWithWhite:112/255.0 alpha:0.1];
            [self.selectView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.roleTf.mas_bottom).offset(10);
                make.height.mas_equalTo(1);
                make.left.right.mas_equalTo(self.roleTf);
            }];
            self.selectViewHeightConst.constant = 16 + 44 + 16 + 44 + 16 + 30 + 11 + 24;
            [self.view layoutIfNeeded];
            if (self.item) {
                if ([HNUBZUtil checkStrEnable:self.item.server]) {
                    NSString * server = self.item.server;
                    if ([server isEqualToString:@"QQ"]) {
                        [self clickBtn:self.qqBtn];
                    } else {
                        [self clickBtn:self.wechatBtn];
                    }
                }
                NSNumber * device = self.item.device;
                if (device.integerValue == 2) {
                    [self clickBtn:self.iphoneBtn];
                } else {
                    [self clickBtn:self.androidBtn];
                }
                if ([HNUBZUtil checkStrEnable:self.item.gamer]) {
                    self.roleTf.text = self.item.gamer;
                }
                [self checkEnsureBtn];
            }
        }
            break;
        case 4:
        {
            [self.selectView addSubview:self.roleTf];
            self.roleTf.placeholder = @"输入lol召唤师昵称，请注意大小写";
            [self.roleTf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.mas_equalTo(self.selectView).offset(16);
                make.right.mas_equalTo(self.selectView).offset(-16);
                make.height.mas_equalTo(30);
            }];
            UIView * line = [UIView new];
            line.backgroundColor = [UIColor colorWithWhite:112/255.0 alpha:0.1];
            [self.selectView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.roleTf.mas_bottom).offset(10);
                make.height.mas_equalTo(1);
                make.left.right.mas_equalTo(self.roleTf);
            }];
            self.selectViewHeightConst.constant = 84;
            [self.view layoutIfNeeded];
            if (self.item) {
                if ([HNUBZUtil checkStrEnable:self.item.gamer]) {
                    self.roleTf.text = self.item.gamer;
                }
                [self checkEnsureBtn];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - 懒加载
-(UITextField *)roleTf
{
    if (_roleTf) {
        return _roleTf;
    }
    _roleTf = [UITextField new];
    _roleTf.font = [UIFont systemFontOfSize:14];
    _roleTf.textColor = kTitleColor;
    _roleTf.delegate = self;
    _roleTf.clearButtonMode = UITextFieldViewModeAlways;
    [_roleTf addTarget:self action:@selector(tfValueChanged) forControlEvents:UIControlEventEditingChanged];
    _roleTf.returnKeyType = UIReturnKeyDone;
    return _roleTf;
}
-(KKSelectButton *)androidBtn
{
    if (_androidBtn) {
        return _androidBtn;
    }
    KKSelectButton * btn = [KKSelectButton buttonWithType:UIButtonTypeCustom];
    [btn configurateTitleUi];
    [btn setTitle:@"    安卓" forState:UIControlStateNormal];
    [btn configurateImageUi];
    [btn setImage:[UIImage imageNamed:@"androidGreen"] forState:UIControlStateNormal];
    btn.tag = 0;
    btn.selected = NO;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _androidBtn = btn;
    return _androidBtn;
}
-(KKSelectButton *)iphoneBtn
{
    if (_iphoneBtn) {
        return _iphoneBtn;
    }
    KKSelectButton * btn = [KKSelectButton buttonWithType:UIButtonTypeCustom];
    [btn configurateImageUi];
    [btn setImage:[UIImage imageNamed:@"iphoneGray"] forState:UIControlStateNormal];
    [btn configurateTitleUi];
    [btn setTitle:@"    iPhone" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = 1;
    btn.selected = NO;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _iphoneBtn = btn;
    return _iphoneBtn;
}
-(KKSelectButton *)wechatBtn
{
    if (_wechatBtn) {
        return _wechatBtn;
    }
    KKSelectButton * btn = [KKSelectButton buttonWithType:UIButtonTypeCustom];
    [btn configurateImageUi];
    [btn setImage:[UIImage imageNamed:@"wechatGreen"] forState:UIControlStateNormal];
    [btn configurateTitleUi];
    [btn setTitle:@"    微信" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = 2;
    btn.selected = NO;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _wechatBtn = btn;
    return _wechatBtn;
}
-(KKSelectButton *)qqBtn
{
    if (_qqBtn) {
        return _qqBtn;
    }
    KKSelectButton * btn = [KKSelectButton buttonWithType:UIButtonTypeCustom];
    [btn configurateImageUi];
    [btn setImage:[UIImage imageNamed:@"qqBlue"] forState:UIControlStateNormal];
    [btn configurateTitleUi];
    [btn setTitle:@"    QQ" forState:UIControlStateNormal];
    btn.selected = NO;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = 3;
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _qqBtn = btn;
    return _qqBtn;
}
-(UILabel *)duanweiLabel
{
    if (_duanweiLabel) {
        return _duanweiLabel;
    }
    _duanweiLabel = [UILabel new];
    _duanweiLabel.textColor = kSubtitleColor;
    _duanweiLabel.font = [UIFont systemFontOfSize:14];
    _duanweiLabel.text = @"段位信息";
    return _duanweiLabel;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)tfValueChanged {
    [self checkEnsureBtn];
}
- (void)receiveBindAccountResult:(NSNotification *)noti
{
    [KKAlert dismissWithView:self.view];
    NSDictionary * dic = noti.userInfo;
    /*
     {"payload":{"accountid":"account.24d3ed846d02456f8e40d48c2005608d","gamer":"BeiJing_XianEr","gamerank":"1543.84"},"status":0}
     */
    NSNumber * status = dic[@"status"];
    if (status.integerValue == 0) {
        NSDictionary * dict = dic[@"payload"];
        [self addEnsureViewWithDic:dict];
    } else {
        [KKAlert showText:dic[@"msg"] toView:self.view];
    }
}
- (void)addEnsureViewWithDic:(NSDictionary *)dic
{
    if (dic[@"gamer"]) {
        self.roleTf.text = dic[@"gamer"];
    }
    KKAlertViewStyleTips * hintView = [KKAlertViewStyleTips sharedAlertViewStyleTips];
    hintView.frame = self.view.bounds;
    [self.view addSubview:hintView];
    [self assginHintView:hintView];
    hintView.clickBtmBtnBlock = ^{
        NSMutableDictionary * para = @{@"gamer":dic[@"gamer"],@"region":@"pc-as",@"device":@3,@"server":@"亚服",@"ext":@""}.mutableCopy;
        [KKAlert showAnimateWithText:nil toView:self.view];
        NSNumber * gameId = [NSNumber numberWithInteger:self.gameId];
        [KKNetTool ensureBindGameWithPara:para Gameid:gameId SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismissWithView:self.view];
            [KKAlert showText:@"绑定账号成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.bindBlock) {
                self.bindBlock();
            }
        } erreorBlock:^(NSError *error) {
            [KKAlert dismissWithView:self.view];
            if ([error isKindOfClass:[NSString class]]) {
                [KKAlert showText:(NSString *)error toView:self.view];
            }
        }];
    };
}

//王者荣耀段位数组，只有王者荣耀有这个
-(NSArray *)duanweiArr
{
    if (_duanweiArr == nil) {
        _duanweiArr = @[@"最强王者",@"至尊星耀",@"永恒钻石",@"尊贵铂金",@"荣耀黄金",@"秩序白银",@"倔强青铜"];
    }
    return _duanweiArr;
}

- (void)clickBtn:(KKSelectButton *)sender {
    if (sender.selected) {
        return;
    }
    switch (sender.tag) {
        case 0:
        {
            sender.selected = YES;
            self.zhongduan = 0;
            if (self.iphoneBtn.selected) {
                self.iphoneBtn.selected = NO;
            }
        }
            break;
        case 1:
        {
            sender.selected = YES;
            self.zhongduan = 1;
            if (self.androidBtn.selected) {
                self.androidBtn.selected = NO;
            }
        }
            break;
        case 2:
        {
            sender.selected = YES;
            self.pingtai = 0;
            if (self.qqBtn.selected) {
                self.qqBtn.selected = NO;
            }
        }
            break;
        case 3:
        {
            sender.selected = YES;
            self.pingtai = 1;
            if (self.wechatBtn.selected) {
                self.wechatBtn.selected = NO;
            }
        }
            break;
        default:
            break;
    }
    [self checkEnsureBtn];
}
- (void)checkEnsureBtn{
    switch (_gameId) {
        case 1:
        {
            if (self.roleTf.text.length > 0) {
                self.ensureBtn.userInteractionEnabled = YES;
            } else {
                self.ensureBtn.userInteractionEnabled = NO;
            }
        }
            break;
        case 2:
        {
            if (self.zhongduan < 2 && self.pingtai < 2 && self.roleTf.text.length && self.duanwei && self.duanwei.length) {
                self.ensureBtn.userInteractionEnabled = YES;
            } else {
                self.ensureBtn.userInteractionEnabled = NO;
            }
        }
            break;
        case 3:
        {
            if (self.zhongduan < 2 && self.pingtai < 2 && self.roleTf.text.length) {
                self.ensureBtn.userInteractionEnabled = YES;
            } else {
                self.ensureBtn.userInteractionEnabled = NO;
            }
        }
            break;
        case 4:
        {
            if (self.roleTf.text.length > 0) {
                self.ensureBtn.userInteractionEnabled = YES;
            } else {
                self.ensureBtn.userInteractionEnabled = NO;
            }
        }
            break;
        default:
        {
        }
            break;
    }
    
}
- (void)clickDuanweiControl:(id)sender {
    [self.view endEditing:YES];
    [self showPicker];
}
- (IBAction)clickEnsureBtn:(id)sender {
    [self showHintView];
//    BOOL shouldUpdate = [self checkUpdateAccount];
//    if (shouldUpdate) {
//
//    }
//    if (self.accountDic) {
////        if (self.gameId == KKGameTypeWangzheRY) {
////
////        }
////        NSString * role = self.roleTf.text;
////        NSString * ser = self.pingtai == 0 ? @"微信":@"QQ";
////        NSNumber * dev = self.zhongduan == 0 ? @1:@2;
////        NSNumber * gameId = [NSNumber numberWithInteger:self.gameId];
////        NSString * ext = gameId.integerValue == 2? self.duanwei:@"";
//        //有数据是更新账号
//        [self showHintView];
//        return;
//    }
//    //直接绑定
//    [self bindAccount];
}
#pragma mark - 检测是否是更新账号
-(BOOL)checkUpdateAccount
{
    if (self.item == nil) {
        return false;
    }
    NSString * role = self.roleTf.text;
    NSString * gamer = self.item.gamer;
    if (![role isEqualToString:gamer]) {
        return true;
    }
    if (self.gameId == KKGameTypeWangzheRY || self.gameId == KKGameTypeCijiZC) {
        NSNumber * dev = self.zhongduan == 0 ? @1:@2;
        NSNumber * device = self.item.device;
        if (![dev isEqual:device]) {
            return true;
        }
        NSString * ser = self.pingtai == 0 ? @"微信":@"QQ";
        NSString * server = self.item.server;
        if (![ser isEqualToString:server]) {
            return true;
        }
        return false;
    }
    return false;
}
//绑定账号
- (void)bindAccount
{
    if (self.gameId == KKGameTypeJuediQS) {
        [self bindJDQS];
        return;
    }
    [self bindWZRY];
}
//弹出提示弹窗
- (void)showHintView
{
    KKAlertViewStyleTips * hintView = [KKAlertViewStyleTips sharedAlertViewStyleTips];
    hintView.frame = self.view.bounds;
    [self.view addSubview:hintView];
    [self assginHintView:hintView];
    hintView.clickBtmBtnBlock = ^{
        [self bindAccount];
    };
}
- (void)assginHintView:(KKAlertViewStyleTips *)tips
{
    BOOL isUpdate = [self checkUpdateAccount];
    switch (self.gameId) {
        case KKGameTypeJuediQS:
        {
            KKBindItemView * itemView = [KKBindItemView new];
            [tips.contentView addSubview:itemView];
            itemView.tipsLabel.text = @"游戏ID";
            NSString * role = self.roleTf.text;
            itemView.contentLabel.text = role;
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(tips.contentView);
                make.height.mas_equalTo(44);
            }];
            tips.contentViewHeight.constant = 44;
            [tips layoutIfNeeded];
        }
            break;
        case KKGameTypeWangzheRY:
        {
            NSString * role = self.roleTf.text;
            NSString * ser = self.pingtai == 0 ? @"微信":@"QQ";
            NSString * dev = self.zhongduan == 0 ? @"安卓":@"iPhone";
            NSString * ext = self.duanwei;
            NSArray * arr = @[@{@"title":@"设备:",@"content":dev},@{@"title":@"平台:",@"content":ser},@{@"title":@"游戏ID:",@"content":role},@{@"title":@"段位:",@"content":ext}];
            for (int i = 0; i < 4; i ++) {
                NSDictionary * dic = arr[i];
                KKBindItemView * itemView = [KKBindItemView new];
                [tips.contentView addSubview:itemView];
                itemView.tipsLabel.text = dic[@"title"];
                itemView.contentLabel.text = dic[@"content"];
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(tips.contentView);
                    make.height.mas_equalTo(44);
                    make.top.mas_equalTo(tips.contentView).offset(44 * i);
                }];
            }
            tips.contentViewHeight.constant = 44 * 4;
            [tips layoutIfNeeded];
        }
            break;
        case KKGameTypeCijiZC:
        {
            NSString * role = self.roleTf.text;
            NSString * ser = self.pingtai == 0 ? @"微信":@"QQ";
            NSString * dev = self.zhongduan == 0 ? @"安卓":@"iPhone";
            NSArray * arr = @[@{@"title":@"设备:",@"content":dev},@{@"title":@"平台:",@"content":ser},@{@"title":@"游戏ID:",@"content":role}];
            for (int i = 0; i < 3; i ++) {
                NSDictionary * dic = arr[i];
                KKBindItemView * itemView = [KKBindItemView new];
                [tips.contentView addSubview:itemView];
                itemView.tipsLabel.text = dic[@"title"];
                itemView.contentLabel.text = dic[@"content"];
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(tips.contentView);
                    make.height.mas_equalTo(44);
                    make.top.mas_equalTo(tips.contentView).offset(44 * i);
                }];
            }
            tips.contentViewHeight.constant = 44 * 3;
            [tips layoutIfNeeded];
        }
            break;
        case KKGameTypeYingxiongLM:
        {
            KKBindItemView * itemView = [KKBindItemView new];
            [tips.contentView addSubview:itemView];
            itemView.tipsLabel.text = @"游戏ID";
            NSString * role = self.roleTf.text;
            itemView.contentLabel.text = role;
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(tips.contentView);
                make.height.mas_equalTo(44);
            }];
            tips.contentViewHeight.constant = 44;
            [tips layoutIfNeeded];
        }
            break;
        default:
            break;
    }
    if (isUpdate == false) {
        tips.subtitleLabel.text = @"以上为您的正确游戏账号信息，信息有偏差则直接判输。";
    } else {
        NSString * str = @"以上为您的正确游戏账号信息，信息有偏差则直接判输，若修改成功24小时内不可再次修改。";
        NSRange r = [str rangeOfString:@"24小时内"];
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrStr addAttributes:@{NSForegroundColorAttributeName:kOrangeColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} range:r];
        tips.subtitleLabel.attributedText = attrStr;
    }
}
- (void)showPicker
{
    KKSelectPicker * picker = [KKSelectPicker sharedSelectPicker];
    picker.pickerView.delegate = self;
    picker.pickerView.dataSource = self;
    picker.ensureBlock = ^(NSInteger index) {
        self.duanwei = self.duanweiArr[index];
        [self checkEnsureBtn];
        self.duanweiLabel.text = self.duanwei;
        self.duanweiLabel.textColor = [UIColor colorWithHexString:@"14191e"];
        [[KKDataTool shareTools] destroyAlertWindow];
    };
    picker.cancelBlock = ^{
        [[KKDataTool shareTools] destroyAlertWindow];
    };
    if (self.duanwei) {
        if ([self.duanweiArr containsObject:self.duanwei]) {
            NSInteger index = [self.duanweiArr indexOfObject:self.duanwei];
            [picker.pickerView selectRow:index inComponent:0 animated:NO];
        }
    }
}
//绑定绝地求生，英雄联盟有接口的游戏
- (void)bindJDQS
{
    NSString * role = self.roleTf.text;
    if (self.item) {
        if ([role isEqualToString:self.item.gamer]) {
            [KKAlert showText:@"您未做任何修改" toView:self.view];
            return;
        }
    }
    //把账号名称发给后台，后台查询到账号信息之后发通知
    [KKAlert showText:@"账号信息查询中" toView:self.view];
    NSDictionary * para = @{@"gamer":role,@"region":@"pc-as",@"device":@3,@"server":@"亚服",@"ext":@""};
    NSNumber * gameId = [NSNumber numberWithInteger:self.gameId];
    [KKNetTool bindGameWithPara:para Gameid:gameId SuccessBlock:^(NSDictionary *dic) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            [KKAlert dismissWithView:self.view];
            [KKAlert showText:@"数据格式错误" toView:self.view];
            return;
        }
        NSNumber * code = dic[@"c"];
        if (code.integerValue == 0) {
            //绝地求生等待查询成功通知,等ws通知
        } else if (code.integerValue == 20019){
            //            {"c":20019,"d":86387,"m":"无法再次修改绑定"}，显示倒计时
            [KKAlert dismissWithView:self.view];
            NSNumber * time = dic[@"d"];
            if (time.integerValue <= 0) {
                [KKAlert showText:dic[@"m"] toView:self.view];
                return;
            }
            [self addTimerWithTime:time.integerValue];
        } else {
            [KKAlert dismissWithView:self.view];
            NSString * msg = dic[@"m"];
            [KKAlert showText:msg toView:self.view];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:self.view];
    }];//绑定某个游戏
}
//绑定无接口的游戏
- (void)bindWZRY
{
    NSString * role = self.roleTf.text;
    NSString * ser = self.pingtai == 0 ? @"微信":@"QQ";
    NSNumber * dev = self.zhongduan == 0 ? @1:@2;
    NSNumber * gameId = [NSNumber numberWithInteger:self.gameId];
    if (self.gameId == KKGameTypeWangzheRY) {
        if (![HNUBZUtil checkStrEnable:self.duanwei]) {
            [KKAlert showText:@"请选择段位" toView:self.view];
            return;
        }
    }
    NSString * ext = gameId.integerValue == 2? self.duanwei:@"";
    NSDictionary * para = @{@"gamer":role,@"region":@"国服",@"device":dev,@"server":ser,@"ext":ext};
    [KKAlert showAnimateWithText:@"账号绑定中" toView:self.view];
    [KKNetTool bindGameWithPara:para Gameid:gameId SuccessBlock:^(NSDictionary *dic) {
        [KKAlert dismissWithView:self.view];
        if (![dic isKindOfClass:[NSDictionary class]]) {
            [KKAlert showText:@"数据格式错误" toView:self.view];
            return;
        }
        NSNumber * code = dic[@"c"];
        if (code.integerValue == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            [KKAlert showText:@"绑定账号成功" toView:self.view];
            if (self.bindBlock) {
                self.bindBlock();
            }
        } else if (code.integerValue == 20019){
//            {"c":20019,"d":86387,"m":"无法再次修改绑定"}，显示倒计时
            NSNumber * time = dic[@"d"];
            if (time.integerValue <= 0) {
                [KKAlert showText:dic[@"m"] toView:self.view];
                return;
            }
            [self addTimerWithTime:time.integerValue];
        } else {
            NSString * msg = dic[@"m"];
            [KKAlert showText:msg toView:self.view];
        }
    } erreorBlock:^(NSError *error) {
        [KKAlert dismissWithView:self.view];
    }];//绑定某个游戏
}
#pragma mark - 添加24小时提示倒计时
- (void)addTimerWithTime:(NSInteger)time
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    KKChampionshipHintView * hintView = [KKChampionshipHintView shareChampionshipHintView];
    hintView.frame = [UIScreen mainScreen].bounds;
    hintView.titleLabel.text = @"锁定倒计时";
    [hintView.ensureBtn setTitle:@"锁定时间结束后可修改游戏账号信息" forState:UIControlStateNormal];
    hintView.titleLabel.font = [UIFont systemFontOfSize:(ScreenWidth == 320?12:15)];
    [hintView.ensureBtn setTitleColor:[UIColor colorWithWhite:153/255.0 alpha:1] forState:UIControlStateNormal];
    hintView.ensureBtn.userInteractionEnabled = NO;
    hintView.subtitleLabel.textColor = kThemeColor;
    hintView.subtitleLabel.font = [UIFont fontWithName:@"Bahnschrift" size:36];
    [self.view addSubview:hintView];
    hintView.cancelBlock = ^{
        if (self->_timer) {
            dispatch_source_cancel(self->_timer);
            self->_timer = nil;
        }
    };
    __block NSInteger t = time;
    dispatch_source_set_event_handler(_timer, ^{
        --t;
        dispatch_main_async_safe(^{
             hintView.subtitleLabel.text = [KKDataTool timeStrWithSeconds:t];
        })
        if (t <= 0) {
            if (self->_timer) {
                dispatch_source_cancel(self->_timer);
                self->_timer = nil;
            }
            [hintView removeFromSuperview];
        }
    });
    dispatch_resume(_timer);
}
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.duanweiArr.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.duanweiArr[row];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
