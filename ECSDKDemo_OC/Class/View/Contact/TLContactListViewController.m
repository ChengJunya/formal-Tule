//
//  TLContactListViewController.m
//  TL
//
//  Created by Rainbow on 3/1/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLContactListViewController.h"
#import "BoncDataGridDataSource.h"
#import "DemoGlobalClass.h"
#import "TLMineListItem.h"
#import "TLHelper.h"
#import "ContactDetailViewController.h"
#import "MJNIndexView.h"
#import "TLMyFriendListRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "TLSimpleUserDTO.h"
#import <AddressBook/AddressBook.h>
#import "CMenuView.h"
#import "ZXColorButton.h"
#import "ZXTextField.h"
#import "CTabMenu.h"
#import "TLOrgDataDTO.h"
#import "TLGroupDataDTO.h"
#import "ECDevice.h"
#import "TLGroupDataDTO.h"
#import "TLCommentViewController.h"

#define GROUP_MENU_HEIGHT 60.f
#define SEARCH_VIEW_HEIGHT 40.f
#define CTABEMENU_HEIGHT 40.f

@interface TLContactListViewController ()<MJNIndexViewDataSource,CMenuViewDelegate>{
    CGFloat yOffSet;
    CGFloat tableViewHeight;
    UIView *searchView;
    ZXTextField *titleField;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) BoncDataGridDataSource *tableViewDataSource;
@property (nonatomic,strong) NSMutableArray *sectionDataArray;
@property (nonatomic,strong) NSMutableArray *indexViewArray;
@property (nonatomic,strong) NSMutableArray *gridDataArray;
@property (nonatomic,strong) NSMutableArray *tableDataArray;
@property (nonatomic,strong) NSString *phoneStr;
@property (nonatomic,strong) NSString *searchText;
@property (nonatomic,strong) NSString *searchType;//



@property (nonatomic, assign) BOOL getSelectedItemsAfterPanGestureIsFinished;
// MJNIndexView
@property (nonatomic, strong) MJNIndexView *indexView;

@property (nonatomic,strong) CTabMenu *tabMenu;

@end

@implementation TLContactListViewController




