//
//  CTabMenu.h
//  ContractManager
//
//  Created by Rainbow on 12/19/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CTAB_MENU_UNDERLINE_WIDTH 2.0f
#define CTAB_MENU_ITEM_MIN_WIDTH 80.0f


@interface CTabMenu : UIView
@property (nonatomic,strong) NSArray *menuData;
@property (nonatomic,strong) CALayer *underLineLayer;
@property (nonatomic,strong) UIScrollView *menuScrollView;
@property (nonatomic,strong) NSMutableArray *btnArray;
@property (nonatomic,copy) void (^MenuItemSelectedBlock)(id itemData);
@property (nonatomic,assign) int selectedIndex;
-(instancetype)initWithFrame:(CGRect)frame menuData:(NSArray *)menuData;
-(void)createMenu;
-(void)selectButtonByIndex:(int)index;
@end
