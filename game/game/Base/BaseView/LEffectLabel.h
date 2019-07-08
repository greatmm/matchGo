#import <UIKit/UIKit.h>


typedef enum tagEffectDirection
{
    EffectDirectionLeftToRight,
    EffectDirectionRightToLeft,
    EffectDirectionTopToBottom,
    EffectDirectionBottomToTop,
    EffectDirectionTopLeftToBottomRight,
    EffectDirectionBottomRightToTopLeft,
    EffectDirectionBottomLeftToTopRight,
    EffectDirectionTopRightToBottomLeft
}
EffectDirection;


@interface LEffectLabel : UIView
{
    UILabel *_effectLabel;
    CGImageRef _alphaImage;
    CALayer *_textLayer;
}


@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *effectColor;
@property (strong, nonatomic) NSString *text;
//方向
@property (assign, nonatomic) EffectDirection effectDirection;
//时间间隔
@property (assign, nonatomic) NSInteger timeSpan;

- (void)performEffectAnimation;
- (void)startAnimation;

@end
