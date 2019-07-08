//
//  KKMatchViewController.m
//  game
//
//  Created by greatkk on 2018/11/22.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKMatchViewController.h"

@interface KKMatchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *gameBackImgView;//游戏背景图
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarView;//用户头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//没有匹配时显示匹配中，匹配成功之后显示用户名
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;//左侧label，显示匹配到的用户的信息，单排分数，段位等
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;//右侧label，显示匹配用户的胜率
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;//确定按钮

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;//底部进度条
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;//入场费用
@property (weak, nonatomic) IBOutlet UILabel *choiceLabel;//匹配的选项
@property (weak, nonatomic) IBOutlet UILabel *totalGoldLabel;//获胜可得多少金币
@property (weak, nonatomic) IBOutlet UIView *matchView;//匹配到对手之后显示对手的信息，匹配中时要隐藏

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *matchViewHeightCons;//正常显示158
@property (nonatomic,strong)  dispatch_source_t timer;
@property (nonatomic,assign) BOOL matching;//匹配中
@property (nonatomic,strong) NSDictionary * matchDic;//匹配结果
@property (nonatomic,strong) NSDate * beginMatchDate;//开始匹配时间，用来处理app进入后台的情况

@end

@implementation KKMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * imgArr = @[@"PUBGBigBG",@"GKBigBG",@"ZCBigBG",@"LOLBigBG"];
    self.gameBackImgView.image = [UIImage imageNamed:imgArr[[KKDataTool gameId] - 1]];
    [self addNotification];//添加通知
    [self resetBeforeBeginUI];//隐藏匹配中不显示的View
}
#pragma mark - 添加通知
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(matchSuccess:) name:kGameMatchResultSuccess object:nil];//匹配成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(matchFail:) name:kGameMatchResultFail object:nil];//匹配失败的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterGame:) name:kEnterGame object:nil];//开始比赛的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelMatch:) name:kCancelMatch object:nil];//取消比赛的通知
}
#pragma mark - 设置匹配中的UI
- (void)resetBeforeBeginUI
{
    //隐藏匹配中不显示的UI
    self.matchView.hidden = YES;
    self.progressView.progress = 1.0;
    self.matchViewHeightCons.constant = 5;
    [self.view layoutIfNeeded];
    self.matching = YES;//设置为匹配中
    [self addPipeiTimer];
    KKUser * user = [KKDataTool user];
    [self.userAvatarView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"icon"]];
}
#pragma mark - 点击关闭按钮
- (IBAction)clickCloseBtn:(id)sender {
        [KKNetTool cancelMatchWithSuccessBlock:^(NSDictionary *dic) {
        } erreorBlock:^(NSError *error) {
        }];
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    [self destorySelf];
}
#pragma mark - 取消匹配的通知
- (void)cancelMatch:(NSNotification *)noti
{
    [KKAlert showText:@"对方取消了匹配"];
    [self resetBeforeBeginUI];
}
//确认匹配
- (IBAction)clickEnsureBtn:(UIButton *)sender {
    NSNumber * uuid;
    if (self.matchDic) {
        uuid = self.matchDic[@"uuid"];
    }
    if (uuid == nil) {
        return;
    }
    sender.userInteractionEnabled = NO;
    sender.backgroundColor = [UIColor colorWithWhite:112/255.0 alpha:1];
    self.ensureBtn = sender;
    [KKNetTool ensureMatchWithUuid:uuid SuccessBlock:^(NSDictionary *dic) {
        
    } erreorBlock:^(NSError *error) {
        sender.userInteractionEnabled = YES;
        sender.backgroundColor = kThemeColor;
    }];
}
#pragma mark - 添加匹配中计时器
- (void)addPipeiTimer{
    [self destoryTimer];
    self.beginMatchDate = [NSDate date];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        NSInteger t = [[KKDataTool shareTools] getDateStamp];
        NSInteger t1 = [KKDataTool timeStampFromDate:weakSelf.beginMatchDate];
        int timeOut = (int)(t - t1 + 1);
        NSArray * arr = @[@"匹配中.",@"匹配中..",@"匹配中..."];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nickNameLabel.text = arr[timeOut%3];
        });
    });
    dispatch_resume(_timer);
}
#pragma mark - 收到匹配成功通知，更新界面添加15s倒计时
/*
 匹配成功{
 awardmax = 200;
 choice = "KDA\U5206\U6570";
 choicecode = 2;
 choicetype = 2;
 game = 2;
 gold = 100;
 timeout = 20;
 users =     (
 {
 avatar = "https://static1.ogame.app/20181023/5b5/5.png";
 gamer = "\U7f8a\U7f8a\U7f8a";
 gamerId = 62;
 gamerank = "";
 
 name = "\U7f8a\U7f8a\U7f8a";
 total = 0;
 uid = 5;
 win = 0;
 },
 {
 avatar = "https://static1.ogame.app/20181113/87f/3.png";
 gamer = "\U5927\U68a6";
 gamerId = 65;
 gamerank = "";
 name = "\U5927\U68a6";
 total = 0;
 uid = 3;
 win = 0;
 }
 );
 uuid = "a881cb62-9507-4ba5-92c3-184a834c041b";
 }
 */
