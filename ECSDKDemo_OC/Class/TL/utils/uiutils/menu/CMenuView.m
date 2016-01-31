//
//  CMenuView.m
//  ContractManager
//
//  Created by Rainbow on 12/17/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "CMenuView.h"
#import "RImageBtn.h"
@implementation CMenuView

@synthesize menuData=_menuData,delegate=_delegate;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _columnCount = 4;
        _rowCount = 2;

    }
    return self;
}

-(void)randerViewWithData:(NSArray*)menuData{
    self.menuData = menuData;
    [self createMenuWithFrame:self.frame];
}


-(void)createMenuWithFrame:(CGRect)frame{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame))];
     [self addSubview:scroll];
    

    NSDictionary *dic14b = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14B,NSFontAttributeName, nil];
    CGSize menuNameSize = [@"SIZE" sizeWithAttributes:dic14b];
    
    
    // 3 height/width = 122/155
    self.itemWidth = (CGRectGetWidth(frame)-MENU_ITEM_GAP*(_columnCount*2))/_columnCount;
    self.itemHeight = (CGRectGetHeight(frame)-MENU_ITEM_GAP*(_rowCount*2))/_rowCount;
    
    CGFloat imageWidth = self.itemWidth;
    CGFloat imageHight = self.itemHeight;
    
    double a = (self.itemHeight-menuNameSize.height)/self.itemWidth;
    double b = 122.f/155.f;
    
    if (a>b) {
        imageHight= 122*self.itemWidth/155;
        imageWidth = self.itemWidth;
        
    }else{
        imageWidth = (self.itemHeight-menuNameSize.height)*155/122;
        imageHight = self.itemHeight-menuNameSize.height;
    }
    
    NSUInteger menuCount = [self.menuData count];
    self.contentHeight = menuCount%_columnCount==0?menuCount/_columnCount*(self.itemHeight+MENU_ITEM_GAP*2):(menuCount/_columnCount+1)*(self.itemHeight+MENU_ITEM_GAP*2);
    
    [scroll setContentSize:CGSizeMake(CGRectGetWidth(frame), self.contentHeight)];
    
    NSUInteger hLineCount = _rowCount-1;//menuCount%_columnCount==0?menuCount/_columnCount: menuCount/_columnCount+1;
    for (int i=0; i < hLineCount; i++) {
        
        
        UIImage *hImage = [[UIImage imageNamed:@"horizontalLine"] stretchableImageWithLeftCapWidth:20.0 topCapHeight:0.0];
        
        UIImageView *horizontalLineOneImageView = [[UIImageView alloc] initWithImage:hImage];
        [horizontalLineOneImageView setFrame:CGRectMake(MENU_ITEM_GAP, (i+1)*(MENU_ITEM_GAP+self.itemHeight+MENU_ITEM_GAP), CGRectGetWidth(scroll.frame)-MENU_ITEM_GAP*2, 2.0f)];
        [scroll addSubview:horizontalLineOneImageView];
    }
    
    
    
    for (int i=0; i < (_columnCount - 1); i++) {
        UIImage *vImage = [[UIImage imageNamed:@"verticalLine"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:120.0];
        UIImageView *verticalLineOneImageView = [[UIImageView alloc] initWithImage:vImage];
        [verticalLineOneImageView setFrame:CGRectMake((i+1)*(MENU_ITEM_GAP+self.itemWidth+MENU_ITEM_GAP), MENU_ITEM_GAP, 2.0f, self.contentHeight-MENU_ITEM_GAP*2)];
        [scroll addSubview:verticalLineOneImageView];
    }
    
    
    [self.menuData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSUInteger columnIndex = idx % _columnCount;//0-1列 1-2列 2-3列
        NSUInteger rowIndex = idx / _columnCount;//0-1行
        
        NSString *menuName = [obj valueForKey:@"NAME"];
        

        UIButton *itemBtn = [[UIButton alloc] initWithFrame:CGRectMake(MENU_ITEM_GAP+(self.itemWidth+MENU_ITEM_GAP*2)*columnIndex, MENU_ITEM_GAP+(self.itemHeight+MENU_ITEM_GAP*2)*rowIndex, self.itemWidth, self.itemHeight)];
        [scroll addSubview:itemBtn];
        [itemBtn addTarget:self action:@selector(onItemSelectHandler:) forControlEvents:UIControlEventTouchUpInside];

        CGRect imageFrame = CGRectMake((self.itemWidth-imageWidth)/2,(self.itemHeight-imageHight-menuNameSize.height)/2,imageWidth,imageHight);
        
        NSString *iconName = [obj valueForKey:@"IMG"];
        RImageBtn *imageBtn = [[RImageBtn alloc] initWithFrameImageTitle:imageFrame btnImage:iconName btnTitle:@""];
        [itemBtn setTag:idx];
        [imageBtn setTag:idx];
        [imageBtn addTarget:self action:@selector(onItemSelectHandler:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn addSubview:imageBtn];

        UILabel *menuNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(imageFrame), self.itemWidth, menuNameSize.height)];
        menuNameLabel.text = menuName;
        menuNameLabel.font = FONT_14B;
        menuNameLabel.textColor = COLOR_MAIN_TEXT;
        menuNameLabel.textAlignment = NSTextAlignmentCenter;
        [itemBtn addSubview:menuNameLabel];
    }];
    
    
   
}

-(void)onItemSelectHandler:(UIButton *)btn{
    
    if([self.delegate respondsToSelector:@selector(itemClick:)])
    {
        NSDictionary *itemData = [self.menuData objectAtIndex:btn.tag];
        [self.delegate itemClick:itemData];
    }
    
}
@end
