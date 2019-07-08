//
//  KKExplainViewController.m
//  game
//
//  Created by greatkk on 2018/12/14.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKExplainViewController.h"

@interface KKExplainViewController ()<UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView * scrollView;
@property (strong,nonatomic) UIImageView * imgView;
@end

@implementation KKExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addViews];
    if (self.image) {
        self.imgView.image = self.image;
        CGFloat rate = self.image.size.height/self.image.size.width;
        CGFloat h = ScreenWidth * rate;
        self.imgView.frame = CGRectMake(0, 0, ScreenWidth, h);
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, h);
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addViews
{
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.right.left.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self.view);
        }];
    }
    self.imgView = [UIImageView new];
    [self.scrollView addSubview:self.imgView];
}
@end
