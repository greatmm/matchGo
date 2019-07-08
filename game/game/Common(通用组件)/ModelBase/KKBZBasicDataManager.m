//
//  KKBZBasicDataManager.m
//  game
//
//  Created by linsheng on 2019/1/11.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKBZBasicDataManager.h"

@implementation KKBZBasicDataManager

- (id)init
{
    if (self=[super init]) {
        _autoTableViewSeparatorSet=YES;
        self.array_main=[NSMutableArray array];
        _lock_request=NO;
        _int_pageNumber=30;
        _boolFristReloadData=NO;
    }
    return self;
}
- (id)initWithUrl:(NSString *)url model:(Class)classModel cell:(Class)classCell
{
    
    if (self=[self init]) {
        if (url) {
            self.string_loadingUrl=url;
            self.classModel=classModel;
            self.classCell=classCell;
        }
    }
    return self;
}
#pragma mark set/get
- (KKAutoArrayModel *)modelForLoading
{
    if (!_modelForLoading) {
        _modelForLoading=[[KKAutoArrayModel alloc] initWithKey:@"" bid:_classModel];
    }
    return _modelForLoading;
}
- (void)setClassModel:(Class)classModel
{
    self.modelForLoading.modelName=classModel;
}
#pragma mark request
- (void)startLoadWithDictionary:(NSDictionary *)dictionary
{
    _lock_request=YES;
    if (dictionary) {
        self.dictionary_loadingInfo=[NSMutableDictionary dictionaryWithDictionary:dictionary];
    }
    else self.dictionary_loadingInfo=[NSMutableDictionary dictionary];
    [self resetLoaingInfo];
    [self loadingWithDictionary];
}

-(void)loadingWithDictionary
{
    
    hnuSetWeakSelf;
    _modelForLoading.requestParams=_dictionary_loadingInfo;
    [_modelForLoading fetchWithPath:self.string_loadingUrl type:MTKFetchModelTypeGET completionWithData:^(BOOL isSucceeded, NSString *msg, NSError *error,id responseObjectData)
     {
         if (weakSelf.boolFristReloadData) {
             [weakSelf.array_main removeAllObjects];
         }
         [self checkWithResponse:responseObjectData];
         weakSelf.blockCompletion(isSucceeded, msg, error, (weakSelf.modelForLoading.arrayOutput.count<weakSelf.int_pageNumber));
     }];
    
}
- (void)checkWithResponse:(id)responseObjectData
{
    [self.array_main addObjectsFromArray:self.modelForLoading.arrayOutput];
}
- (void)resetLoaingInfo
{
    if (_int_pageNumber>0) {
        [_dictionary_loadingInfo setObject:@(_int_pageNumber) forKey:@"limit"];
        if (_boolFristReloadData) {
            [_dictionary_loadingInfo setObject:@(0) forKey:@"offset"];
        }
        else [_dictionary_loadingInfo setObject:@(_array_main.count) forKey:@"offset"];
    }
}

#pragma mark
- (void)setDataWithCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [cell resetWithData:_array_main[indexPath.row]];
}
#pragma mark UITableDataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array_main.count;
}
//剥离获取cellclass
- (Class)getCellClassWithIndexPath:(NSIndexPath *)indexPath
{
    return _classCell;
}
//剥离获取cell方法
- (UITableViewCell *)getTableViewCell:(UITableView *)tableView class:(Class)cellClass
{
    NSString * cellID = NSStringFromClass(cellClass);
    NSRange range=[cellID rangeOfString:@"."];
    if (!(range.location==NSNotFound)) {
        cellID= [cellID substringFromIndex:range.location+1];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    //如果有可重用的cell，则跳过if 否则 实例化一个
    
    if(cell == nil){
        if([[NSBundle mainBundle] pathForResource:cellID ofType:@"nib"] != nil)
        {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:cellID owner:nil options:nil];
            cell= [nib objectAtIndex:0];
        }
        else cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //        cell.backgroundColor=[UIColor clearColor];
    }
    return cell;
}
//拆分 方便组装
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self getTableViewCell:tableView class:[self getCellClassWithIndexPath:indexPath]];
    if (indexPath.row<_array_main.count) {
        if (_autoTableViewSeparatorSet) {
            if (indexPath.row==_array_main.count-1) {
                cell.separatorInset=UIEdgeInsetsMake(cell.height, ScreenWidth, 0, 0);
            }
            else cell.separatorInset=tableView.separatorInset;
        }
        [self setDataWithCell:cell indexPath:indexPath];
    }
    return cell;
}
#pragma mark
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _array_main.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = NSStringFromClass(_classCell);
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [self setDataWithCell:cell indexPath:indexPath];
    return cell;
}
@end
