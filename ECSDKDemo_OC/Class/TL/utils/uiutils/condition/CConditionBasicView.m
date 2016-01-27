//
//  CConditionBasicView.m
//  ContractManager
//
//  Created by Rainbow on 12/19/14.
//  Copyright (c) 2014 BONC. All rights reserved.
//

#import "CConditionBasicView.h"

@implementation CConditionBasicView
@synthesize selectBtn=_selectBtn;
-(NSDictionary *)getConditionData{
    return nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)cancel{
    [self.selectBtn setTitle:[self.selectedItem valueForKey:@"name"] forState:UIControlStateNormal];
}
-(void)ok{
    if (self.currentSelectedItem) {
        self.selectedItem = self.currentSelectedItem;
    }
}

@end
