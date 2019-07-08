//
//  KKBaseTableViewController.m
//  minsu

#import "KKBaseTableViewController.h"

@interface KKBaseTableViewController ()

@end

@implementation KKBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.houseBtm = isIphoneX?34:0;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if ([[KKDataTool shareTools] wVc] || [[KKDataTool shareTools] showWVc]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"btmHeightChanged" object:nil userInfo:@{@"btmH":[NSNumber numberWithFloat:_houseBtm]}];
////        NSLog(@"%@发出了通知高度为--%f",[self class],self.houseBtm);
//    }
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (void)dealloc
{
    KKLog(@"--%@--dealloc",[self class]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
