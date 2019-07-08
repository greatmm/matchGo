//
//  KKAppealViewController.m
//  game
//
//  Created by GKK on 2018/8/21.
//  Copyright © 2018年 MM. All rights reserved.
//

#import "KKAppealViewController.h"
#import "KKImageCollectionViewCell.h"
#import "KKDeleteImgViewController.h"
#import "TZImagePickerController.h"
#define maxNumber 200
@interface KKAppealViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *cv;
@property (nonatomic,strong) NSMutableArray * imgArr;
@end

@implementation KKAppealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申诉";
    self.imgArr = [NSMutableArray new];
    if (@available(iOS 9.0, *)) {
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请输入200字以内您要申诉的问题";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor colorWithWhite:112/255.0 alpha:1];
        placeHolderLabel.font = self.textView.font;
        [placeHolderLabel sizeToFit];
        [self.textView addSubview:placeHolderLabel];
        [self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewNotifitionAction:) name:UITextViewTextDidChangeNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)textViewNotifitionAction:(NSNotification *)noti{
    NSString * str = self.textView.text;
    if (str.length > maxNumber) {
        self.textView.text = [str substringToIndex:maxNumber];
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)self.textView.text.length,maxNumber];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [self.view endEditing:YES];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgArr.count == 3? 4: self.imgArr.count + 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imgArr.count == 3) {
        if (indexPath.row == self.imgArr.count) {
            static NSString * reuse = @"labelCell";
            UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
            return cell;
        }
        static NSString * reuse = @"imageCell";
        KKImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
        cell.imageView.image = self.imgArr[indexPath.row];
        return cell;
    }
    if (indexPath.row < self.imgArr.count) {
        static NSString * reuse = @"imageCell";
        KKImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
        cell.imageView.image = self.imgArr[indexPath.row];
        return cell;
    } else if (indexPath.row == self.imgArr.count){
        static NSString * reuse = @"addImage";
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
        return cell;
    }
    static NSString * reuse = @"labelCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imgArr.count == 3 || self.imgArr.count == 2) {
        if (indexPath.row == 3) {
            if (ScreenWidth == 320) {
                return CGSizeMake(148, 25);
            }
            return CGSizeMake(148, 54);
        }
        return CGSizeMake(54, 54);
    }
    if (indexPath.row == self.imgArr.count + 1) {
        return CGSizeMake(148, 54);
    }
    return CGSizeMake(54, 54);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.imgArr.count) {
        KKDeleteImgViewController * vc = [KKDeleteImgViewController new];
        vc.imgArr = self.imgArr;
        __weak typeof(self) weakSelf = self;
        vc.backBlock = ^(NSMutableArray * _Nonnull arr) {
            weakSelf.imgArr = arr;
            [weakSelf.cv reloadData];
        };
        [self.navigationController presentViewController:vc animated:YES completion:nil];
        return;
    }
    if (self.imgArr.count != 3 && (indexPath.row == self.imgArr.count)) {
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
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 - self.imgArr.count delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowTakeVideo = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    [self.imgArr addObjectsFromArray:photos];
    [self.cv reloadData];
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
    [self.cv reloadData];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//提交申诉
- (IBAction)commitAppeal:(id)sender {
    if (self.textView.text.length == 0) {
        [KKAlert showText:@"请输入申诉内容"];
        return;
    }
    if (self.imgArr.count == 0) {
        [KKAlert showText:@"请选择照片"];
        return;
    }
    [KKAlert showText:@"申诉提交成功"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
