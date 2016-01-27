//
//  CMenuView.h
//  ContractManager
//
//  Created by Rainbow on 12/17/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MENU_ITEM_GAP 8.0f

@protocol CMenuViewDelegate <NSObject>

-(void)itemClick:(NSDictionary *)itemData;


@end

@interface CMenuView : UIView
@property (nonatomic,strong) NSArray *menuData;
@property (nonatomic,assign) CGFloat itemHeight;
@property (nonatomic,assign) CGFloat itemWidth;
@property (nonatomic,assign) CGFloat contentHeight;
@property (nonatomic,assign) NSUInteger columnCount;
@property (nonatomic,assign) NSUInteger rowCount;
@property (nonatomic,weak) id<CMenuViewDelegate> delegate;

-(void)randerViewWithData:(NSArray*)menuData;
@end
