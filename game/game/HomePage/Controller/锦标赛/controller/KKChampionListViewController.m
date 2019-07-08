//
//  KKChampionListViewController.m
//  game
//
//  Created by greatkk on 2018/12/27.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKChampionListViewController.h"
#import "KKChampionCollectionViewCell.h"
#import "KKChampionListModel.h"
#import "KKChampionshipViewController.h"

static NSString * const reuse = @"reuse";
@interface KKChampionListViewController()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong,nonatomic) UICollectionView * cv;
@end
@implementation KKChampionListViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"锦标赛";
    [self.cv reloadData];
}
-(UICollectionView *)cv
{
    if (_cv) {
        return _cv;
    }
    UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    layout.itemSize = CGSizeMake(ScreenWidth, 64 + (ScreenWidth - 32) * 153/343);
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    _cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _cv.delegate = self;
    _cv.dataSource = self;
    _cv.backgroundColor = kBackgroundColor;
    _cv.alwaysBounceVertical = true;
    [self.view addSubview:_cv];
    if (@available(iOS 11.0, *)) {
        _cv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_cv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [_cv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(self.view);
        }];
    }
    [_cv registerClass:[KKChampionCollectionViewCell class] forCellWithReuseIdentifier:reuse];
    return _cv;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    KKChampionCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    cell.isBig = YES;
    [cell assignWithItem:self.championArr[indexPath.row]];
    return cell;
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.championArr.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KKChampionListModel * model = self.championArr[indexPath.row];
    [KKHouseTool enterChampionWihtCid:model.cid];
}

@end
