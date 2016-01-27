//
//  TLDropMenu.h
//  TL
//
//  Created by Rainbow on 2/9/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLDropMenu : UIView
@property (nonatomic,strong) id menuData;
@property(nonatomic,copy) void (^ItemSelectedBlock)(id itemData);
@property(nonatomic,assign) BOOL isMenuHidden;
@property(nonatomic,strong) id selectedItem;

- (instancetype)initWithFrame:(CGRect)frame menuData:(id)menuData;
@end
