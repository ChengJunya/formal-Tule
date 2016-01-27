//
//  RImageList.h
//  TL
//
//  Created by Rainbow on 2/25/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RImageList : UIView
@property (nonatomic,strong) id itemData;
@property (nonatomic,assign) BOOL isShowImageName;
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData isShowImageName:(BOOL)isShowImageName;
@end
