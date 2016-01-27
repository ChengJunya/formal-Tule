//
//  PhotoCollectionView.m
//  alijk
//
//  Created by zhangyang on 14-10-10.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "PhotoCollectionView.h"
#import "ImageViewZoom.h"
#import "PhotoCollectionViewFooter.h"
#import "PhotoCollectionViewCell.h"
#import "ZXCropViewController.h"
#import "CustomActionSheet.h"
#import "NSString+UUID.h"

static const NSInteger PhotoCountOneRow = 3;
static const CGFloat PhotoLineSpacing = 2.f;
static const CGFloat PhotoFooterHeight = 30.f;

@interface PhotoCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
{
    CGFloat _photoCellHeight;
    CGFloat _photoCellWidth;
    PhotoCollectionViewFooter *_footerview;
}

@property (nonatomic, strong) NSMutableArray *showPhotoArray; //存储ImageView
@property (nonatomic, strong) NSMutableArray *showPhotoNameArray; //存储图片名称

@property (nonatomic, strong) UICollectionView *presThumbnailCollectionView;
@property (nonatomic, strong) UIImage* currentImage; //当前正在编辑的照片

@end

@implementation PhotoCollectionView

NSString *const PhotoCollectionCellIdentifer = @"PhotoCollectionCellIdentifer";
NSString *const PhotoCollectionFooterIdentifer = @"PhotoCollectionFooterIdentifer";


-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.maxPhotoNum = 8;
        self.photoInfo = [NSString stringWithFormat:@"最多上传%d张图片",self.maxPhotoNum];
        [self initDataWithFrame:frame];
        [self updateShowFrame];
    }
    return self;
}


/*初始化是传进来一个照片*/
-(id)initWithFrame:(CGRect)frame andImage:(UIImage*)image
{
    if (self = [super initWithFrame:frame]) {
        self.maxPhotoNum = 5;
        self.photoInfo = [NSString stringWithFormat:@"最多上传%d张图片",self.maxPhotoNum];

        [self initDataWithFrame:frame];
        [self addShowImage:image];
        [self updateShowFrame];
    }
    
    return self;
}



-(void)initDataWithFrame:(CGRect)frame{
    self.showPhotoArray = [NSMutableArray array];
    self.showPhotoNameArray = [NSMutableArray array];
    
    _photoCellWidth = CGRectGetWidth(frame) / PhotoCountOneRow;
    _photoCellHeight = _photoCellWidth;
    
    CGRect newFrame = self.bounds;
    newFrame.size.height = _photoCellHeight + PhotoFooterHeight;
    [self initCollectionWithFrame:newFrame];
    
    UIImage *newImage = [UIImage imageNamed:@"tl_add"];
    [self.showPhotoArray addObject:newImage];
    [self.showPhotoNameArray addObject:@"Init"];
}

- (void)addShowImage:(UIImage*)image
{
    if (nil == image) {
        return;
    }
    
    NSInteger showPhotoCount = [self.showPhotoArray count];
    // 添加第一张图时，最后一张变换成“＋”图
    if (1 == showPhotoCount) {
        UIImage *newImage = [UIImage imageNamed:@"tl_add"];
        [self.showPhotoArray replaceObjectAtIndex:0 withObject:newImage];
    }
    
    // 将新图片插入倒数第二个位置
    NSString* fileName = [NSString stringWithFormat:@"%@.jpg", [NSString uuid]];
    [self.showPhotoArray insertObject:image atIndex:showPhotoCount-1];
    [self.showPhotoNameArray insertObject:fileName atIndex:showPhotoCount-1];
    
    [self updateShowFrame];
}

- (void)deleteShowImage:(NSInteger)index
{
    if (index >= [self.showPhotoArray count] - 1) {
        return;
    }
    
    [self.showPhotoArray removeObjectAtIndex:index];
    [self.showPhotoNameArray removeObjectAtIndex:index];
    
    if (1 == [self.showPhotoArray count]) {
        UIImage *newImage = [UIImage imageNamed:@"tl_add"];
        [self.showPhotoArray replaceObjectAtIndex:0 withObject:newImage];
    }
}

/*
 初始化
 */
-(void)initCollectionWithFrame:(CGRect)frame {
    //添加处方照片collection
    self.presThumbnailCollectionView = [self createControllerViewWithFrame:frame];
    self.presThumbnailCollectionView.backgroundColor = [UIColor clearColor];
    self.presThumbnailCollectionView.scrollEnabled = NO;
    [self addSubview:_presThumbnailCollectionView];
}

#pragma mark --------构建处方照片列表-------

-(UICollectionView*)createControllerViewWithFrame:(CGRect)frame{
    
    UICollectionViewFlowLayout *bottomLayout = [[UICollectionViewFlowLayout alloc] init];
    bottomLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    bottomLayout.minimumInteritemSpacing = 0.f; //列间距
    bottomLayout.minimumLineSpacing = PhotoLineSpacing;
    bottomLayout.footerReferenceSize = CGSizeMake(frame.size.width, PhotoFooterHeight);
    
    UICollectionView* collection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:bottomLayout];
    collection.allowsMultipleSelection = YES;
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor whiteColor];
    [collection registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:PhotoCollectionCellIdentifer];
    [collection registerClass:[PhotoCollectionViewFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:PhotoCollectionFooterIdentifer];
    return collection;
}