- (void)viewDidLoad {
    
    [super viewDidLoad];
    yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    self.tableDataArray = [NSMutableArray array];
    self.type = [self.itemData valueForKey:@"TYPE"];
    self.searchType = @"1";
    if (self.type==nil||self.type.integerValue==1) {
        self.type = @"1";//默认好友
        self.title = @"通讯录";
    }else if (self.type.integerValue==2){
        self.title = @"推荐";
    }else if (self.type.integerValue==3){
        self.title = @"添加";
    }else if (self.type.integerValue==4){
        self.title = @"附近";
    }
    
    self.phoneStr = @"";
    if (self.type.integerValue == 2) {
        [self getLocalContact];
    }
    
    if (self.type.integerValue==3){
        //添加选择 用户 组织 群组 的选择框
        [self addSelectView];
        //添加搜索
        [self addSearchInputView];
        
    }
    
    
    if (self.type.integerValue==4) {
        //添加选择 用户 组织 群组 的选择框
        [self addSelectView];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    
    
    
    if (self.type==nil||self.type.integerValue==1) {
        self.navBackItemHidden = YES;
        self.searchBtnHidden = NO;
        self.listBtnHidden = NO;
        self.navView.actionBtns = @[[self addPublishActionBtn]];
    }else {
        self.navBackItemHidden = NO;
    }
    
    
    [self.tableView reloadData];
    [self getUIData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getUIData{
    
    
    if (self.type.integerValue==3) {
        if (self.searchText.length==0) {
            return;
        }
    }
    
    self.tableDataArray = [NSMutableArray array];
    WEAK_SELF(self);
    
    switch (self.searchType.integerValue) {
        case 1:
        {
            TLMyFriendListRequestDTO *request = [[TLMyFriendListRequestDTO alloc] init];
            request.type = self.type;
            request.phoneArray = self.phoneStr.length==0?@"":self.phoneStr;
            request.searchText = self.searchText;
            
            [GHUDAlertUtils toggleLoadingInView:self.view];
            [GTLModuleDataHelper myFriendList:request requestArr:[NSMutableArray array] block:^(id obj, BOOL ret) {
                [GHUDAlertUtils hideLoadingInView:self.view];
                if (ret) {
                    
                    
                    //保存子账号信息
                    NSMutableArray* subAccountArray = [DemoGlobalClass sharedInstance].subAccontsArray;
                    NSArray *friends = obj;
                    [friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        TLSimpleUserDTO *dto = obj;
                        NSDictionary *friend = [dto toDictionary];
                        if (self.type.integerValue==1) {
                            [subAccountArray addObject:friend];
                        }
                        
                        NSString *distance  =  @"";
                        if (self.type.integerValue==3) {
                            if (dto.join.integerValue==1) {
                                distance = @"已加入";
                            }else{
                                distance = @"添加";
                            }
                            
                        }else{
                            distance = dto.distance;
                        }
                        
                        NSDictionary *orgDic = @{@"itemId":dto.loginId,@"userIcon":dto.userIcon,@"userName":dto.userName,@"distance":distance,@"shortIndex":dto.shortIndex,@"data":[dto toDictionary]};
                        [self.tableDataArray addObject:orgDic];
                        
                    }];
                    
                    if (self.type.integerValue==1) {
                        //添加10000客服
                        NSDictionary *orgDic = @{@"itemId":@"10000",@"tl10000Sign":@"人在旅途，乐在其中！",@"tl10000Name":@"途乐",@"userIcon":@"logo.jpg",@"userName":@"10000",@"distance":@"",@"shortIndex":@"10000"};
                        [self.tableDataArray addObject:orgDic];
                    }
                    
                    [weakSelf setupViews];
                }else{
                    ResponseDTO *response = obj;
                    [GHUDAlertUtils toggleMessage:response.resultDesc];
                }
            }];
            break;
        }
        case 2:
        {
            TLListGroupRequestDTO *request = [[TLListGroupRequestDTO alloc] init];
            if (self.type.integerValue==4) {
                request.type = @"4";//附近组织
            }else{
                request.type = @"3";
            }
            request.pageSize = @"500";
            request.searchText = self.searchText;
            request.currentPage = @"1";
            
            [GHUDAlertUtils toggleLoadingInView:self.view];
            [GTLModuleDataHelper listGroup:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
                
                [GHUDAlertUtils hideLoadingInView:self.view];
                if (ret) {
                    
                    
                    NSArray *groups = obj;
                    [groups enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        TLGroupDataDTO *dto = obj;
                        
                        NSString *distance  =  @"";
                        if (self.type.integerValue==4) {
                             distance = dto.distance;
                           
                        }else{
                            if (dto.join.integerValue==1) {
                                distance = @"申请加入";
                            }else{
                                distance = @"添加";
                            }
                            
                        }
                       

                        
                        NSDictionary *groupDic = @{@"itemId":dto.groupId,@"userIcon":dto.groupIcon,@"userName":dto.groupName,@"distance":distance,@"shortIndex":dto.shortIndex,@"data":[dto toDictionary]};
                        
                        
                        [self.tableDataArray addObject:groupDic];
                        
                    }];
                    
                    [weakSelf setupViews];
                }else{
                    ResponseDTO *response = obj;
                    [GHUDAlertUtils toggleMessage:response.resultDesc];
                }
            }];
            break;
        }
        case 3:
        {
            TLListOrgRequestDTO *request = [[TLListOrgRequestDTO alloc] init];
            if (self.type.integerValue==4) {
                request.type = @"3";//附近组织
            }else{
                request.type = @"2";
            }
            
            request.pageSize = @"500";
            request.searchText = self.searchText;
            request.currentPage = @"1";
            
            
            [GTLModuleDataHelper listOrganization:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
                if (ret) {
                    NSArray *orgs = obj;
                    [orgs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        TLOrgDataDTO *dto = obj;
                        NSString *distance  =  @"";
                        if (self.type.integerValue==4) {
                            distance = dto.distance;
                            
                        }else{
                            if (dto.join.integerValue==1) {
                                distance = @"已加入";
                            }else{
                                distance = @"加入组织";
                            }
                            
                        }
                       
                        
                        NSDictionary *orgDic = @{@"itemId":dto.organizationId,@"userIcon":@"",@"userName":dto.organizationName,@"distance":distance,@"shortIndex":dto.shortIndex,@"data":[dto toDictionary]};
                        [self.tableDataArray addObject:orgDic];
                        
                    }];
                    [weakSelf setupViews];
                }else{
                    ResponseDTO *response = obj;
                    [GHUDAlertUtils toggleMessage:response.resultDesc];
                }
            }];
            break;
        }
        default:
            break;
    }
    
    

    

}



