//
//  TLSelectWaybookViewController.h
//  TL
//
//  Created by Rainbow on 2/16/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "SuperViewController.h"

@interface TLSelectWaybookViewController : UIViewController
@property (nonatomic,copy) void (^ItemSelectedBlock)(id itemData);
@property (nonatomic,copy) void (^NewItemSelectedBlock)(id itemData);
@property (nonatomic,strong) NSString *type;


-(instancetype)initWIthType:(NSString*)type;
@end
