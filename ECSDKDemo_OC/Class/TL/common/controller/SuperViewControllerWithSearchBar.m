//
//  SuperViewControllerWithSearchBar.m
//  alijk
//
//  Created by easy on 15/1/19.
//  Copyright (c) 2015年 zhongxin. All rights reserved.
//

#import "SuperViewControllerWithSearchBar.h"

#import "ZXUIHelper.h"


@interface SuperViewControllerWithSearchBar () <UISearchBarDelegate> {
    BOOL _viewWillDisappear;
}

@property (nonatomic, strong) UISearchBar *navSearchBar;

@end

@implementation SuperViewControllerWithSearchBar

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _viewWillDisappear = NO;
    _isShowScanButton = YES;
    self.navSearchBar.text = self.searchBarText;
    self.navSearchBar.placeholder = self.searchBarPlaceholder;
    
    if (self.isShowSearchCtrl) {
        [self showSharedSearchController];
    }
    [self updateScanButtonState];
    [self addNavSearchBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _viewWillDisappear = YES;
    self.navSearchBar.text = @"";
}

- (void)addNavSearchBar {
    CGRect searchRect = CGRectMake(44.f, STATUSBAR_HEIGHT, DEVICE_WIDTH - UI_Comm_Margin - 88.f, NAVIGATIONBAR_HEIGHT);
    UISearchBar *searchBar = [ZXUIHelper commSearchBarWithFrame:searchRect bookmarkIcon:[UIImage imageNamed:@"ico_saoyisao"]];
    searchBar.delegate = self;
    [self.navView addSubview:searchBar];
    self.navSearchBar = searchBar;
}

- (void)updateScanButtonState {
    self.navSearchBar.showsBookmarkButton = (_isShowScanButton && [self.navSearchBar.text isEqualToString:@""]);
}

- (void)setIsShowScanButton:(BOOL)isShowScanButton {
    _isShowScanButton = isShowScanButton;
    [self updateScanButtonState];
}

#pragma mark -
#pragma mark - action

- (void)clickScanButton {
    [self pushViewControllerWithName:@"BarCodeReaderViewController" block:nil];
}

- (void)zxScanButtonClicked {
    [self clickScanButton];
}

#pragma mark -
#pragma mark - searchBar

- (void)setSearchBarPlaceholder:(NSString *)searchBarPlaceholder {
    _searchBarPlaceholder = searchBarPlaceholder;
    self.navSearchBar.placeholder = searchBarPlaceholder;
}

- (void)setSearchBarText:(NSString *)searchBarText {
    _searchBarText = searchBarText;
    self.navSearchBar.text = searchBarText;
    [self updateScanButtonState];
}

- (void)searchBarBecomeFirstResponder {
    [self.navSearchBar becomeFirstResponder];
}

- (void)searchBarResignFirstResponder {
    [self.navSearchBar resignFirstResponder];
}

- (void)showSharedSearchController {
//    ZXSearchController *searchController = [ZXSearchController sharedSearchController];
//    [searchController showSharedSearchController:self];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (!_viewWillDisappear) {
        [self.navSearchBar resignFirstResponder];
        [self showSharedSearchController];
        
        return YES;
    }
    return NO;
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    [self clickScanButton];
}

@end