-(void)getLocalContact{
    CFErrorRef *error = nil;
    
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    if (accessGranted) {
        
        
        
        NSMutableArray *addressBookTemp = [NSMutableArray array];
        
        //ABAddressBookRef addressBooks = ABAddressBookCreate();
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        
        
        
        
        
        for (NSInteger i = 0; i < nPeople; i++)
            
        {
            
            
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
//            CFStringRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
//            
//            CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
//            
//            CFStringRef abFullName = ABRecordCopyCompositeName(person);
//            NSString * fullName = (__bridge NSString*)abFullName;
//            NSLog(@"Name:%@",fullName);
            //获取URL多值
            ABMultiValueRef phoneRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
           
            
            for (int m = 0; m < ABMultiValueGetCount(phoneRef); m++)
            {
                //获取电话Label
                //NSString * urlLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phoneRef, m));
                //获取該Label下的电话值
                NSString * phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneRef,m);
                //NSLog(@"Name:%@ %@",urlLabel , urlContent);
                phone =  [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"- "];//@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
                phone = [[phone componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
                
                
                self.phoneStr = [NSString stringWithFormat:@"%@;%@",self.phoneStr,phone];
            }
            
        } 
        
        
        
    }
    
    NSLog(@"电话本：%@",self.phoneStr);
}

-(void)setupViews{
    yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    
    
    if (self.type.integerValue==3){
       
       
        yOffSet = yOffSet + SEARCH_VIEW_HEIGHT + CTABEMENU_HEIGHT;
        
    }
    
    if (self.type.integerValue==4) {
        yOffSet = yOffSet + CTABEMENU_HEIGHT;
        
    }
    tableViewHeight = self.view.height - yOffSet;
    if (self.type.integerValue==1) {
       
        [self addMenuButtons];
         tableViewHeight = self.view.height - yOffSet-TABBAR_HEIGHT;
    }
    //[self addDownloadCollections];
    [self setupTableView];
    if (self.type.integerValue!=4) {
        [self setupIndexView];
    }
    
    
    [self.tableView reloadData];
    
}

#pragma mark-
#pragma mark-添加视图

-(void)addSelectView{
    
    
    
    NSArray * selectArray;
    if (self.type.integerValue==4) {
        selectArray= @[
                       @{@"ID":@"1",@"NAME":@"个人",@"TYPE":@"1"},
                       @{@"ID":@"2",@"NAME":@"群组",@"TYPE":@"2"}
                       ];
    }else{
        selectArray= @[
                       @{@"ID":@"1",@"NAME":@"个人",@"TYPE":@"1"},
                       @{@"ID":@"2",@"NAME":@"群组",@"TYPE":@"2"},
                       @{@"ID":@"3",@"NAME":@"组织",@"TYPE":@"3"}
                       ];
    }
    
    
    self.tabMenu = [[CTabMenu alloc] initWithFrame:CGRectMake(0.0f, yOffSet, CGRectGetWidth(self.view.frame), CTABEMENU_HEIGHT)];
    
    WEAK_SELF(self);
    self.tabMenu.MenuItemSelectedBlock = ^(id itemData){
        [weakSelf changeSelectType:itemData];
    };
    [self.view addSubview:self.tabMenu];
    [self.tabMenu setMenuData:selectArray];
    [self.tabMenu createMenu];
    [self.view addSubview:self.tabMenu];
    

    yOffSet = yOffSet + CTABEMENU_HEIGHT;
}
-(void)changeSelectType:(id)itemData{
    
    if (self.type.integerValue==3) {
        self.searchType = [itemData valueForKey:@"TYPE"];
        if (self.searchType.integerValue==1) {
            titleField.placeholder = @"请输入途乐号或手机号码";
        }else if (self.searchType.integerValue==2) {
            titleField.placeholder = @"请输入群号";
        }else if (self.searchType.integerValue==3) {
            titleField.placeholder = @"请输入组织名称";
        }
    }
    
    if (self.type.integerValue==4) {
        self.searchType = [itemData valueForKey:@"TYPE"];
    }
    
    
    [self getUIData];
}
-(void)addSearchInputView{
    if (searchView!=nil) {
        [searchView removeFromSuperview];
    }
    searchView = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, self.view.width, SEARCH_VIEW_HEIGHT)];
    searchView.backgroundColor = COLOR_DEF_BG;
    searchView.layer.borderColor = [UIColorFromRGB(0xEEEEEE) CGColor];
    searchView.layer.borderWidth = 0.5f;
    [self.view addSubview:searchView];
    CGFloat hGap = 10.f;
    CGFloat searchBtnWidth = 60.f;
    CGFloat searchBtnHeight = 30.f;
    
    titleField = [[ZXTextField alloc] initWithFrame:CGRectMake(hGap, (SEARCH_VIEW_HEIGHT-30.f)/2, CGRectGetWidth(searchView.frame)-hGap*3-searchBtnWidth, 30.f)];
    titleField.placeholder = @"请输入途乐号或手机号码";
    titleField.font = FONT_16;
    titleField.largeTextLength = 20;
    titleField.autoHideKeyboard = YES;
    
    
