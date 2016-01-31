//
//  TLDropMenu.m
//  TL
//
//  Created by Rainbow on 2/9/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLDropMenu.h"

#define TLDROPMENU_ITEM_HEIGHT 40.f
#define TLDROPMENU_COLUMN_COUNT 3

@interface TLDropMenu()
@property (nonatomic,assign) CGFloat menuHieght;
@property (nonatomic,assign) CGFloat frameHeight;
@property (nonatomic,strong) NSMutableArray *btnArray;
@property (nonatomic,strong) UIView *menuContentView;
@end

@implementation TLDropMenu

- (instancetype)initWithFrame:(CGRect)frame menuData:(id)menuData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.2f);
        _frameHeight = CGRectGetHeight(frame);
        _menuData = menuData;
        _btnArray = [[NSMutableArray alloc] init];
        [self setUpView];
 
        
    }
    return self;
}

//1- 一行显示4个，多行显示 按数据来显示
//2- 提供隐藏显示接口
//3- 提供选择的block
//4- 颜色标识

-(void)setUpView{
    NSArray *menuData = self.menuData;// ID NAME
    NSUInteger count = [menuData count];
    NSUInteger rowCount = count%TLDROPMENU_COLUMN_COUNT==0?count/TLDROPMENU_COLUMN_COUNT:count/TLDROPMENU_COLUMN_COUNT+1;
    CGRect newFrame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), TLDROPMENU_ITEM_HEIGHT*rowCount) ;
    self.menuContentView = [[UIView alloc] initWithFrame:newFrame];
    [self addSubview:self.menuContentView];
    self.menuContentView.backgroundColor = COLOR_DEF_BG;
    self.menuContentView.layer.masksToBounds = YES;
    
    
    [self setBounds:newFrame];
    [self setFrame:newFrame];
    _menuHieght = newFrame.size.height;
    CGFloat itemWidth = CGRectGetWidth(self.frame)/TLDROPMENU_COLUMN_COUNT;
    
    
    [menuData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat i = idx%TLDROPMENU_COLUMN_COUNT;
        CGFloat j = idx/TLDROPMENU_COLUMN_COUNT;
        
        CGFloat x = i*itemWidth;
        CGFloat y = j*TLDROPMENU_ITEM_HEIGHT;
        
        CGRect itemFrame = CGRectMake(x, y, itemWidth, TLDROPMENU_ITEM_HEIGHT);
        //
        UIButton *itemBtn = [[UIButton alloc] initWithFrame:itemFrame];
        [itemBtn addTarget:self action:@selector(btnHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuContentView addSubview:itemBtn];
        [itemBtn setTitle:[obj valueForKey:@"NAME"] forState:UIControlStateNormal];
        [itemBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
        [itemBtn setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateSelected];
        itemBtn.titleLabel.font = FONT_16;
        if ([@"1" isEqualToString:[obj valueForKey:@"ISSELECTED"]]) {
            itemBtn.selected = YES;
        }
        [_btnArray addObject:itemBtn];
        
        //line
        if (i==0&&j<rowCount-1) {
            CALayer *hlineLayer = [CALayer layer];
            hlineLayer.frame = CGRectMake(0.f, (j+1)*TLDROPMENU_ITEM_HEIGHT, self.width, 0.5f);
            hlineLayer.backgroundColor = UIColorFromRGBA(0xf2d494, 0.5).CGColor;
            [self.layer addSublayer:hlineLayer];
        }
        
    }];
}
-(void)btnHandler:(UIButton*)btn{
    [self.btnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *tmpBtn = obj;
        tmpBtn.selected = NO;
    }];
    btn.selected = YES;
    
    NSUInteger selectedIndex = [self.btnArray indexOfObject:btn];
     NSArray *menuData = self.menuData;// ID NAME
    id itemData = [menuData objectAtIndex:selectedIndex];
    _selectedItem = itemData;
    
    if (self.ItemSelectedBlock) {
        self.ItemSelectedBlock(self.selectedItem);
    }
}

- (void)handleTapGesture:(UIGestureRecognizer *)tapGesture
{
    self.isMenuHidden = YES;
    
}


-(void)setIsMenuHidden:(BOOL)isMenuHidden{
    _isMenuHidden = isMenuHidden;
    if (_isMenuHidden) {
        CGRect newFrame = CGRectMake(self.x, self.y, CGRectGetWidth(self.frame), 0.f) ;
        [UIView animateWithDuration:0.2f animations:^{
            
                self.alpha = 0.f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{
                self.frame = newFrame;

            } completion:^(BOOL finished) {
               
            }];
        }];
        
    }else{
         CGRect newFrame = CGRectMake(self.x, self.y, CGRectGetWidth(self.frame), _frameHeight) ;
        [UIView animateWithDuration:0.2f animations:^{
            self.frame = newFrame;

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{

                self.alpha = 1.f;
            } completion:^(BOOL finished) {

            }];
        }];
    }
}

-(void)setSelectedItem:(id)selectedItem{
    _selectedItem = selectedItem;
     NSArray *menuData = self.menuData;// ID NAME
    [menuData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[_selectedItem valueForKey:@"ID"] isEqualToString:[obj valueForKey:@"ID"]]) {
            UIButton *btn = [self.btnArray objectAtIndex:idx];
            [self.btnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UIButton *tmpBtn = obj;
                tmpBtn.selected = NO;
            }];
            btn.selected = YES;
        }
    }];
}

@end
