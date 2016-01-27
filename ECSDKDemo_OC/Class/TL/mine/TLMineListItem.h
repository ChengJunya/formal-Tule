//
//  TLMineListItem.h
//  TL
//
//  Created by Rainbow on 2/26/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLMineListItem : UIButton
@property (nonatomic,strong) id itemData;
@property (nonatomic,assign) BOOL isShowAction;
@property (nonatomic,assign) CGSize imageSize;
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData;
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData isShowAction:(BOOL)isShowAction;
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData isShowAction:(BOOL)isShowAction imageSize:(CGSize)imageSize;
@end
