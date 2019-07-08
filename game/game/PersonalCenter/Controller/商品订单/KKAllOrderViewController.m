//
//  KKAllOrderViewController.m
//  game
//
//  Created by GKK on 2018/8/29.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKAllOrderViewController.h"
#import "KKOrderTableViewCell.h"
@interface KKAllOrderViewController ()

@end

@implementation KKAllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuse = @"orderCell";
    KKOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [KKOrderTableViewCell shareCell];
    }
    [cell assignWithType:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 164;
}

@end
