//
//  BannerItem.h
//  game
//
//  Created by GKK on 2018/10/25.
//  Copyright © 2018 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerItem : NSObject

@property (nonatomic, strong) NSNumber *link_type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, strong) NSString *image;

@property (strong,nonatomic) NSDictionary * params;

@property (strong,nonatomic) NSNumber * game;

@end

NS_ASSUME_NONNULL_END
