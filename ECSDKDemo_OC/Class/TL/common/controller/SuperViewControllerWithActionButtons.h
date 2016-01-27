//
//  SuperViewControllerWithActionButtons.h
//  TL
//
//  Created by Rainbow on 2/10/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewControllerWithActionButtons : SuperViewController
@property (nonatomic,strong) NSString *dataType;

- (void)shareAction;
- (void)collectAction;
- (void)downloadAction;
- (void)communicateAction;

@end
