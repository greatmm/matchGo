//
//  KKActionMessageListTableViewController.m
//  game
//
//  Created by GKK on 2018/10/25.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKActionMessageListTableViewController.h"
#import "KKActionMessageTableViewCell.h"
@interface KKActionMessageListTableViewController ()

@end
static NSString * const reuse = @"actionMessageCell";

@implementation KKActionMessageListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 120;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = nil;
    [self.tableView registerNib:[UINib nibWithNibName:@"KKActionMessageTableViewCell" bundle:nil] forCellReuseIdentifier:reuse];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKActionMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    return cell;
}

@end
