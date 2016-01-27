//
//  CMultySelectView.h
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMultySelectView : UIView
@property (nonatomic,strong) NSMutableArray *dataArray;
-(void)addViews;
-(NSString*)getSelectedIds;
-(NSString*)getSelectedNames;
@end