//    titleField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(searchView.frame)-hGap*3-searchBtnWidth, CGRectHeight(searchView.frame))];
    [searchView addSubview:titleField];
    //titleField.placeholder = @"请输入群组或用户名称";
    WEAK_SELF(self);
    UIButton *searchBtn = [ZXColorButton buttonWithType:EZXBT_BOX_GREEN frame:CGRectMake(searchView.width-hGap-searchBtnWidth, (searchView.height-searchBtnHeight)/2, searchBtnWidth, searchBtnHeight) title:@"搜索" font:FONT_14 block:^{
        [weakSelf searchBtnHandler];
        [self.view endEditing:YES];
    }];
    [searchView addSubview:searchBtn];
    
    
    yOffSet = yOffSet + 40.f;
}
-(void)searchBtnHandler{
    self.searchText =  titleField.text;
    if (self.searchText.length==0) {
        [GHUDAlertUtils toggleMessage:@"请输入搜索关键字"];
        return;
    }
    [self getUIData];
}
-(void)setupIndexView{
    // initialise MJNIndexView
    if (self.indexView!=nil) {
        [self.indexView removeFromSuperview];
    }
    self.indexView = [[MJNIndexView alloc]initWithFrame:self.tableView.frame];
    self.indexView.dataSource = self;
    self.indexView.selectedItemFontColor = COLOR_MAIN_TEXT;
    self.indexView.fontColor = COLOR_ASSI_TEXT;
    [self firstAttributesForMJNIndexView];
    
    [self.view addSubview:self.indexView];
}

