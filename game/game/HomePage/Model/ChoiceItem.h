//
//  ChoiceItem.h
//  game
//
//  Created by GKK on 2018/9/25.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChoiceItem : NSObject
@property (nonatomic,strong) NSNumber * choicetype;
@property (nonatomic,strong) NSString * choice;
@property (nonatomic,strong) NSNumber * code;
@property (strong,nonatomic) NSString * icon;
@end

NS_ASSUME_NONNULL_END
