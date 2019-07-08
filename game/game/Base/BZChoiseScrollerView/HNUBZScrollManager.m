//
//  HNUBZScrollManager.m
//  test
//
//  Created by linsheng on 2018/7/23.
//  Copyright © 2018年 linsheng. All rights reserved.
//

#import "HNUBZScrollManager.h"
#import "UIScrollView+HNUBZPullRefresh.h"

@interface HNUBZScrollManager()
//滑动的顶部
@property (nonatomic, assign) float fScrollTopY;
//当前滑动的View
@property (nonatomic, strong) UIScrollView *scrollViewNow;
//滑动锁 切换tap的时候 限制编辑
@property (nonatomic, assign) BOOL boolLock;
@end
@implementation HNUBZScrollManager
- (id)initWithViewController:(NSArray *)viewControllers headView:(HNUBZChoiceView *)headView mainView:(UIView *)mainView
{
    if (self=[super init]) {
        _viewMain=mainView;
         _viewHeader=headView;
        _arrayVCs=viewControllers;
        
        for (HNUBZBasicView *vc in _arrayVCs) {
            [_viewMain addSubview:vc];
            vc.frame=_viewMain.frame;
            vc.hidden=true;
            if (vc.scrollViewBZ) {
                //取消偏移
//                if (@available(iOS 11.0, *)) {
//                    vc.scrollViewBZ.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//                }else {
//                    vc.automaticallyAdjustsScrollViewInsets = NO;
//                }
                //设置框架位置（可能会有高度bug ）
                vc.scrollViewBZ.frame=CGRectMake(vc.scrollViewBZ.left, 0, (vc.scrollViewBZ.width>0?vc.scrollViewBZ.width:self.viewMain.width), self.viewMain.frame.size.height);
           
                //设置contentInset
            vc.scrollViewBZ.contentInset=UIEdgeInsetsMake(_viewHeader.height+vc.scrollViewBZ.contentInset.top, vc.scrollViewBZ.contentInset.left, vc.scrollViewBZ.contentInset.bottom, vc.scrollViewBZ.contentInset.right);
                [vc.scrollViewBZ addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
                vc.floatYBZ=0;//-_viewHeader.frame.size.height;
                vc.scrollViewBZ.contentOffset=CGPointMake(0, -_viewHeader.height);
            }
        }
        [_viewMain addSubview:_viewHeader];
        _indexNow=-1;
        [self touchAtIndex:0];
       
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object==_scrollViewNow&&[keyPath isEqualToString:@"contentOffset"]&&!_boolLock) {
        //表示header位置
        if (_scrollViewNow.contentSize.height<(_scrollViewNow.height-_viewHeader.fSelectHeight)) {
            _scrollViewNow.contentSize=CGSizeMake(_scrollViewNow.width, _scrollViewNow.height-_viewHeader.fSelectHeight);//-20
        }
        float y=0;
        if (_scrollViewNow.contentOffset.y>-_viewHeader.frame.size.height) {
            //判断是上下移动 <0表示下移 header y的值是越来越少的
            float upOrDown=(_scrollViewNow.contentOffset.y-_fScrollTopY);
            //更新上一次位置
            _fScrollTopY=_scrollViewNow.contentOffset.y;
            if (upOrDown<0) {
                y=-(_scrollViewNow.contentOffset.y+_viewHeader.frame.size.height);
                if (y<_viewHeader.frame.origin.y) {
                    //当下移不满足基本条件是不进行移动
                    return;
                }

            }
            else
            {
                y=_viewHeader.frame.origin.y-upOrDown;
                if (y<(-_viewHeader.frame.size.height+_viewHeader.fSelectHeight)) {
                    //最低底线 就是header里面selectView的高度
                    y=-_viewHeader.frame.size.height+_viewHeader.fSelectHeight;
                }
                else if(y>0)
                {
                    //不能偏下 最低要求0
                    y=0;
                }
            }
        }
        _viewHeader.frame=CGRectMake(0, y, _viewHeader.frame.size.width, _viewHeader.frame.size.height);
        
    }
    
}
- (void)touchAtIndex:(NSInteger)index
{
    if (_indexNow==index) {
        return;
    }
    NSInteger lastIndex=_indexNow;
    _indexNow=index;
    _boolLock=true;
    for (int i=0;i<_arrayVCs.count;i++) {
        HNUBZBasicView *vc=_arrayVCs[i];
        
        if (i==index) {
            vc.scrollViewBZ.scrollEnabled=true;
            vc.hidden=false;
            _scrollViewNow=vc.scrollViewBZ;
            //理论上空的时候的偏移值 
            if (_viewHeader.frame.origin.y!=vc.floatYBZ) {
                float y=_viewHeader.frame.origin.y-vc.floatYBZ;
                _scrollViewNow.contentOffset=CGPointMake(0, _scrollViewNow.contentOffset.y-y);
            }
            _fScrollTopY=_scrollViewNow.contentOffset.y;
        }
        else
        {
            vc.scrollViewBZ.scrollEnabled=false;
            vc.hidden=true;
            if (i==lastIndex) {
                vc.floatYBZ=_viewHeader.frame.origin.y;
            }
            //vc.scrollViewBZ.contentOffset.y
        }
    }
    _boolLock=false;
    
}
- (void)dealloc
{
    for (HNUBZBasicView *vc in _arrayVCs) {
        if (vc.scrollViewBZ) {
            [vc.scrollViewBZ removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
}
@end