-(void)setupTableView{
    
    
    
    if (self.tableView!=nil) {
        [self.tableView removeFromSuperview];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, yOffSet, CGRectGetWidth(self.view.frame), tableViewHeight)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
    
    
    
    
    self.sectionDataArray = [[NSMutableArray alloc] init];
    self.gridDataArray = [[NSMutableArray alloc] init];
    self.indexViewArray = [[NSMutableArray alloc] init];
    
    
    if (self.type.integerValue==4) {
        [self.gridDataArray addObject:self.tableDataArray];
         NSDictionary *section = @{@"SECTION_TYPE":@"1",@"CELL_TYPE": TL_CONTACT_CELL,@"TITLE":@""};
        [self.sectionDataArray addObject:section];
    }else{
        NSArray *azSectionArray = @[@"10000",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
        
        [azSectionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *section;
            if ([obj isEqualToString:@"10000"]) {
                section = @{@"SECTION_TYPE":@"1",@"CELL_TYPE": TL_CONTACT_CELL,@"TITLE":@" "};
            }else{
                section = @{@"SECTION_TYPE":@"1",@"CELL_TYPE": TL_CONTACT_CELL,@"TITLE":obj};
            }
            
            NSMutableArray *gridArray = [[NSMutableArray alloc] init];
            for (int i=0; i<self.tableDataArray.count; i++) {
                id user = self.tableDataArray[i];
                NSString *shortIndex = [user valueForKey:@"shortIndex"];
                if ([obj isEqualToString:shortIndex]) {
                    [gridArray addObject:user];
                }
            }
            if (gridArray.count>0) {
                [self.gridDataArray addObject:gridArray];
                [self.sectionDataArray addObject:section];
                if ([obj isEqualToString:@"10000"]) {
                    [self.indexViewArray addObject:@" "];
                }else{
                    [self.indexViewArray addObject:obj];
                }
            }
            
            
            
            
        }];
    
    }
    
    
    
    
    //NSDictionary *section = @{@"SECTION_TYPE":@"1",@"CELL_TYPE": gridType,@"TITLE":title};
    
    NSDictionary *itemData = @{
                               @"type": @"REPORT",
                               @"gridType": @"TL_CONTACT_CELL",
                               @"gridId": @"TL_CONTACT_CELL",
                               @"GRID_DATA": self.gridDataArray,
                               @"SECTION_DATA":self.sectionDataArray,
                               @"isShowHeader": @"0",
                               @"headerData": @{}
                               };
    self.tableViewDataSource = [[BoncDataGridDataSource alloc] initWithTableView:self.tableView itemData:itemData];
    
    __weak TLContactListViewController *weakController = self;
    self.tableViewDataSource.ItemSelectedBlock = ^(id itemData){
        [weakController itemSelected:itemData];
    };
    
}

-(void)itemSelected:(id)itemData{
    
    if ([[itemData valueForKey:@"itemId"] isEqualToString:@"10000"]) {
        
        NSDictionary *itemData = @{@"travelId":GUserDataHelper.tlUserInfo.loginId,@"type":@"20"};
        
//        [self pushViewControllerWithName:@"TLCommentViewController" itemData:itemData block:^(TLCommentViewController *obj) {
//            obj.title = @"投诉";
//        }];
        
        [RTLHelper pushViewControllerWithName:@"TLCustomerService10000ViewController" itemData:itemData block:^(id obj) {
            
        }];
        return;
    }
    
    
    NSDictionary *data = [itemData valueForKey:@"data"];
    NSString *join = [data valueForKey:@"join"];
    if (self.type.integerValue==3) {
        switch (self.searchType.integerValue) {
            case 1:
            {
                [RTLHelper pushViewControllerWithName:@"TLContactDetailViewController" itemData:data block:^(id obj) {
                    
                }];
//                if (join.integerValue==1) {
//                    [RTLHelper pushViewControllerWithName:@"TLContactDetailViewController" itemData:data block:^(id obj) {
//                        
//                    }];
//                }else{
//                    [self addFriendButtonHandler:[data valueForKey:@"loginId"]];
//                }
                break;
            }
            case 2:
            {
                if (join.integerValue==1) {
                    NSError *error = [[NSError alloc] init];
                    TLGroupDataDTO *dto = [[TLGroupDataDTO alloc] initWithDictionary:data error:&error];
                    [RTLHelper pushViewControllerWithName:@"TLGroupDetailViewController" itemData:dto block:^(id obj) {
                        
                    }];
                }else{
                    [self addGroupButtonHandler:[data valueForKey:@"rlGroupId"]];
                }
                break;
            }
            case 3:
            {
                
                if (join.integerValue==1) {
                    
                }else{
                    [self addOrgButtonHandler:[data valueForKey:@"organizationId"]];
                }
                
                break;
            }
            
            default:
                break;
        }
    }else if (self.type.integerValue==4){
        if (self.tabMenu.selectedIndex==0) {
            [RTLHelper pushViewControllerWithName:@"TLContactDetailViewController" itemData:data block:^(id obj) {
                
            }];
        }else{
            NSError *error = [[NSError alloc] init];
            TLGroupDataDTO *dto = [[TLGroupDataDTO alloc] initWithDictionary:data error:&error];
            [RTLHelper pushViewControllerWithName:@"TLGroupDetailViewController" itemData:dto block:^(id obj) {
                
            }];
        }
    
    }  else{
        [RTLHelper pushViewControllerWithName:@"TLContactDetailViewController" itemData:data block:^(id obj) {
            
        }];
    }
    
    
    
}

