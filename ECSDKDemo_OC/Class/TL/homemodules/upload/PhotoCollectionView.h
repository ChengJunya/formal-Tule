//
//  PhotoCollectionView.h
//  alijk
//
//  Created by zhangyang on 14-10-10.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotosViewDelegate <NSObject>

/*高度变化*/
-(void)photosViewFrameDidChanged:(CGFloat)height;

@end

@interface PhotoCollectionView : UIView

-(id)initWithFrame:(CGRect)frame andImage:(UIImage*)image;

@property (nonatomic, weak) UIViewController* parentController;//父controller
@property (nonatomic, weak)id<PhotosViewDelegate> delegate;
@property (nonatomic, readonly) NSMutableDictionary* photosDataInfo;//存储 名称：图片
@property (nonatomic,assign) int maxPhotoNum;//默认8张
@property (nonatomic,strong) NSString *photoInfo;

-(void)updateShowFrame;
- (BOOL)haveValidPhotos;
- (void)addImageAction;
- (void)addShowImage:(UIImage*)image;
- (NSMutableArray*)getPhotoArray;

@end

