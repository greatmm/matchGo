//
//  KKChampionResultViewController.m
//  game
//
//  Created by linsheng on 2019/1/11.
//  Copyright © 2019年 MM. All rights reserved.
//

#import "KKChampionResultViewController.h"
#import "KKChampionMyResultTableViewCell.h"
#import "LGPhotoPickerBrowserViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKChampionshipsMatchModel.h"
#import "KKChampionResultManager.h"
#import "HNUResultHeadView.h"
@interface KKChampionResultViewController()<LGPhotoPickerBrowserViewControllerDataSource,LGPhotoPickerBrowserViewControllerDelegate>
@property (nonatomic, strong) NSArray *showImgArr;
@property (nonatomic, strong) HNUResultHeadView *headViewMain;
@property (nonatomic, strong) KKChampionResultManager *dataManagerLocal;
@end
@implementation KKChampionResultViewController
- (id)initWithCid:(NSNumber *)cid gameId:(NSNumber *)gameId type:(KKChampionshipsType )type
{
    if (self=[super init]) {
        _dataManagerLocal=[[KKChampionResultManager alloc] initWithCid:cid gameId:gameId type:type];
        self.dataManagerMain=_dataManagerLocal;
    }
    return self;
}
- (void)viewDidLoad
{
    [self addNotification];
    self.boolLogOutShow=true;
    [self initSuperInfoWithMJ];
    [self requestData];
    [super viewDidLoad];
    _headViewMain=[HNUResultHeadView new];
    self.tableViewMain.tableHeaderView=_headViewMain;
     [self setTableviewContain];
}
- (void)addNotification
{
    //结果刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:KKEndChampionNotification object:nil];
    //放弃提交 提交战绩
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:KKSubmissionChampionNotification object:nil];
    //加入锦标赛
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:KKJoinChampionNotification object:nil];
}
#pragma mark Supr
- (void)reloadDataWithEnd:(BOOL)end
{
    [super reloadDataWithEnd:end];
    [_headViewMain setType:_dataManagerLocal.type value:[_dataManagerLocal getHeadInfo]];
}
#pragma mark Mehthod
- (void)showImageBrowse
{
    LGPhotoPickerBrowserViewController *BroswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
    BroswerVC.delegate = self;
    BroswerVC.dataSource = self;
    BroswerVC.showType = LGShowImageTypeImageURL;
    [self presentViewController:BroswerVC animated:YES completion:nil];
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KKChampionshipsMatchModel * model = self.dataManagerMain.array_main[indexPath.row];
//    if (self.gameId.integerValue != 1) {
    NSString * images = model.images;
        if (images && images.length) {
            self.showImgArr = [images componentsSeparatedByString:@","];
            [self showImageBrowse];
        }
        //            else {
        //                [KKAlert showText:@"暂无结果图片" toView:self.view];
        //            }
//    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

#pragma mark LGPhotoPickerBrowserViewControllerDataSource,LGPhotoPickerBrowserViewControllerDelegate
/**
 *  每个组多少个图片
 */
- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section
{
    return self.showImgArr.count;
}
///**
// *  每个对应的IndexPath展示什么内容
// */
- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath
{
    LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
    photo.photoURL = [NSURL URLWithString:self.showImgArr[indexPath.row]];
    return photo;
}
@end
