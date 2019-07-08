//
//  KKSelectPicker.h
//  game
//
//  Created by GKK on 2018/8/10.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKSelectPicker : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic,strong) void(^cancelBlock)(void);
@property (nonatomic,strong) void(^ensureBlock)(NSInteger index);
+(instancetype)sharedSelectPicker;
@end
