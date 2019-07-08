//
//  KKSelectPicker.m
//  game
//
//  Created by GKK on 2018/8/10.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKSelectPicker.h"
#import "KKFileTool.h"
@interface KKSelectPicker()

@end
@implementation KKSelectPicker
+(instancetype)sharedSelectPicker
{
    KKSelectPicker * picker = [[NSBundle mainBundle] loadNibNamed:@"KKSelectPicker" owner:nil options:nil].firstObject;
    picker.frame = [UIScreen mainScreen].bounds;
    [[KKDataTool shareTools].alertWindow addSubview:picker];
    [KKDataTool shareTools].alertWindow.backgroundColor = [UIColor clearColor];
    [[KKDataTool shareTools].alertWindow makeKeyAndVisible];
    return picker;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeSelf];
}
- (void)removeSelf{
    if (self.superview) {
        [self removeFromSuperview];
    }
    [[KKDataTool shareTools] destroyAlertWindow];
}
- (IBAction)clickEnsureBtn:(id)sender {
    if (self.ensureBlock) {
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        self.ensureBlock(index);
    }
    [self removeSelf];
}
- (IBAction)clickCancelBtn:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeSelf];
}
@end
