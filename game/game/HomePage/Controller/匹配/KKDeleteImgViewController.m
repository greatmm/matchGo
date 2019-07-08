//
//  KKDeleteImgViewController.m
//  game
//
//  Created by greatkk on 2018/12/13.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKDeleteImgViewController.h"
#import "KKDeleteImgCollectionViewCell.h"
@interface KKDeleteImgViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic) UIView * topView;

@property (strong,nonatomic) UILabel * titleLabel;

@property (strong,nonatomic) UICollectionView * collectionView;

@end

static NSString * const reuseIdentifier = @"Cell";

@implementation KKDeleteImgViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSubviews];
    self.view.backgroundColor = [UIColor blackColor];
    self.currectIndex = _currectIndex;
    [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.collectionView.bounds) * self.currectIndex, 0) animated:YES];
}
- (void)addSubviews
{
    self.topView = [UIView new];
    self.topView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo([KKDataTool statusBarH] + 44);
    }];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [self.topView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.left.mas_equalTo(self.topView).offset(10);
        make.bottom.mas_equalTo(self.topView).offset(-7);
    }];
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setImage:[UIImage imageNamed:@"deleteWhite"] forState:UIControlStateNormal];
    [self.topView addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.right.mas_equalTo(self.topView).offset(-10);
        make.bottom.mas_equalTo(self.topView).offset(-7);
    }];
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.topView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topView);
        make.centerY.mas_equalTo(deleteBtn);
    }];
    self.titleLabel.text = @"1/1";
    [self setupCollectionViewLayout];
}
- (void)setupCollectionViewLayout {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    CGFloat y = 0;
    CGFloat b = 0;
    if (isIphoneX) {
        y = 44;
        b = 34;
    }
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, ScreenHeight - b - y) collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGFloat width = ScreenWidth;
    CGFloat margin = 20;
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = CGSizeMake(width, CGRectGetHeight(self.collectionView.bounds));
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGRect rect = self.collectionView.frame;
    rect.size.width += margin;
    self.collectionView.frame = rect;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, margin);
    [self.collectionView registerClass:[KKDeleteImgCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:self.topView];
}
-(void)setCurrectIndex:(NSInteger)currectIndex
{
    _currectIndex = currectIndex;
    if (_currectIndex < 0) {
        _currectIndex = -1;
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%d/%lu",_currectIndex + 1,(unsigned long)self.imgArr.count];
}
- (void)clickDeleteBtn
{
    [self.imgArr removeObjectAtIndex:self.currectIndex];
    if (self.imgArr.count == 0) {
        [KKAlert showText:@"已删除" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self clickBackBtn];
        });
        return;
    }
    [self.collectionView reloadData];
    self.currectIndex = [self currentIndexPath];
}
- (void)clickBackBtn
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.backBlock) {
            __weak typeof(self) weakSelf = self;
            self.backBlock(weakSelf.imgArr);
        }
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKDeleteImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imgView.image = self.imgArr[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dealTopview];
}
- (void)dealTopview
{
    CGFloat y = self.topView.mj_y;
    if (y == 0) {
        y = -1 * self.topView.mj_h;
    } else {
        y = 0;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.topView.mj_y = y;
    }];
}
- (NSInteger)currentIndexPath
{
    CGFloat x = self.collectionView.contentOffset.x;
    NSInteger row = round(x/CGRectGetWidth(self.collectionView.bounds));
    if (row < 0) {
        row = 0;
    } else if (row >= self.imgArr.count){
        row = self.imgArr.count - 1;
    }
    return row;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currectIndex = [self currentIndexPath];
}
@end