-(void)addFriendButtonHandler:(NSString*)loginId{
    TLAddFriendApplyRequestDTO *request = [[TLAddFriendApplyRequestDTO alloc] init];
    request.loginId = loginId;
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addFriendApply:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"发送成功"];
        }else{
            ResponseDTO *resDTO = obj;
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }
    }];
}

-(void)addOrgButtonHandler:(NSString*)orgId{
    WEAK_SELF(self);
    
    [GHUDAlertUtils showZXColorAlert:@"您是否确认加入该组织" subTitle:@"" cancleButton:MultiLanguage(comCancel) sureButtonTitle:MultiLanguage(comSure)  COLORButtonType:(RED_BUTTON_TYPE) buttonHeight:35 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
        if (index == 1) {
            TLOperOrgRequestDTO *request = [[TLOperOrgRequestDTO alloc] init];
            request.organizationId = orgId;
            request.type = @"1";
            [GHUDAlertUtils toggleLoadingInView:self.view];
            [GTLModuleDataHelper operateOrganization:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
                
                [GHUDAlertUtils hideLoadingInView:self.view];
                if (ret) {
                    [GHUDAlertUtils toggleMessage:@"加入成功"];

                    [weakSelf getUIData];
                }else{
                    ResponseDTO *resDTO = obj;
                    [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
                }
            }];
        }
    }];

    
    
    
}

-(void)addGroupButtonHandler:(NSString*)groupId{
    
    

    
//    [[ECDevice sharedInstance].messageManager queryGroupMembers:groupId completion:^(ECError *error, NSArray *members) {
//        [members enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            NSLog(@"%@",obj);
//        }];
//    }];
//
//    
//    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"正在申请加入";
//    hud.removeFromSuperViewOnHide = YES;
//    
//    [[ECDevice sharedInstance].messageManager joinGroup:groupId reason:@"我想加入" completion:^(ECError *error, NSString *groupId) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (error.errorCode == ECErrorType_NoError) {
//            
//            
//        }
//        else
//        {
//            
//        }
//        
//    }];

    
    
    TLGroupJoinApplyRequestDTO *request = [[TLGroupJoinApplyRequestDTO alloc] init];
    request.rlGroupId = groupId;
    request.type = @"0";
    request.voipAccount = GUserDataHelper.tlUserInfo.voipAccount;
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper operateGroup:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"发送成功"];
        }else{
            ResponseDTO *resDTO = obj;
            [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
        }
    }];
}

- (UIButton*)addPublishActionBtn
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setTitleColor:COLOR_NAV_TEXT forState:UIControlStateNormal];
    [actionBtn setTitleColor:COLOR_BTN_BOX_GRAY_TEXT forState:UIControlStateHighlighted];
    [actionBtn setTitle:@"+添加" forState:UIControlStateNormal];
    actionBtn.titleLabel.font = FONT_14B;
    //[actionBtn setImage:[UIImage imageNamed:@"more_xiaoxi"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(addBtnHandler) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

-(void)addBtnHandler{
    
    NSDictionary *itemData = @{@"ID":@"3",@"NAME":@"添加",@"IMG":@"tl_tuijian",@"VCNAME":@"TLContactListViewController",@"TYPE":@"3",@"DATATYPE":@"1",@"LOGINID":@""};
    [RTLHelper pushViewControllerWithName:@"TLContactListViewController" itemData:itemData block:^(id obj) {
        
    }];
}

