//
//  KKHotShopViewController.m
//  game
//
//  Created by GKK on 2018/9/10.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKHotShopViewController.h"
#import "KKSmallMallShopCollectionViewCell.h"
@interface KKHotShopViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView * cv;
@end

@implementation KKHotShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cv];
    [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
}
-(UICollectionView *)cv
{
    if (_cv == nil) {
        UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        CGFloat w = (ScreenWidth - 30) * 0.5;
        CGFloat h = w * 206/172.0 + 72;
        layout.itemSize = CGSizeMake(w, h);
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_cv registerClass:[KKSmallMallShopCollectionViewCell class] forCellWithReuseIdentifier:@"hotShop"];
        _cv.delegate = self;
        _cv.dataSource = self;
        _cv.backgroundColor = [UIColor whiteColor];
    }
    return _cv;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KKSmallMallShopCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotShop" forIndexPath:indexPath];
    cell.showRight = YES;
    NSArray * arr = @[@{@"imgName":@"shop_0",@"des":@"鹿晗签名照片\n明星周边"},@{@"imgName":@"shop",@"des":@"2018RNG队服外套\n英雄联盟LPL"},@{@"imgName":@"shop_1",@"des":@"为风之恋Q版小乔手办\n王者荣耀游戏周边"},@{@"imgName":@"shop_2",@"des":@"铁血都督 周瑜手办\n王者荣耀游戏周边"}];
    NSDictionary * dic = arr[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:dic[@"imgName"]];
    cell.desLabel.text = dic[@"des"];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
