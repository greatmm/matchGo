//
//  KKSmallShopCollectionViewCell.m
//  game
//
//  Created by GKK on 2018/9/7.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKSmallShopCollectionViewCell.h"
#import "KKSmallMallShopCollectionViewCell.h"
static NSString * const reuse = @"mallShopCell";
@interface KKSmallShopCollectionViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation KKSmallShopCollectionViewCell
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.cv registerClass:[KKSmallMallShopCollectionViewCell class] forCellWithReuseIdentifier:reuse];
}
-(void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    [self.cv reloadData];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KKSmallMallShopCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    NSDictionary * dic = self.dataArr[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:dic[@"imgName"]];
    cell.desLabel.text = dic[@"des"];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataArr) {
        return self.dataArr.count;
    }
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (ScreenWidth - 72)/3;
    CGFloat h = w * 129/104.0 + 70;
    return CGSizeMake(w, h);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

@end
