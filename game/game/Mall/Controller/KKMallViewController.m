//
//  KKMallViewController.m
//  game
//
//  Created by GKK on 2018/8/23.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKMallViewController.h"
//#import "KKMallItemCollectionViewCell.h"
#import "KKShopCollectionViewCell.h"
#import "KKShopCollectionReusableView.h"
#import "KKSmallShopCollectionViewCell.h"
#import "KKMallTopCollectionViewCell.h"
#import "KKShopListViewController.h"
#import "KKShopDetailViewController.h"
@interface KKMallViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *cv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConst;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *rigBtn;
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UITextField *tf;

@end

@implementation KKMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.houseBtm = [KKDataTool tabBarH];
    self.navigationController.navigationBar.hidden = YES;
    [self.cv registerClass:[KKShopCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"shopHeader"];
    [self.cv registerNib:[UINib nibWithNibName:@"KKMallTopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"topCell"];
    if ([KKDataTool statusBarH] == 20) {
        self.topConst.constant = -20;
    }
    [self.tf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        KKMallTopCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topCell" forIndexPath:indexPath];
        return cell;
    }
    if (indexPath.section%2 == 0) {
        KKSmallShopCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"smallShop" forIndexPath:indexPath];
        if (indexPath.section == 2) {
            cell.dataArr = @[@{@"imgName":@"shopsmall",@"des":@"鹿晗\n签名照片"},@{@"imgName":@"shopsmall1",@"des":@"情人节限定\n洛手机壳"},@{@"imgName":@"shopsmall2",@"des":@"青莲剑仙\n李白抱枕"},@{@"imgName":@"shopsmall3",@"des":@"情人节限定\n洛手机壳"}];
        } else {
            cell.dataArr = @[@{@"imgName":@"shopsmall4",@"des":@"闪耀羽裳\n洛幸运珠"},@{@"imgName":@"shopsmall5",@"des":@"铁血都督\n周瑜手办"},@{@"imgName":@"shopsmall6",@"des":@"2018MSI\n铁血都督"},@{@"imgName":@"shopsmall7",@"des":@"铁血都督\n背包背包"}];
        }
        return cell;
    }
    KKShopCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shopCell" forIndexPath:indexPath];
    NSArray * arr;
    if (indexPath.section == 1) {
        arr = @[@{@"imgName":@"shop",@"des":@"2018RNG\n队服外套\nRNG剑指总冠军"},@{@"imgName":@"shop1",@"des":@"英雄联盟\n炸弹人吉格斯\n大型手办 限量款"}];
    } else {
       arr = @[@{@"imgName":@"shop2",@"des":@"VIVO旗舰\nX23全面屏手机\n发现更多美"},@{@"imgName":@"shop3",@"des":@"TFBoys\n5周年纪念书籍\n易烊千玺签名"}];
    }
    NSDictionary * dic = arr[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:dic[@"imgName"]];
    cell.desLabel.text = dic[@"des"];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section%2 != 0) {
        return 2;
    }
    return 1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return CGSizeMake(ScreenWidth, ScreenWidth * 450/375.0 + 102);
    }
    if (indexPath.section%2 != 0) {
        CGFloat w = (ScreenWidth - 30) * 0.5;
        CGFloat h = w * 206/172.0 + 110;
        return CGSizeMake(w, h);
    }
    CGFloat w = (ScreenWidth - 72)/3;
    CGFloat h = w * 129/104.0 + 70;
    return CGSizeMake(ScreenWidth, h);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section%2 != 0) {
       return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(ScreenWidth, 60);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return nil;
    }
    KKShopCollectionReusableView * reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"shopHeader" forIndexPath:indexPath];
    [reusableView addSubview:reusableView.titleLabel];
    reusableView.titleLabel.text = indexPath.section%2== 0 ? @"为你推荐":@"热门单品";
    return reusableView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 || indexPath.section == 3) {
        KKShopDetailViewController * shopVC = [[UIStoryboard storyboardWithName:@"KKMall" bundle:nil] instantiateViewControllerWithIdentifier:@"shopDetail"];
        [self.navigationController pushViewController:shopVC animated:YES];
        return;
    }
//    if (indexPath.section == 3) {
//        return;
//    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.cv) {
        CGFloat offsetY = scrollView.contentOffset.y;
//        CGFloat y = ScreenWidth * 450/375.0;
        CGFloat y = 64;
        if (offsetY > y) {
            self.navView.backgroundColor = [UIColor whiteColor];
            UIView * bacView = self.tf.superview;
            bacView.backgroundColor = [UIColor colorWithWhite:246/255.0 alpha:1];
            [self.rigBtn setImage:[UIImage imageNamed:@"email_black"] forState:UIControlStateNormal];
            self.searchImageView.image = [UIImage imageNamed:@"search_black"];
            self.tf.textColor = [UIColor colorWithWhite:33/255.0 alpha:1];
            [self.tf setValue:[UIColor colorWithWhite:33/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        } else {
            self.navView.backgroundColor = [UIColor clearColor];
            UIView * bacView = self.tf.superview;
            bacView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.38];
            [self.rigBtn setImage:[UIImage imageNamed:@"email_white"] forState:UIControlStateNormal];
            self.searchImageView.image = [UIImage imageNamed:@"search_white"];
            self.tf.textColor = [UIColor whiteColor];
            [self.tf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
    }
}
@end
