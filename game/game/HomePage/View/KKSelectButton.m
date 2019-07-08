//
//  KKSelectButton.m
//  game
//
//  Created by GKK on 2018/8/14.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKSelectButton.h"
#import "UIColor+KKCategory.h"
@implementation KKSelectButton
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = kThemeColor.CGColor;
    } else {
        self.layer.borderWidth = 0;
        self.backgroundColor = [UIColor colorWithHexString:@"F9F9F9"];
        self.layer.borderColor = [UIColor colorWithHexString:@"F9F9F9"].CGColor;
    }
}
- (void)configurateImageUi
{
    [self setImage:[UIImage imageNamed:@"choiceDefaultIcon"] forState:UIControlStateNormal];
    [[self imageView] setContentMode:UIViewContentModeScaleAspectFit];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}
- (void)configurateTitleUi
{
    [self setTitleColor:kTitleColor forState:UIControlStateNormal];
    self.backgroundColor = [UIColor colorWithWhite:249/255.0 alpha:1];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.numberOfLines = 0;
    self.layer.cornerRadius = 2;
    self.layer.borderWidth = 1;
}
-(UIEdgeInsets)titleEdgeInsets
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(8, 12, 20, 20);
}
-(void)setHighlighted:(BOOL)highlighted
{
    
}
@end
