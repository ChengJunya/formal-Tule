//
//  ContactListViewController.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "ContactListViewController.h"
#import "ContactListViewCell.h"
#import "ContactDetailViewController.h"
#import "ChatViewController.h"
#import "TLHelper.h"
#import "MJNIndexView.h"

extern CGFloat NavAndBarHeight;

@interface ContactListViewController()//<MJNIndexViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
// MJNIndexView
@property (nonatomic, strong) MJNIndexView *indexView;
@end

@implementation ContactListViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"通讯录";
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        self.edgesForExtendedLayout =  UIRectEdgeNone;
//    }

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT,self.view.frame.size.width,self.view.frame.size.height-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT-TABBAR_HEIGHT) style:UITableViewStylePlain];
    //self.tableView.tableFooterView = [[UIView alloc] init];
    //self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    self.searchBtnHidden = NO;
}

-(void)prepareDisplay
{
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //ContactDetailViewController *contactDetail = [[ContactDetailViewController alloc] init];
    [RTLHelper pushViewControllerWithName:@"ContactDetailViewController" block:^(id obj) {
        NSDictionary *contact = [DemoGlobalClass sharedInstance].subAccontsArray[indexPath.row];

        ContactDetailViewController *vc = obj;
        vc.dict = contact;
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [DemoGlobalClass sharedInstance].subAccontsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *contactlistcellid = @"ContactListViewCellidentifier";
    ContactListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contactlistcellid];
    if (cell == nil) {
        cell = [[ContactListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactlistcellid];
    }
    NSDictionary *contact = [DemoGlobalClass sharedInstance].subAccontsArray[indexPath.row];
    [cell.portraitImg sd_setImageWithURL:[NSURL URLWithString:contact[imageKey]] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];//.image = [UIImage imageNamed:contact[imageKey]];
    cell.nameLabel.text = contact[nameKey];
    cell.numberLabel.text = contact[voipKey];
    return cell;
}

//
//#pragma mark MJMIndexForTableView datasource methods
//- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
//{
//    return self.indexArr;
//}
//
//- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.getSelectedItemsAfterPanGestureIsFinished];
//}


@end
