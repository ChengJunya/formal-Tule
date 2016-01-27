//
//  NavbarMessTipItem.m
//  alijk
//
//  Created by easy on 15/3/10.
//  Copyright (c) 2015年 zhongxin. All rights reserved.
//

#import "NavbarMessTipItem.h"
#import "SuperViewController.h"
#import "KxMenu.h"


@interface NavbarMessTipItem()

@property (nonatomic, weak) SuperViewController *attachVC;
@property (nonatomic, assign) NSInteger navMsgCount;

@end


@implementation NavbarMessTipItem


- (id)initButton{
    UIImage *image = [UIImage imageNamed:@"mess_tip"];
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    infoBtn.frame = CGRectMake(0.f, 0.f, 23.f, 23.f);
    [infoBtn setBackgroundImage:image forState:UIControlStateNormal];
    [infoBtn setBackgroundImage:image forState:UIControlStateDisabled];
    
    if (self = [super initWithCustomView:infoBtn]) {
    
        [infoBtn addTarget:self action:@selector(navMessageAction:) forControlEvents:UIControlEventTouchDown];
    }
    
    return self;
}



#pragma mark -
#pragma mark - action


-(void)navMessageAction:(id)sender
{
    [self showExpandMenu:sender];
}


- (void)navExpandMenuDeleteAction
{
    
}


- (void)showExpandMenu:(UIButton*)sender
{
    NSArray *menuItems;
    
   
    
    KxMenuItem *item1 = [KxMenuItem menuItem:@"删除"
                                       image:[UIImage imageNamed:@"more_xiaoxi"]
                                      extNum:0
                                      target:self
                                      action:@selector(navExpandMenuDeleteAction)];
    KxMenuItem *item2 = [KxMenuItem menuItem:@"添加"
                                       image:[UIImage imageNamed:@"more_home"]
                                      extNum:0
                                      target:self
                                      action:@selector(navExpandMenuDeleteAction)];
    
   
    
    
    menuItems = @[item1, item2];
    
    KxMenuItem *first = menuItems[0];
    first.alignment = NSTextAlignmentLeft;
    
    CGRect rect = sender.frame;
    rect.size = CGSizeMake(40.f, 40.f);
    [KxMenu showMenuInView:self.attachVC.navigationController.view
                  fromRect:rect
                 menuItems:menuItems];
    
}



@end