-(void)addMenuButtons{
    if ([self.view viewWithTag:1505011506]!=nil) {
        [[self.view viewWithTag:1505011506] removeFromSuperview];
    }
    CMenuView *menuView = [[CMenuView alloc] initWithFrame:CGRectMake(0.0,yOffSet, CGRectGetWidth(self.view.frame),GROUP_MENU_HEIGHT)];
    menuView.delegate = self;
    menuView.columnCount = 4;
    menuView.rowCount = 1;
    menuView.alpha = 1;
    menuView.tag = 1505011506;
    [self.view addSubview:menuView];
    
    NSString *loginId = @"";//GUserDataHelper.loginInfo.loginId;
    
    [menuView randerViewWithData:@[
  @{@"ID":@"1",@"NAME":@"群组",@"IMG":@"tl_group",@"VCNAME":@"TLOrgListViewController",@"TYPE":@"2",@"IS_SHOW_ADD":@"0",@"DATATYPE":@"1",@"LOGINID":loginId},
@{@"ID":@"2",@"NAME":@"组织",@"IMG":@"tl_org",@"VCNAME":@"TLOrgListViewController",@"TYPE":@"1",@"IS_SHOW_ADD":@"0",@"DATATYPE":@"1",@"LOGINID":loginId},
@{@"ID":@"3",@"NAME":@"推荐",@"IMG":@"tl_tuijian",@"VCNAME":@"TLContactListViewController",@"TYPE":@"2",@"IS_SHOW_ADD":@"0",@"DATATYPE":@"1",@"LOGINID":loginId},
@{@"ID":@"4",@"NAME":@"附近的",@"IMG":@"tl_near",@"VCNAME":@"TLContactListViewController",@"TYPE":@"4",@"IS_SHOW_ADD":@"0",@"DATATYPE":@"1",@"LOGINID":loginId}]];
    
    yOffSet = yOffSet + GROUP_MENU_HEIGHT;
}

-(void)itemClick:(NSDictionary *)itemData{
    NSLog(@"%@",[itemData valueForKey:@"VCNAME"]);
    //NSString *menuId = [itemData valueForKey:@"menuId"];
    [RTLHelper pushViewControllerWithName:[itemData valueForKey:@"VCNAME"] itemData:itemData block:^(id obj) {
        
    }];
    
    
    
    
    
    
}




-(void)addDownloadCollections{
    NSDictionary *itemData1 = @{@"NAME":@"社区",@"IMAGE":@"tl_linkman_district"};
    TLMineListItem *storeItem1 = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame)/2, 40.f) itemData:itemData1 isShowAction:YES];
    storeItem1.layer.borderColor = UIColorFromRGBA(0xcccccc, 0.5).CGColor;
    storeItem1.layer.borderWidth = 0.5f;
    [self.view addSubview:storeItem1];
    
    NSDictionary *itemData2 = @{@"NAME":@"群",@"IMAGE":@"tl_linkman_group"};
    TLMineListItem *storeItem2 = [[TLMineListItem alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2, yOffSet, CGRectGetWidth(self.view.frame)/2, 40.f) itemData:itemData2 isShowAction:YES];
    storeItem2.layer.borderColor = UIColorFromRGBA(0xcccccc, 0.5).CGColor;
    
    storeItem2.layer.borderWidth = 0.5f;
    [storeItem2 addTarget:self action:@selector(groupBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:storeItem2];
    
    
    
    yOffSet = yOffSet + CGRectGetHeight(storeItem1.frame);
}


-(void)groupBtnHandler:(TLMineListItem*)btn{
    [RTLHelper pushViewControllerWithName:@"GroupListViewController" itemData:self.itemData block:^(id obj) {
        
    }];

}



- (void)firstAttributesForMJNIndexView
{
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = YES;
    self.indexView.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = nil;
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = NO;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 22.0;
    self.indexView.lowerMargin = 22.0;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentCenter;
    self.indexView.maxItemDeflection = 100.0;
    self.indexView.rangeOfDeflection = 5;
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
}


#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return self.indexViewArray;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.getSelectedItemsAfterPanGestureIsFinished];
}
@end
