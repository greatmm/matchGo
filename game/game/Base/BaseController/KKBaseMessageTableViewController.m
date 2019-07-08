//
//  KKBaseMessageTableViewController.m
//  game
//
//  Created by greatkk on 2018/11/13.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseMessageTableViewController.h"
#import "KKNotiMessageListViewController.h"

@interface KKBaseMessageTableViewController ()

@end

@implementation KKBaseMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"letter"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLetter)];
}
- (void)clickLetter
{
    kkLoginMacro
//    KKMessageViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"messageVC"];
    KKNotiMessageListViewController * vc = [KKNotiMessageListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
