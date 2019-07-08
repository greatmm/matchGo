//
//  KKWSTool.h
//  game
//
//  Created by GKK on 2018/9/17.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKWSTool : NSObject<NSCopying,NSMutableCopying>
+(instancetype)shareTools;
- (void)getWSList;
- (void)sendMessage:(NSDictionary *)message;
+ (void)sendMessage:(NSDictionary *)message;
@end
