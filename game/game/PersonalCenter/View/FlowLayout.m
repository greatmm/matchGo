//
//  FlowLayout.m
//  自定义流水布局
//

#import "FlowLayout.h"
/*
    自定义布局:只要了解5个方法
 
 - (void)prepareLayout;
 
 - (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
 
 - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;
 
 - (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity; // return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior

 - (CGSize)collectionViewContentSize;

 */
@implementation FlowLayout

/*
 UICollectionViewLayoutAttributes:确定cell的尺寸
 一个UICollectionViewLayoutAttributes对象就对应一个cell
 拿到UICollectionViewLayoutAttributes相当于拿到cell
 */

// 重写它方法,扩展功能

// 什么时候调用:collectionView第一次布局,collectionView刷新的时候也会调用
// 作用:计算cell的布局,条件:cell的位置是固定不变
// - (void)prepareLayout
//{
//    [super prepareLayout];
//    
//    NSLog(@"%s",__func__);
//    
//}

// 作用:指定一段区域给你这段区域内cell的尺寸
// 可以一次性返回所有cell尺寸,也可以每隔一个距离返回cell
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attrs = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    CGFloat x = 0;
    CGFloat y = 0;
    UICollectionViewLayoutAttributes *preattr;
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        CGSize size = attr.frame.size;
        if (x + size.width < CGRectGetWidth(self.collectionView.bounds)) {
            CGRect f = CGRectMake(x, y, size.width, size.height);
            attr.frame = f;
            x += size.width + 10;
            preattr = attr;
        } else {
            if (preattr) {
                y += preattr.frame.size.height + 10;
            }
            x = 0;
            CGRect f = CGRectMake(x, y, size.width, size.height);
            attr.frame = f;
        }
    }
    
    return attrs;
    
}

// Invalidate:刷新
// 在滚动的时候是否允许刷新布局
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
//    return YES;
//}


@end
