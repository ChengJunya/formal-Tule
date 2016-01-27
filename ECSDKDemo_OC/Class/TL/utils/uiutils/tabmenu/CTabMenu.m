//
//  CTabMenu.m
//  ContractManager
//
//  Created by Rainbow on 12/19/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "CTabMenu.h"
@implementation CTabMenu
@synthesize menuData=_menuData,selectedIndex=_selectedIndex;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         self.btnArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame menuData:(NSArray *)menuData{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.btnArray = [[NSMutableArray alloc] init];
        self.menuData = menuData;

    }
    return self;
}

-(void)createMenu{
    CGRect frame = self.frame;
    self.menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    [self.menuScrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:self.menuScrollView];
    
    NSUInteger itemCount = [self.menuData count];
    CGFloat itemHeight = CGRectGetHeight(frame);
    CGFloat itemWidth = CGRectGetWidth(frame)/itemCount;
    if (itemWidth < CTAB_MENU_ITEM_MIN_WIDTH) {
        itemWidth = CTAB_MENU_ITEM_MIN_WIDTH;
        [self.menuScrollView setContentSize:CGSizeMake(itemWidth*itemCount, self.menuScrollView.contentSize.height)];
    }
    
    [self.menuData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIButton *itemBtn = [[UIButton alloc] initWithFrame:CGRectMake(itemWidth*idx, 0.0f, itemWidth, itemHeight)];
        itemBtn.tag = idx+453;
        if (idx==0) {
            [itemBtn setSelected:YES];
        }
        [self setBtnBackgroundColor:itemBtn selected:itemBtn.selected];
        
        [itemBtn setTitle:[obj valueForKey:@"NAME"] forState:UIControlStateNormal];
        [itemBtn addTarget:self action:@selector(itemSelectHandler:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [itemBtn setTitleColor:UIColorFromRGB(0xffa800) forState:UIControlStateSelected];
        itemBtn.titleLabel.font = FONT_16;
        [self.menuScrollView addSubview:itemBtn];
        
        [self.btnArray addObject:itemBtn];

        
    }];
    
    self.underLineLayer = [CALayer layer];
    [self.underLineLayer setFrame:CGRectMake(0.0f, itemHeight-CTAB_MENU_UNDERLINE_WIDTH, itemWidth, CTAB_MENU_UNDERLINE_WIDTH)];
    [self.underLineLayer setBackgroundColor:UIColorFromRGB(0xffa800).CGColor];
    [self.menuScrollView.layer addSublayer:self.underLineLayer];
}


-(void)itemSelectHandler:(UIButton *)btn{
    [self.btnArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *tmpBtn = obj;
        if(tmpBtn.tag == btn.tag){
            [btn setSelected:YES];
            [self setBtnBackgroundColor:btn selected:YES];
            [self moveUnderLine:btn];
            
            if(self.MenuItemSelectedBlock)
            {

                NSDictionary *itemData = [self.menuData objectAtIndex:btn.tag-453];
                self.MenuItemSelectedBlock(itemData);
            }
        }else{
            [tmpBtn setSelected:NO];
            [self setBtnBackgroundColor:tmpBtn selected:NO];
        }
    }];
    
}

-(void)selectButtonByIndex:(int)index{
    UIButton *toButton = [self.btnArray objectAtIndex:index];
    [self itemSelectHandler:toButton];
}

-(void)setBtnBackgroundColor:(UIButton*)btn selected:(BOOL)selected{
    if (selected) {
        btn.layer.backgroundColor = UIColorFromRGB(0xdcdcdc).CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        self.selectedIndex = btn.tag-453;
    }else{
        btn.layer.backgroundColor = UIColorFromRGB(0xdcdcdc).CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
    }
}

-(void)moveUnderLine:(UIButton *)btn{
   
    
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"x"];
    
    animation.toValue= [NSNumber numberWithInt:btn.frame.origin.x];
    animation.fromValue= [NSNumber numberWithFloat:self.underLineLayer.frame.origin.x];
    animation.duration=3;
    
    //animation.removedOnCompletion=NO;
    
    //animation.fillMode=kCAFillModeForwards;
    
        //self.underLineLayer.frame = CGRectMake(btn.frame.origin.x,self.underLineLayer.frame.origin.y,CGRectGetWidth(self.underLineLayer.frame),CGRectGetHeight(self.underLineLayer.frame));
    
    [self.underLineLayer addAnimation:animation forKey:nil];
    
    
    [self.underLineLayer setFrame:CGRectMake(btn.frame.origin.x,self.underLineLayer.frame.origin.y,CGRectGetWidth(self.underLineLayer.frame),CGRectGetHeight(self.underLineLayer.frame))];
    

    CGRect lineFrame = self.underLineLayer.frame;
    CGPoint currentOffSet = self.menuScrollView.contentOffset;
    if (lineFrame.origin.x>=320) {
        if (self.menuScrollView.contentOffset.x>=self.menuScrollView.contentSize.width-self.menuScrollView.frame.size.width) {
            
        }else{
           currentOffSet = CGPointMake(self.menuScrollView.contentOffset.x+CTAB_MENU_ITEM_MIN_WIDTH, self.menuScrollView.contentOffset.y);
            
        }
        
    }else{
        if (self.menuScrollView.contentOffset.x<=0) {
            
        }else{
            currentOffSet = CGPointMake(self.menuScrollView.contentOffset.x-CTAB_MENU_ITEM_MIN_WIDTH, self.menuScrollView.contentOffset.y);
            
        }
    }
    
    //动画设置高度
    [UIView animateWithDuration:1.0f animations:^{
        [self.menuScrollView setContentOffset:currentOffSet];
    } completion:^(BOOL finished) {
        
        
    }];
    

    
}
@end
