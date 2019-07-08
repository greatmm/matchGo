//
//  KKHomepageCollectionReusableView.m
//  game
//
//  Created by GKK on 2018/8/13.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKHomepageCollectionReusableView.h"

@implementation KKHomepageCollectionReusableView
- (IBAction)clickMoreBtn:(id)sender {
    if (self.clickMoreBlock) {
        self.clickMoreBlock();
    }
}
@end
