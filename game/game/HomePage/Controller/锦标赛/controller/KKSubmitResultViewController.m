//
//  KKSubmitResultViewController.m
//  game
//
//  Created by greatkk on 2018/11/2.
//  Copyright © 2018 MM. All rights reserved.
//

#import "KKSubmitResultViewController.h"
#import "KKDeleteImgViewController.h"
#import "TZImagePickerController.h"
@interface KKSubmitResultViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UIImageView *midImgView;
@property (weak, nonatomic) IBOutlet UIImageView *btmImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midImgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btmImgHeight;
@property (strong,nonatomic) NSMutableArray * imgArr;//选中的图片
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *imgBtns;
@property (assign,nonatomic) NSInteger imgCount;//需要上传几张图
@property (weak, nonatomic) IBOutlet UILabel *desLabel;//下边的描述文字

@end

@implementation KKSubmitResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self assignUI];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(submitResult)];
    self.navigationItem.rightBarButtonItem.tintColor = kThemeColor;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.imgArr = [NSMutableArray new];
}
- (void)assignUI
{
    if (self.gameId < 2 || self.gameId > 4) {
        return;
    }
    NSArray * arr = @[@"王者荣耀游戏结束后\n1.点击→我的头像→历史战绩列表页  截图\n2.点击数据查看详情 截图\n3.点击数据查看数据页 截图",@"刺激战场游戏结束后\n1.点击→我的头像→历史战绩  截图\n2.选择相应对局  截图",@"英雄联盟游戏结束后\n打开【掌上英雄联盟App】→战绩→选择相,应对局→查看详情  截图"];
    switch (self.gameId) {
        case KKGameTypeWangzheRY:
        {
            //王者荣耀三张图
            self.imgCount = 3;
            self.topImgView.image = [UIImage imageNamed:@"GKResultHintImg"];
            self.topImgHeight.constant = 110;
            self.midImgView.image = [UIImage imageNamed:@"GKResultHintImg_1"];
            self.midImgHeight.constant = 110;
            self.btmImgView.image = [UIImage imageNamed:@"GKResultHintImg_2"];
            self.btmImgHeight.constant = 110;
        }
            break;
        case KKGameTypeCijiZC:
        {
            //刺激战场待定2张
            self.imgCount = 2;
            self.topImgView.image = [UIImage imageNamed:@"ZCResultHintImg"];
            self.topImgHeight.constant = 110;
            self.midImgView.image = [UIImage imageNamed:@"ZCResultHintImg_1"];
            self.midImgHeight.constant = 110;
            self.btmImgHeight.constant = 1;
        }
            break;
        case KKGameTypeYingxiongLM:
        {
            //英雄联盟1张
            self.imgCount = 1;
            self.topImgView.image = [UIImage imageNamed:@"LOLResultHintImg"];
            self.topImgHeight.constant = 202;
            self.midImgHeight.constant = 1;
            self.btmImgHeight.constant = 1;
            self.topLabel.text = @"提交有效战绩截图才能获得奖励";
        }
            break;
        default:
            break;
    }
    //隐藏不需要的按钮
    NSInteger btnCount = self.imgBtns.count;
    for (NSInteger i = 0; i < btnCount; i ++) {
        UIButton * btn = self.imgBtns[i];
        btn.hidden = (i >= self.imgCount);
    }
    if (self.imgCount > 1) {
        self.topLabel.text = [NSString stringWithFormat:@"提交%ld张有效战绩截图才能获得奖励",(long)self.imgCount];
    }
    NSString * str = arr[self.gameId - 2];
    self.desLabel.text = str;
    [self.view layoutIfNeeded];
}
- (void)submitResult
{
    [KKAlert showAnimateWithText:@"上传中" toView:self.view];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (self.isChampion) {
        [KKNetTool reportChampionResultWithMatchid:self.matchId imgs:self.imgArr SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismissWithView:self.view];
            [KKAlert showText:@"上传成功" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.submitSuccessBlock) {
                    self.submitSuccessBlock();
                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"submitSuccess" object:nil];;
                [self.navigationController popViewControllerAnimated:YES];
            });
        } erreorBlock:^(NSError *error) {
            [KKAlert dismissWithView:self.view];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if ([error isKindOfClass:[NSString class]]) {
                [KKAlert showText:(NSString *)error toView:self.view];
            } else {
                [KKAlert showText:@"上传失败" toView:self.view];
            }
        }];
    } else {
        [KKNetTool reportResultWithMatchid:self.matchId imgs:self.imgArr SuccessBlock:^(NSDictionary *dic) {
            [KKAlert dismissWithView:self.view];
            [KKAlert showText:@"上传成功" toView:self.view]; dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.submitSuccessBlock) {
                    self.submitSuccessBlock();
                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"submitSuccess" object:nil];;
                [self.navigationController popViewControllerAnimated:YES];
            });
        } erreorBlock:^(NSError *error) {
            [KKAlert dismissWithView:self.view];
            if ([error isKindOfClass:[NSString class]]) {
                [KKAlert showText:(NSString *)error toView:self.view];
            } else {
                [KKAlert showText:@"上传失败" toView:self.view];
            }
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)selectImage:(UIButton *)sender {
    if (sender.currentBackgroundImage) {
        //删除
        KKDeleteImgViewController * vc = [KKDeleteImgViewController new];
        vc.imgArr = self.imgArr;
        vc.currectIndex = sender.tag;
        __weak typeof(self) weakSelf = self;
        vc.backBlock = ^(NSMutableArray * _Nonnull arr) {
            weakSelf.imgArr = arr;
            [weakSelf updateUi];
        };
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    } else {
        //添加
        [self showAlertController];
    }
}

- (void)showAlertController{
    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
        }];
        [alertC addAction:cameraAction];
    }
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPhotoPickerViewController];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:photoAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)showPhotoPickerViewController
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.imgCount - self.imgArr.count delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakeVideo = NO;
    imagePickerVc.allowTakePicture = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    [self.imgArr addObjectsFromArray:photos];
    [self updateUi];
}
- (void)showImagePickerWithType:(UIImagePickerControllerSourceType)imagePickerType{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = imagePickerType;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.imgArr addObject:image];
    [self updateUi];
}
- (void)updateUi
{
    NSInteger count = self.imgArr.count;
    for (int i = 0; i < self.imgCount; i ++) {
        UIButton * btn = self.imgBtns[i];
        if (i < count) {
            [btn setTitle:nil forState:UIControlStateNormal];
            [btn setBackgroundImage:self.imgArr[i] forState:UIControlStateNormal];
        } else {
            [btn setTitle:@"+" forState:UIControlStateNormal];
            [btn setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
    [self checkRightItem];
}
- (void)checkRightItem
{
    self.navigationItem.rightBarButtonItem.enabled = (self.imgArr.count == self.imgCount);
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
