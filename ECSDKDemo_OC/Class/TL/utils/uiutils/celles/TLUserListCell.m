//
//  TLUserListCell.m
//  TL
//
//  Created by Rainbow on 2/21/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLUserListCell.h"
#import "TLUserListView.h"
@implementation TLUserListCell

-(void)initContent{

    self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    CGFloat yOffSet = 0.f;

    
    
    if (self.cellContentView) {
        [self.cellContentView removeFromSuperview];
        self.cellContentView = nil;
    }
    
    self.cellContentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.cellContentView];
    
    CGFloat userListViewHeight = 120.f;
    TLUserListView *userListView = [[TLUserListView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.cellContentView.frame), userListViewHeight) itemData:self.cellData];
    [self.cellContentView addSubview:userListView];

    self.cellHeight = CGRectGetHeight(userListView.frame);
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    // Configure the view for the selected state
    if (selected) {
        NSLog(@"selected");
        self.backgroundColor = UIColorFromRGBA(0xffffff, 0.5);
        
        //[self action];
        
    }else{
        NSLog(@"unSelected");
        self.backgroundColor = UIColorFromRGBA(0xffffff, 0.5);
    }
    
}

@end
