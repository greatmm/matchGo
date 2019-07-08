//
//  KKHelpViewController.m
//  game
//
//  Created by GKK on 2018/10/26.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKHelpViewController.h"
#import "KKFeedbackViewController.h"
#import "KKAppealViewController.h"
#import "KKExplainViewController.h"
#warning todo 缺：点击cell的效果  QQ客服
@interface KKHelpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray * titleArr;
@end

@implementation KKHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助中心";
    self.tableView.tableFooterView = [UIView new];
    self.titleArr = @[@"绑定角色游戏",@"怎么玩锦标赛",@"怎么玩1V1挑战赛",@"怎么发布对战",@"怎么玩对战赛",@"钻石获得使用",@"金币获得使用",@"金币获得使用"];
    self.houseBtm = isIphoneX?(34 + 59):(59);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"helpCell" forIndexPath:indexPath];
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4) {
        NSArray * imgs = @[@"championExplain.png",@"pipeiExplain.png",@"",@"matchExplain.png"];
        NSArray * titles = @[@"怎么玩锦标赛",@"怎么玩1V1挑战赛",@"",@"怎么玩对战赛"];
        KKExplainViewController * explainVc = [KKExplainViewController new];
        explainVc.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgs[indexPath.row - 1] ofType:nil]];
        [self.navigationController pushViewController:explainVc animated:YES];
        explainVc.navigationItem.title = titles[indexPath.row - 1];
    }
   
}
- (IBAction)clickBtmControl:(UIView *)sender {
    NSInteger tag = sender.tag;
    if (tag == 1) {
        KKFeedbackViewController * vc = [[UIStoryboard storyboardWithName:@"KKPersonal" bundle:nil] instantiateViewControllerWithIdentifier:@"feedbackVc"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        //唤起QQ聊天
    }
}

@end
