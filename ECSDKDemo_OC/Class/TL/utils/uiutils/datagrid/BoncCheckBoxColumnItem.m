//
//  BoncCheckBoxColumnItem.m
//  ContractManager
//
//  Created by Rainbow on 12/21/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "BoncCheckBoxColumnItem.h"
#import "RImageBtn.h"
@implementation BoncCheckBoxColumnItem


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    
    CGFloat imageWidth = 30.0f;
    NSString *columnText = [self.rowData valueForKey:self.code];
    RImageBtn *checkBtn = [[RImageBtn alloc] initWithFrameImageStateTitle:CGRectMake(10.0f, (CGRectGetHeight(rect)-imageWidth)/2, imageWidth, imageWidth) btnImage:@"checkBoxUnSelected.png" selectedImage:@"checkBoxSelected.png" highLightedImage:@"checkBoxHighlight.png" btnTitle:@""];
    [checkBtn addTarget:self action:@selector(checkBoxBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    if ([@"0" isEqualToString:columnText]) {
        [checkBtn setSelected:NO];
    }else{
        [checkBtn setSelected:YES];
    }
    [self addSubview:checkBtn];
    
}

-(void)checkBoxBtnHandler:(RImageBtn *)btn{
    if (btn.selected) {
        [btn setSelected:NO];
    }else{
        [btn setSelected:YES];
    }
}


@end
