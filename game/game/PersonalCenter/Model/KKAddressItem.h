//
//  KKAddressItem.h
//  game
//
//  Created by GKK on 2018/9/13.
//  Copyright © 2018年 MM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKAddressItem : MTKJsonModel

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSNumber *address_id;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *area;

@property (nonatomic, strong) NSNumber *isdefault;

@property (nonatomic, strong) NSString *contact;

@end
