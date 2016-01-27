//
//  TLUserOrgListView.h
//  TL
//
//  Created by YONGFU on 6/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLUserOrgListView : UIView
@property (nonatomic,strong) NSArray *list;
- (instancetype)initWithFrame:(CGRect)frame list:(NSArray *)list;
@end
