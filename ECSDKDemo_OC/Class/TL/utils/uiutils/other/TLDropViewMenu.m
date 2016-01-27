//
//  TLDropViewMenu.m
//  TL
//
//  Created by Rainbow on 2/9/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLDropViewMenu.h"
#import "RTextIconBtn.h"
#define TLDROPMENU_ITEM_HEIGHT 40.f
@interface TLDropViewMenu()
@property (nonatomic,assign) CGFloat menuHieght;



@property (nonatomic,strong) UIView *menuContentView;
@property (nonatomic,strong) UIView *mainContentView;//添加按钮视图
@property (nonatomic,assign) NSUInteger currentBtnIndex;
@end
@implementation TLDropViewMenu




- (instancetype)initWithFrame:(CGRect)frame menuData:(id)menuData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;

        _frameHeight = CGRectGetHeight(frame);
        _menuHieght = TLDROPMENU_ITEM_HEIGHT;
        _menuData = menuData;
        _btnArray = [[NSMutableArray alloc] init];
        [self setUpView];
        //[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        
    }
    return self;
}

//1- 一行显示多个按钮
//2- 每一个按钮设置一个视图
//2- 提供隐藏显示接口 通过视图的大小来确定显示的高度
//3- 提供选择的block
//4- 颜色标识

-(void)setUpView{
    NSArray *menuData = self.menuData;// ID NAME
    NSUInteger count = [menuData count];
    CGFloat itemWidth = CGRectGetWidth(self.frame)/count;
    CGRect newFrame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), TLDROPMENU_ITEM_HEIGHT) ;
    self.menuContentView = [[UIView alloc] initWithFrame:newFrame];
    [self addSubview:self.menuContentView];

    self.menuContentView.backgroundColor = COLOR_DEF_BG;
    self.menuContentView.layer.masksToBounds = YES;
    
    [menuData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        
        CGFloat x = idx*itemWidth;
        CGFloat y = 0.f;
        
        CGRect itemFrame = CGRectMake(x, y, itemWidth, TLDROPMENU_ITEM_HEIGHT);
        //
        RTextIconBtn *itemBtn = [[RTextIconBtn alloc] initWithFrame:itemFrame];
        [itemBtn addTarget:self action:@selector(btnHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuContentView addSubview:itemBtn];
        [itemBtn setTitle:[obj valueForKey:@"NAME"] forState:UIControlStateNormal];
        [itemBtn setTitleColor:COLOR_MAIN_TEXT forState:UIControlStateNormal];
        [itemBtn setTitleColor:COLOR_ORANGE_TEXT forState:UIControlStateSelected];
        itemBtn.titleLabel.font = FONT_16;
        [itemBtn setImage:[UIImage imageNamed:@"down2"] forState:UIControlStateNormal];
        [itemBtn setImage:[UIImage imageNamed:@"up2"] forState:UIControlStateSelected];

        if ([@"1" isEqualToString:[obj valueForKey:@"ISSELECTED"]]) {
            itemBtn.selected = YES;
        }
        [_btnArray addObject:itemBtn];
        
        //line
        CALayer *hlineLayer = [CALayer layer];
        hlineLayer.frame = CGRectMake(0.f, TLDROPMENU_ITEM_HEIGHT-0.5f, self.width, 0.5f);
        hlineLayer.backgroundColor = UIColorFromRGBA(0x000000, 0.5).CGColor;
        [self.layer addSublayer:hlineLayer];
        
        if (0<x<=count) {
            CALayer *vlineLayer = [CALayer layer];
            vlineLayer.frame = CGRectMake(x, 0.f, 0.5, TLDROPMENU_ITEM_HEIGHT);
            vlineLayer.backgroundColor = UIColorFromRGBA(0x000000, 0.5).CGColor;
            [self.layer addSublayer:vlineLayer];
        }
        
      
        
    }];
}

//- (void)handleTapGesture:(UIGestureRecognizer *)tapGesture
//{
//    self.isMenuHidden = YES;
//}


-(void)btnHandler:(UIButton*)btn{
     NSUInteger selectedIndex = [self.btnArray indexOfObject:btn];
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
        [self addSubViewByIndex:selectedIndex];
    }
   
    self.currentBtnIndex = selectedIndex;
    [self.btnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *tmpBtn = obj;
        if (idx != selectedIndex) {
            tmpBtn.selected = NO;
        }
        
    }];
    
    self.isMenuHidden = !btn.selected;
    
//    NSUInteger selectedIndex = [self.btnArray indexOfObject:btn];
//    NSArray *menuData = self.menuData;// ID NAME
//    id itemData = [menuData objectAtIndex:selectedIndex];
//    if (self.ItemSelectedBlock) {
//        self.ItemSelectedBlock(itemData);
//    }
    
}
-(void)setIsMenuHidden:(BOOL)isMenuHidden{
    _isMenuHidden = isMenuHidden;
    if (_isMenuHidden) {
        CGRect newFrame = CGRectMake(self.x, self.y, CGRectGetWidth(self.frame), _menuHieght) ;
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = newFrame;
            //self.alpha = 0.f;
        } completion:^(BOOL finished) {
            //self.hidden = YES;
        }];
        
        
        [self.btnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *tmpBtn = obj;
                tmpBtn.selected = NO;
        }];
        
    }else{
        CGRect newFrame = CGRectMake(self.x, self.y, CGRectGetWidth(self.frame), _frameHeight) ;
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = newFrame;
        } completion:^(BOOL finished) {
            //self.hidden = NO;
        }];
    }
}

-(void)addSubViewByIndex:(NSUInteger)index{
    
    if (self.mainContentView) {
        [self.mainContentView removeFromSuperview];
    }
    

    
    UIView *subView = [self.viewArray objectAtIndex:index];
    self.mainContentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, TLDROPMENU_ITEM_HEIGHT, subView.width, subView.height)];
    [self addSubview:self.mainContentView];
    [self.mainContentView addSubview:subView];
}
@end
