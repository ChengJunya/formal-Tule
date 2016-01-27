//
//  ALiLogButton.m
//  alijk
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 zhongxin. All rights reserved.
//

#import "ALiLogButton.h"
#import "ALiLogger.h"
@implementation ALiLogButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.height/2;
        [self setTitle:@"日志" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor grayColor]];
        [self addTarget:self action:@selector(logShowBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)logShowBtnHandler:(id)btn{
    [[ALiLogger sharedInstance] showLogView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
