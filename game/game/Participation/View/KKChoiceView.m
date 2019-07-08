//
//  KKChoiceView.m
//  game
//
//  Created by greatkk on 2018/10/30.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKChoiceView.h"
#import "KKShopCollectionReusableView.h"
#import "KKChoiceCollectionViewCell.h"
@interface KKChoiceView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *cv;
@property (strong,nonatomic) NSMutableArray * yuleSelIndexArr;//选中的娱乐下标
@property (strong,nonatomic) NSMutableArray * jingjiSelIndexArr;//选中的竞技下标
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
@implementation KKChoiceView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selPeopleIndex = -1;
    [self.cv registerClass:[KKShopCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellHeader"];
    [self.cv registerClass:[KKChoiceCollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    __weak typeof(self) weakSelf = self;
    self.removeBlock = ^{
        [weakSelf dismiss];
//        [UIView animateWithDuration:0.25 animations:^{
//            weakSelf.mj_x = ScreenWidth;
//        } completion:^(BOOL finished) {
//            [weakSelf removeFromSuperview];
//        }];
//        [weakSelf removeFromSuperview];
//        [weakSelf postHouseNoti];
    };
}
- (void)show
{
    CGFloat x = self.cv.superview.mj_x;
    self.cv.superview.mj_x = ScreenWidth;
    [UIView animateWithDuration:0.25 animations:^{
        self.cv.superview.mj_x = x;
    }];
}
- (void)dismiss
{
    CGFloat x = self.cv.superview.mj_x;
    [UIView animateWithDuration:0.25 animations:^{
        self.cv.superview.mj_x = ScreenWidth;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.cv.superview.mj_x = x;
    }];
}
-(NSMutableArray *)yuleSelIndexArr
{
    if (_yuleSelIndexArr) {
        return _yuleSelIndexArr;
    }
    _yuleSelIndexArr = [NSMutableArray new];
    return _yuleSelIndexArr;
}
-(NSMutableArray *)jingjiSelIndexArr
{
    if (_jingjiSelIndexArr) {
        return _jingjiSelIndexArr;
    }
    _jingjiSelIndexArr = [NSMutableArray new];
    return _jingjiSelIndexArr;
}
-(NSArray *)peopleCountArr
{
    if (_peopleCountArr) {
        return _peopleCountArr;
    }
    return @[@0];
}
//-(void)setSelChoiceNumberArr:(NSMutableArray *)selChoiceNumberArr
//{
//    if (_selChoiceNumberArr == selChoiceNumberArr) {
//        return;
//    }
//    _selChoiceNumberArr = selChoiceNumberArr;
//    if (_selChoiceNumberArr.count == 0) {
//        return;
//    }
//    NSArray * arr = _isJingji?self.jingjiChoiceArr:self.yuleChoiceArr;
//    NSInteger section = _isJingji?1:0;
//    NSMutableArray * indexArr = _isJingji?self.jingjiSelIndexArr:self.yuleSelIndexArr;
//    NSInteger count = arr.count;
//
//    for (NSInteger i = 0; i < count; i ++) {
//        ChoiceItem * item = arr[i];
//        if (_selChoiceNumberArr.count == 0) {
//            return;
//        }
//        for (NSNumber * code in _selChoiceNumberArr) {
//            if (item.code.integerValue == code.integerValue) {
//                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:section];
//                [indexArr addObject:indexPath];
//                [_selChoiceNumberArr removeObject:code];
//                break;
//            }
//        }
//    }
//}
-(void)relaodData
{
    [self.cv reloadData];
    [self performSelector:@selector(refreshBtn) withObject:nil afterDelay:0.25];
}
-(void)refreshBtn
{
    NSArray * arr = _isJingji?self.jingjiSelIndexArr:self.yuleSelIndexArr;
    for (NSIndexPath * indexPath in arr) {
        dispatch_main_async_safe(^{
            KKChoiceCollectionViewCell * cell = (KKChoiceCollectionViewCell *)[self.cv cellForItemAtIndexPath:indexPath];
            cell.choiceBtn.selected = YES;
        })
    }
}
- (IBAction)clickResetBtn:(id)sender {
    [self clearData];
    [self.cv reloadData];
}
- (IBAction)clickEnsureBtn:(id)sender {
//    [self removeFromSuperview];
    if (self.clickEnsureBtnBlock) {
        __weak typeof(self) weakSelf = self;
        NSMutableArray * numberArr = [NSMutableArray new];
        if (_jingjiSelIndexArr && _jingjiSelIndexArr.count) {
            for (NSIndexPath * index in _jingjiSelIndexArr) {
                ChoiceItem * item = _jingjiChoiceArr[index.row];
                [numberArr addObject:item.code];
            }
        } else if(_yuleSelIndexArr && _yuleSelIndexArr.count){
            for (NSIndexPath * index in _yuleSelIndexArr) {
                ChoiceItem * item = _yuleChoiceArr[index.row];
                [numberArr addObject:item.code];
            }
        }
        NSLog(@"%@",numberArr);
        NSArray<NSNumber*> * arr = self.peopleCountArr;
        NSInteger slot = 0;
        if (self.selPeopleIndex != -1) {
            slot = arr[self.selPeopleIndex].integerValue;
        }
        self.clickEnsureBtnBlock(slot, weakSelf.isJingji, numberArr);
        [self postHouseNoti];
        if (self.removeBlock) {
            self.removeBlock();
        }
    }
}
- (void)postHouseNoti
{
    if ([[KKDataTool shareTools] wVc] || [[KKDataTool shareTools] showWVc]) {
        CGFloat houseBtm = isIphoneX?(34):(0);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"btmHeightChanged" object:nil userInfo:@{@"btmH":[NSNumber numberWithFloat:houseBtm]}];
    }
}
+(instancetype)shareChoiceView
{
    KKChoiceView * choiceView = [[NSBundle mainBundle] loadNibNamed:@"KKChoiceView" owner:nil options:nil].firstObject;
    return choiceView;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.yuleChoiceArr.count;
        case 1:
            return self.jingjiChoiceArr.count;
        default:
            return self.peopleCountArr.count;
            break;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KKChoiceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    if (indexPath.section == 0 || indexPath.section == 1) {
        NSArray * arr;
        if (indexPath.section == 1){
            arr = self.jingjiChoiceArr;
        } else {
            arr = self.yuleChoiceArr;
        }
        ChoiceItem * item = arr[indexPath.row];
        [cell.choiceBtn setTitle:item.choice forState:UIControlStateNormal];
        cell.choiceBtn.selected = NO;
    } else {
        NSString * str;
        if (indexPath.row == 0) {
            str = @"全部";
        } else {
            str = [NSString stringWithFormat:@"%@人赛",self.peopleCountArr[indexPath.row]];
        }
        [cell.choiceBtn setTitle:str forState:UIControlStateNormal];
        cell.choiceBtn.selected = (indexPath.row == self.selPeopleIndex);
    }
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (ScreenWidth - 90)/3.0;
    return CGSizeMake(w, 54);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        switch (indexPath.section) {
            case 0:
            {
                if (self.yuleChoiceArr.count == 0) {
                    return nil;
                }
            }
                break;
            case 1:
            {
                if (self.jingjiChoiceArr.count == 0) {
                    return nil;
                }
            }
                break;
            default:
                break;
        }
        KKShopCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cellHeader" forIndexPath:indexPath];
        NSArray * arr = @[@"娱乐玩法",@"竞技玩法",@"对战人数"];
        header.titleLabel.text = arr[indexPath.section];
        header.titleLabel.textColor = [UIColor colorWithRed:147/255.0 green:153/255.0 blue:165/255.0 alpha:1];
        header.titleLabel.font = [UIFont systemFontOfSize:12];
        [header addSubview:header.titleLabel];
        [header.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(header).offset(5);
            make.centerY.mas_equalTo(header);
        }];
        return header;
    }
    return nil;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            if (self.yuleChoiceArr.count == 0) {
                return CGSizeZero;
            }
        }
            break;
        case 1:
        {
            if (self.jingjiChoiceArr.count == 0) {
                return CGSizeZero;
            }
        }
            break;
        default:
            break;
    }
    return CGSizeMake(ScreenWidth - 90, 40);
}
-(void)clearData
{
    self.selPeopleIndex = -1;
    self.jingjiSelIndexArr = nil;
    self.yuleSelIndexArr = nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            {
                self.isJingji = NO;
                if (_jingjiSelIndexArr && _jingjiSelIndexArr.count) {
                    for (NSIndexPath * index in _jingjiSelIndexArr) {
                        KKChoiceCollectionViewCell * cell = (KKChoiceCollectionViewCell *)[collectionView cellForItemAtIndexPath:index];
                        cell.choiceBtn.selected = NO;
                    }
                    [_jingjiSelIndexArr removeAllObjects];
                }
                KKChoiceCollectionViewCell * cell = (KKChoiceCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                if (cell.choiceBtn.selected) {
                    cell.choiceBtn.selected = NO;
                    [self.yuleSelIndexArr removeObject:indexPath];
                } else {
                    cell.choiceBtn.selected = YES;
                    [self.yuleSelIndexArr addObject:indexPath];
                }
            }
            break;
        case 1:
        {
            self.isJingji = YES;
            if (_yuleSelIndexArr && _yuleSelIndexArr.count) {
                for (NSIndexPath * index in _yuleSelIndexArr) {
                    KKChoiceCollectionViewCell * cell = (KKChoiceCollectionViewCell *)[collectionView cellForItemAtIndexPath:index];
                    cell.choiceBtn.selected = NO;
                }
                [_yuleSelIndexArr removeAllObjects];
            }
            KKChoiceCollectionViewCell * cell = (KKChoiceCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            if (cell.choiceBtn.selected) {
                cell.choiceBtn.selected = NO;
                [self.jingjiSelIndexArr removeObject:indexPath];
            } else {
                cell.choiceBtn.selected = YES;
                [self.jingjiSelIndexArr addObject:indexPath];
            }
        }
            break;
         case 2:
        {
            if (indexPath.row == self.selPeopleIndex) {
                return;
            } else {
                if (self.selPeopleIndex != -1) {
                   KKChoiceCollectionViewCell * cell = (KKChoiceCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selPeopleIndex inSection:2]];
                    cell.choiceBtn.selected = NO;
                }
                KKChoiceCollectionViewCell * cell = (KKChoiceCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                cell.choiceBtn.selected = YES;
                self.selPeopleIndex = indexPath.row;
            }
        }
            break;
        default:
            break;
    }
}
@end
