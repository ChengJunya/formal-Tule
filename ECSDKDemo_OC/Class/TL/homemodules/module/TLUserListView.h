//
//  TLUserListView.h
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLUserListView : UIView
@property (nonatomic,strong) id itemData;
@property (nonatomic,assign) BOOL isShowImageName;
@property (nonatomic,assign) int type;//1-group other user  
- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData isShowImageName:(BOOL)isShowImageName;

- (instancetype)initWithFrame:(CGRect)frame itemData:(id)itemData;
@end