#pragma mark -----UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.showPhotoArray.count;
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCollectionCellIdentifer forIndexPath:indexPath];
    
    NSInteger index = indexPath.row;
    cell.closeButton.tag = index;
    [cell.closeButton setHidden:(index == self.showPhotoArray.count - 1)];
    cell.showImageView.image = self.showPhotoArray[index];
    [cell.closeButton addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter){
        _footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:PhotoCollectionFooterIdentifer forIndexPath:indexPath];
        _footerview.maxImageCount = self.maxPhotoNum;
        _footerview.currentCount = self.showPhotoArray.count-1;
        reusableview = _footerview;
    }
    
    return reusableview;
}


#pragma mark - 
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)cview layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSizeMake(_photoCellWidth, _photoCellHeight));
}

- (void)collectionView:(UICollectionView *)cview didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    [cview deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.item == self.showPhotoArray.count-1) {
        //添加照片
        [self addImageAction];
    }else{
        //显示大照片
        PhotoCollectionViewCell *view = (PhotoCollectionViewCell*)[cview cellForItemAtIndexPath:indexPath];
        [ImageViewZoom showImage:view.showImageView];
    }
}


#pragma mark -
#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    
    ZXCropViewController* pecontroller = [[ZXCropViewController alloc] init];
    pecontroller.delegate = self;
    pecontroller.image = image;
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    pecontroller.imageCropRect = CGRectMake((width - length) / 2,
                                            (height - length) / 2,
                                            length,
                                            length);
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pecontroller];
    [self.parentController presentViewController:nav animated:NO completion:nil];
    
}


#pragma mark -
#pragma mark - PECropViewControllerDelegate method

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [GHUDAlertUtils toggleLoadingInView:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *newImage = [croppedImage cropImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addShowImage:newImage];
            [self updateShowFrame];
            
            [GHUDAlertUtils hideLoadingInView:self];
            [_presThumbnailCollectionView reloadData];
        });
    });
}

-(void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark - action

//添加图片
- (void)addImageAction
{

    
    //判断是否>12
    if (self.showPhotoArray.count > self.maxPhotoNum) {
        [GHUDAlertUtils toggleMessage: self.photoInfo];
        return;
    }
    
    __weak PhotoCollectionView *weakSelf = self;
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithButtonTitles:@[MultiLanguage(scovcActionCamera),MultiLanguage(scovcActionPhoto),MultiLanguage(scovcActionCancle)]];
    [sheet setButtonBackGroundImage:[UIImage resizedImage:@"btn_gray_n" leftScale:0.2 topScale:1] forState:(UIControlStateNormal)];
    [sheet setButtonBackGroundImage:[UIImage resizedImage:@"btn_gray_p" leftScale:0.2 topScale:1] forState:(UIControlStateHighlighted)];
    [sheet actionSheetSelectBlock:^(CustomActionSheet *actionSheet, NSUInteger index) {
        if (index == 0) {
            [weakSelf showCamera:(UIImagePickerControllerSourceTypeCamera)];
        }else if(index == 1){
            [weakSelf showCamera:(UIImagePickerControllerSourceTypePhotoLibrary)];
        }
    }];
    [sheet showActionSheetInView:nil];
    
}

//删除照片
-(void)deleteImageAction:(UIButton*)sender{
    __weak PhotoCollectionView *weakSelf = self;
    [GHUDAlertUtils showZXColorAlert:MultiLanguage(scovcPhotoDelete) subTitle:@"" cancleButton:MultiLanguage(comCancel) sureButtonTitle:MultiLanguage(comSure)  COLORButtonType:(RED_BUTTON_TYPE) buttonHeight:35 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
        if (index == 1) {
            [weakSelf deleteShowImage:sender.tag];
            [weakSelf updateShowFrame];
            [weakSelf.presThumbnailCollectionView reloadData];
        }
    }];
    
}

//显示相机或者相册
-(void)showCamera:(UIImagePickerControllerSourceType)type{
    
    NSUInteger sourceType;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        sourceType = type;
    }else {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    imagePickerController.navigationBar.hidden = NO;
    imagePickerController.view.backgroundColor = [UIColor whiteColor];
    
    if (self.parentController) {
        BOOL isAnimated = (UIImagePickerControllerSourceTypePhotoLibrary == sourceType);
        [self.parentController presentViewController:imagePickerController animated:isAnimated completion:nil];
    }
}

-(void)updateShowFrame{
    
    NSInteger rowcount = (self.showPhotoArray.count - 1) / PhotoCountOneRow + 1;
    CGFloat height = rowcount * (_photoCellHeight+PhotoLineSpacing) + PhotoFooterHeight;
    
    if(height != self.presThumbnailCollectionView.frame.size.height){
        if (self.delegate) {
            [self.delegate photosViewFrameDidChanged:height];
        }
        
        CGRect selfRC = self.frame;
        selfRC.size.height = height;
        self.frame = selfRC;
        
        CGRect colRC = self.presThumbnailCollectionView.frame;
        colRC.size.height = height;
        self.presThumbnailCollectionView.frame = colRC;
    }
}

- (NSMutableDictionary*)photosDataInfo
{
    NSMutableDictionary *photosInfo = [NSMutableDictionary dictionary];
    for (NSInteger index = 0; index < [self.showPhotoArray count] - 1; index++) {
        UIImage *image = self.showPhotoArray[index];
        NSString *key = self.showPhotoNameArray[index];
        [photosInfo setObject:image forKey:key];
    }
    
    return photosInfo;
}

- (NSMutableArray*)getPhotoArray{
    NSMutableArray *photos = [NSMutableArray array];
    for (NSInteger index = 0; index < [self.showPhotoArray count] - 1; index++) {
        UIImage *image = self.showPhotoArray[index];
        [photos addObject:image];
    }
    return photos;
}

- (BOOL)haveValidPhotos
{
    return (self.showPhotoArray.count > 1);
}

@end
