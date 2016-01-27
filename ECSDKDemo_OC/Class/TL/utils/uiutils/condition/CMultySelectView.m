//
//  CMultySelectView.m
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "CMultySelectView.h"
#import "CPickerRowView.h"

@interface  CMultySelectView(){
    
}

@property (nonatomic,strong) NSMutableArray *viewArray;

@end
@implementation CMultySelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       self.viewArray = [NSMutableArray array];
    }
    return self;
}

-(void)addViews{
    UIScrollView *contentScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    contentScroll.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:contentScroll];
    
    for (int idx=0; idx<self.dataArray.count; idx++) {
        id obj = self.dataArray[idx];
        CPickerRowView *item = [[CPickerRowView alloc] initWithFrame:CGRectMake(0.f, 0.f+idx*30.f, CGRectGetWidth(self.frame), 30.f) itemData:obj];
        [item addViews];
        [contentScroll addSubview:item];
        
        [self.viewArray addObject:item];
    }
    
    
}

-(NSString*)getSelectedIds{
    __block NSMutableString *ids = [NSMutableString stringWithString:@""];
    [self.viewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CPickerRowView *view = obj;
        NSDictionary *itemData = view.itemData;
        if (view.isSelected) {
            
            [ids appendString:[itemData valueForKey:@"id"]];
            [ids appendString:@","];
        }
        
        
    }];
    if (ids.length>0) {
        return [ids substringToIndex:ids.length-1];
    }
    return ids;
}

-(NSString*)getSelectedNames{
    __block NSMutableString *ids = [NSMutableString stringWithString:@""];
    [self.viewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CPickerRowView *view = obj;
        NSDictionary *itemData = view.itemData;
        if (view.isSelected) {
            
            [ids appendString:[itemData valueForKey:@"name"]];
            [ids appendString:@","];
        }
        
        
    }];
    if (ids.length>0) {
        return [ids substringToIndex:ids.length-1];
    }
    return ids;
}


@end
