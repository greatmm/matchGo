//
//  KKChoiceView.h
//  game
//
//  Created by greatkk on 2018/10/30.
//  Copyright © 2018 MM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKRemoveView.h"
#import "ChoiceItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChoiceView : KKRemoveView
@property (strong,nonatomic) NSArray * yuleChoiceArr;
@property (strong,nonatomic) NSArray * jingjiChoiceArr;
@property (strong,nonatomic) NSArray * peopleCountArr;
//@property (strong,nonatomic) NSMutableArray * selChoiceNumberArr;//选中的选项id
@property (assign,nonatomic) BOOL isJingji;//选项是竞技还是娱乐
@property (assign,nonatomic) NSInteger selPeopleIndex;
@property (strong,nonatomic) void(^clickEnsureBtnBlock)(NSInteger slots,BOOL isJingji,NSMutableArray * choiceNumberArr);
+(instancetype)shareChoiceView;
-(void)relaodData;
-(void)clearData;
-(void)show;
@end

NS_ASSUME_NONNULL_END
