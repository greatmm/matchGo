//
//  KKHomeGameCollectionViewCell.m
//  game
//
//  Created by GKK on 2018/8/14.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKHomeGameCollectionViewCell.h"
#import "KKGameCollectionViewCell.h"
#import "GameItem.h"
#import "KKSupeiDetailViewController.h"
#import "KKChampionCollectionViewCell.h"
#import "KKChampionListViewController.h"

@interface KKHomeGameCollectionViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation KKHomeGameCollectionViewCell
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.cv registerClass:[KKChampionCollectionViewCell class] forCellWithReuseIdentifier:@"championCell"];
}
-(void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    [self.cv reloadData];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataArr) {
        return self.dataArr.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuse = @"championCell";
    KKChampionCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    [cell assignWithItem:self.dataArr[indexPath.row]];
    return cell;
    /*
    static NSString * reuse = @"game";
    KKGameCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    GameItem * item = self.dataArr[indexPath.row];
    cell.nameLabel.text = item.gameName;
    NSDictionary * dict = @{@"英雄联盟":@"LOLGameIcon",@"绝地求生":@"PUBGGameIcon",@"王者荣耀":@"GKGameIcon",@"刺激战场":@"ZCGameIcon"};
    NSString * imgName = dict[item.gameName];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:[UIImage imageNamed:imgName]];
    return cell;
     */
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (ScreenWidth - 32)/2 - 10;
    return CGSizeMake(width, 71 + width * 153/343.0);
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsZero;
//}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 10);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KKChampionListModel * model = self.dataArr[indexPath.row];
//#ifdef kkDEBUGEnvironment
//[KKHouseTool enterChampionWihtCid:@(77)];
//                #else
    [KKHouseTool enterChampionWihtCid:model.cid];
//#endif

    return;
    UIViewController * v = [self viewController];
    if ([KKDataTool token] == nil) {
//        UINavigationController * nc = [[UIStoryboard storyboardWithName:@"KKLogin" bundle:nil] instantiateInitialViewController];
//        [v.navigationController presentViewController:nc animated:YES completion:nil];
        return;
    }
    KKSupeiDetailViewController * vc = [[UIStoryboard storyboardWithName:@"KKHomepage" bundle:nil] instantiateViewControllerWithIdentifier:@"supeiDetail"];
    [KKDataTool shareTools].gameItem = self.dataArr[indexPath.row];
    [v.navigationController pushViewController:vc animated:YES];
}
@end
