//
//  BZPagingScrollView.m
//  game
//
//  Created by linsheng on 2019/1/11.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "BZPagingScrollViewController.h"
@interface BZPagingScrollViewController ()


@end
@implementation BZPagingScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark set/get
- (UIView *)viewMain
{
    if (!_viewMain) {
        _viewMain=[[UIView alloc] init];
    }
    return _viewMain;
}
- (UIScrollView *)scrollViewMain
{
    if (!_scrollViewMain) {
        _scrollViewMain=[[UIScrollView alloc] init];
        _scrollViewMain.delegate=self;
        _scrollViewMain.pagingEnabled=true;
//        _scrollViewMain.contentSize
//        _scrollViewMain
    }
    return _scrollViewMain;
}
- (void)setIndex:(NSInteger)index
{
//    if (_arrayVCs.count>index) {
        [_selectViewMain selectIndex:index];
        [_scrollViewMain setContentOffset:CGPointMake(index*ScreenWidth, 0) animated:false];
            if (_index!=index) {
                if (_index>=0) {
                    UIViewController *vc=_arrayVCs[_index];
                    [vc viewWillDisappear:false];
                    UIViewController *vc2=_arrayVCs[index];
                    [vc2 viewWillAppear:false];
                }
//                self.navigationItem.rightBarButtonItem = vc.navigationItem.rightBarButtonItem;
            }
//    }
    _index=index;
}
#pragma mark UI
- (void)initWithTitles:(NSArray *)titles vcs:(NSArray *)vcs
{
//    if (_index<=0) {
        _index=0;
//    }
    _selectViewMain=[[HNUSelectView alloc] initWithTitles:titles];
    _selectViewMain.delegate=self;
    [self.view addSubview:self.viewMain];
    [self.viewMain addSubview:_selectViewMain];
    [self.viewMain addSubview:self.scrollViewMain];
    _arrayVCs=[vcs mutableCopy];
    
    [self addConstrain];
}
- (void)addConstrain
{
    hnuSetWeakSelf;
    [_viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.equalTo(weakSelf.view);
    }];
    [_selectViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.equalTo(weakSelf.view.mas_width);
        make.height.mas_equalTo(W(44));
    }];
    [_scrollViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.selectViewMain.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.equalTo(weakSelf.view.mas_width);
        make.bottom.equalTo(self.view);
    }];
    for (int i=0;i<_arrayVCs.count;i++) {
        UIViewController *vc=_arrayVCs[i];
        [self addChildViewController:vc];
        [self.scrollViewMain addSubview:vc.view];
//        if (i!=_index) {
//            vc.view.hidden
//        }
        //        vc.view.left=ScreenWidth*i;
        [vc.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(ScreenWidth);
            make.left.mas_equalTo(ScreenWidth*i);
            make.height.equalTo(weakSelf.scrollViewMain.mas_height);
        }];
    }
    _scrollViewMain.contentSize=CGSizeMake(_arrayVCs.count*ScreenWidth, 0);
}
#pragma mark Method
- (int)getScrollViewIndex
{
    int index=(int)((_scrollViewMain.contentOffset.x+ScreenWidth/2)/ScreenWidth);
    if (index<0) {
        index=0;
    }
    else if (index>=_arrayVCs.count)
    {
        index=(int)_arrayVCs.count-1;
    }
    return index;
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    [_selectViewMain selectIndex:[self getScrollViewIndex]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.index=[self getScrollViewIndex];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        self.index=[self getScrollViewIndex];
    }
}
#pragma mark HNUSelectViewDelegate
-(void)hnuSelectViewDidselectIndex:(NSUInteger)index
{
    self.index=index;
}
@end
