//
//  KKDeleteImgViewController.h
//  game
//
//  Created by greatkk on 2018/12/13.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKDeleteImgViewController : KKBaseViewController
@property (strong,nonatomic) NSMutableArray * imgArr;//图片数组
@property (assign,nonatomic) NSInteger currectIndex;//进来显示第几张
@property (strong,nonatomic) void(^backBlock)(NSMutableArray * arr);
@end

NS_ASSUME_NONNULL_END
