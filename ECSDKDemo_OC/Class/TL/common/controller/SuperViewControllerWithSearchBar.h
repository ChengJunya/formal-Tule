//
//  SuperViewControllerWithSearchBar.h
//  alijk
//
//  Created by easy on 15/1/19.
//  Copyright (c) 2015年 zhongxin. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewControllerWithSearchBar : SuperViewController

@property (nonatomic, assign) BOOL isShowSearchCtrl; // 是否默认显示显示通用searchController
@property (nonatomic, copy) NSString *searchBarPlaceholder;
@property (nonatomic, copy) NSString *searchBarText;
@property (nonatomic, assign) BOOL isShowScanButton;

- (void)showSharedSearchController;
- (void)searchBarBecomeFirstResponder;
- (void)searchBarResignFirstResponder;

@end
