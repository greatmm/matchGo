//
//  KKBaseMessageViewController.m
//  game
//
//  Created by GKK on 2018/10/26.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseMessageViewController.h"
#import "KKNotiMessageListViewController.h"

@interface KKBaseMessageViewController ()

@end

@implementation KKBaseMessageViewController

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
