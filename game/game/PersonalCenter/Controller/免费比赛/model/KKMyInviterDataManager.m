//
//  KKMyInviterDataManager.m
//  game
//
//  Created by greatkk on 2019/1/16.
//  Copyright © 2019 MM. All rights reserved.
//

#import "KKMyInviterDataManager.h"

@implementation KKMyInviterDataManager
- (void)checkWithResponse:(id)responseObjectData
{
    if ([HNUBZUtil checkDictEnable:responseObjectData]) {
        self.total = responseObjectData[@"total"];
        self.sum_tickets = responseObjectData[@"sum_tickets"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFreeMatchTickets object:nil userInfo:@{@"total":self.total,@"sum_tickets":self.sum_tickets}];
    }
    [self.array_main addObjectsFromArray:self.modelForLoading.arrayOutput];
}
-(Class)getCellClassWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.array_main.count == 0) {
        return [UITableViewCell class];
    }
    return [super getCellClassWithIndexPath:indexPath];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.array_main.count == 0) {
        return 1;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.array_main.count == 0) {
        static NSString * const reuse = @"iden";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
            cell.textLabel.textColor = k153Color;
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"您当前还没有邀请好友，赶快去邀请吧!";
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
@end
