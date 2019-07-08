//
//  KKHomePageControl.m
//  game
//
//  Created by greatkk on 2018/11/21.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKHomePageControl.h"

#define dotWH 6
#define markgin 4

@interface KKHomePageControl ()
@property (strong,nonatomic) UIImage * normalImage;//未选中的图片
@property (strong,nonatomic) UIImage * selImage;//选中的图片
@property (assign,nonatomic) BOOL hasEnsureFrame;
@end
@implementation KKHomePageControl

-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    [super setNumberOfPages:numberOfPages];
    UIImage * currentImage = [self valueForKey:@"_currentPageImage"];
    self.selImage = currentImage;
    UIImage * pageImage = [self valueForKey:@"_pageImage"];
    self.normalImage = pageImage;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.numberOfPages < 2) {
        return;
    }
    if (self.hasEnsureFrame == NO) {
        self.hasEnsureFrame = YES;
        CGRect f = self.frame;
        if (self.normalImage && self.selImage) {
            CGFloat h = self.normalImage.size.height;//获取图片的高度
            CGFloat w1 = self.normalImage.size.width;//获取普通图片的宽度
            CGFloat w2 = self.selImage.size.width;//获取选中的图片的宽度
            CGFloat w = w2 + w1 * (self.numberOfPages - 1) + markgin *(self.numberOfPages - 1);//计算pagecontrol最终的宽度
            f.origin.y = CGRectGetMaxY(f) - h;
            f.origin.x = CGRectGetMaxX(f) - w;
            f.size.width = w;
            f.size.height = h;
            self.frame = f;
        } else {
            CGFloat w = dotWH * self.numberOfPages + markgin * (self.numberOfPages - 1);//计算pagecontrol最终的宽度
            f.origin.y = CGRectGetMaxY(f) - dotWH;
            f.origin.x = CGRectGetMaxX(f) - w;
            f.size.width = w;
            f.size.height = dotWH;
            self.frame = f;
        }
    }
    NSUInteger count = [self.subviews count];
    if (self.normalImage && self.selImage) {
        CGSize size;
        NSUInteger firstX = 0;
        for (NSUInteger i = 0; i < count; i++) {
            if (i == self.currentPage) {
                size = self.selImage.size;
            } else {
                size = self.normalImage.size;
            }
            UIImageView* subview = [self.subviews objectAtIndex:i];
            [subview setFrame:CGRectMake(firstX, 0, size.width,size.height)];
            firstX += size.width + markgin;
        }
    } else {
        for (NSUInteger i = 0; i < count; i++) {
            UIImageView* subview = [self.subviews objectAtIndex:i];
            [subview setFrame:CGRectMake((dotWH + markgin)*i, 0, dotWH,dotWH)];
        }
    }
}
-(void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self setNeedsLayout];
}

@end
