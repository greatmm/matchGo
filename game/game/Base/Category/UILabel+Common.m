//
//  UILabel+Common.m
//  MaiTalk
//
//  Created by Duomai on 16/4/1.
//  Copyright © 2016年 duomai. All rights reserved.
//

#import "UILabel+Common.h"

@implementation UILabel (Common)
#pragma mark -  初始化label
+(id)create{
    UILabel *lbl = [[self alloc]init];
    lbl.backgroundColor = [UIColor clearColor];
    
    return lbl;
}


-(id)initWithText:(NSString *)text color:(UIColor *)colorStr fontSize:(CGFloat)fontSize forFrame:(CGRect)frame{
    if (self=[self init]) {
        self.frame = frame;
        self.font = [UIFont systemFontOfSize:fontSize];
        self.backgroundColor = [UIColor clearColor];
        self.textColor =colorStr;// [UIColor colorFromHexString:[NSString stringWithFormat:@"#%@",colorStr]];
//        self.textAlignment = NSTextAlignmentCenter;
        self.text = text;
    }
    
    return self;
}

+ (float)getWidthWithText:(NSString *)text font:(UIFont*)font
{
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT , font.pointSize+5)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font}
                              context:nil].size.width+1;
}
- (void)bzAutoSizeFit
{
    self.width=[UILabel getWidthWithText:self.text font:self.font];
}

@end
