//
//  PhotoCollectionViewFooter.h
//  alijk
//
//  Created by zhangyang on 14-9-16.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewFooter : UICollectionReusableView

@property (nonatomic,assign) NSInteger maxImageCount;
@property (nonatomic,assign)NSInteger currentCount;
@property (nonatomic,assign)NSInteger leftCount;

- (id)initWithFrame:(CGRect)frame maxImageCount:(NSInteger)maxImageCount;

@end