- (void)matchSuccess:(NSNotification *)note
{
    NSDictionary * dic = note.userInfo;
    self.matchDic = dic;
    self.matching = NO;
    //记录匹配成功的开始时间
    self.beginMatchDate = [NSDate date];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self assignMatchSuccessUI];
        [self addResultTimerWithDic:dic];
    });
}
#pragma mark - 匹配到对手之后更新UI
- (void)assignMatchSuccessUI
{
    NSArray * users = self.matchDic[@"users"];
    if (users == nil || users.count == 0) {
        return;
    }
    self.matchViewHeightCons.constant = 158;
    [self.view layoutIfNeeded];
    //更新用户名和头像，胜率，单排分数等信息
    NSDictionary * user;
    for (NSDictionary * d in users) {
        NSNumber * uid = d[@"uid"];
        if (uid.integerValue != [KKDataTool user].userId.integerValue) {
            user = d;
            break;
        }
    }
    self.matchView.hidden = NO;
    self.nickNameLabel.text = user[@"gamer"];
    [self.userAvatarView sd_setImageWithURL:[NSURL URLWithString:user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon"]];
    //计算胜率
    NSNumber * win = user[@"win"];
    NSNumber * total = user[@"total"];
    CGFloat r = 0;
    if (total.integerValue != 0) {
        r = win.floatValue/total.floatValue;
    }
    CGFloat w = floor(r * 100);
    self.rightLabel.text = [NSString stringWithFormat:@"平台胜率:%.f%@",w,@"%"];
    
    if ([KKDataTool gameId] == 1) {
        //绝地求生，有单排分数
        self.leftLabel.text = [NSString stringWithFormat:@"单排：%@",user[@"gamerank"]];
    } else {
        NSString * gamerRank = user[@"gamerank"];
        self.leftLabel.text = [NSString stringWithFormat:@"段位:%@",gamerRank];
//        if (gamerRank && gamerRank.length > 0) {
//            self.leftLabel.text = gamerRank;
//        } else {
//            self.leftLabel.text = @"  ";
//        }
        //[KKDataTool shareTools].gameItem.gameName;
    }
    //可获得多少金币
    self.totalGoldLabel.text = [NSString stringWithFormat:@"%@",self.matchDic[@"awardmax"]];
    //需要多少报名费
    NSNumber * tickets = self.matchDic[@"gold"];
    self.feeLabel.text = [NSString stringWithFormat:@"%@",tickets];
    //匹配类型
    self.choiceLabel.text = [NSString stringWithFormat:@"%@",self.matchDic[@"choice"]];
}
#pragma mark - 匹配失败的通知，直接退出，提示错误信息
- (void)matchFail:(NSNotification *)note
{
    [self destorySelf];
    NSDictionary * dic = note.userInfo;
    NSString * msg = dic[@"msg"];
    [KKAlert showHint:msg];
}
#pragma mark - 开始比赛的通知
- (void)enterGame:(NSNotification *)noti
{
    NSDictionary * dic = noti.userInfo;
    if (self.ensureBlock) {
        self.ensureBlock(dic[@"roomid"]);
    }
    [self destorySelf];
}
#pragma mark - 添加等待确认倒计时
- (void)addResultTimerWithDic:(NSDictionary *)dic {
    [self destoryTimer];
    NSNumber * t = dic[@"timeout"];
    if (t == nil) {
        t = @60;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    int endCount = t.intValue;
    dispatch_source_set_event_handler(_timer, ^{
        int now = (int)[[KKDataTool shareTools] getDateStamp];//现在的时间
        int end = (int)[KKDataTool timeStampFromDate:self.beginMatchDate] + endCount;//结束的时间(开始的时间+倒计时时间)
        int timeout = end - now; //倒计时时间
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_async(dispatch_get_main_queue(), ^{
                [self destorySelf];
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * str = [NSString stringWithFormat:@"确定(%@s)",strTime];
                [self.ensureBtn setTitle:str forState:UIControlStateNormal];
                [self.progressView setProgress:timeout * 1.0/endCount animated:YES];
            });
        }
    });
    dispatch_resume(_timer);
}
#pragma mark - 销毁计时器
- (void)destoryTimer
{
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
#pragma mark - 销毁自己
- (void)destorySelf
{
    [self destoryTimer];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
-(void)dealloc
{
    [self destoryTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
