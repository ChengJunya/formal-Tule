//
//  TLDropViewMenu.h
//  TL
//
//  Created by Rainbow on 2/9/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TLDROPMENU_ITEM_HEIGHT 40.f
#define TLDROPMENU_COLUMN_COUNT 3
@interface TLDropViewMenu : UIView
@property (nonatomic,strong) id menuData;
@property (nonatomic,assign) CGFloat frameHeight;
@property(nonatomic,copy) void (^ItemSelectedBlock)(id itemData);
@property(nonatomic,assign) BOOL isMenuHidden;
@property(nonatomic,strong) id selectedItem;
@property (nonatomic,strong) NSMutableArray *viewArray;
@property (nonatomic,strong) NSMutableArray *btnArray;
- (instancetype)initWithFrame:(CGRect)frame menuData:(id)menuData;

@end
