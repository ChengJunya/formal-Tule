//
//  TLUserOrgListView.m
//  TL
//
//  Created by YONGFU on 6/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLUserOrgListView.h"
#import "RUILabel.h"
#import "TLOrgDataDTO.h"

@implementation TLUserOrgListView

- (instancetype)initWithFrame:(CGRect)frame list:(NSArray *)list
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_WHITE_BG;
        self.list = list;
        [self setupViews];
    }
    return self;
}

-(void)setupViews{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scroll];
    __block CGFloat xOffSet = UI_Comm_Margin;
    
    [self.list enumerateObjectsUsingBlock:^(TLOrgDataDTO* obj, NSUInteger idx, BOOL *stop) {
        RUILabel *name = [[RUILabel alloc] initWithFrame:CGRectZero str:obj.organizationName font:FONT_16 color:COLOR_MAIN_TEXT];
        
        [name setX:xOffSet andY:(self.height-name.height)/2];
        xOffSet = xOffSet + UI_Comm_Margin + name.width;
        [scroll addSubview:name];
    }];
    
    [scroll setContentSize:CGSizeMake(xOffSet, scroll.height)];
    
    
}

@end
