//
//  GameItem.h
//  game
//
//  Created by GKK on 2018/8/23.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTKJsonModel.h"

@interface GameItem : MTKJsonModel
@property (nonatomic, strong) NSArray *matchtypes;
@property (nonatomic,strong) NSArray * choicetypes;
@property (nonatomic, strong) NSNumber *gameId;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic,strong) NSNumber * resultinseconds;
@end
