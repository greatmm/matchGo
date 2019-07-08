//
//  KKHomepageCollectionReusableView.h
//  game
//
//  Created by GKK on 2018/8/13.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKHomepageCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIControl *moreControl;
@property (strong,nonatomic) void(^clickMoreBlock)(void);
@end