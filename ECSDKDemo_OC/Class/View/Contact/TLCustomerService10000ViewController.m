//
//  TLCustomerService10000ViewController.m
//  TL
//
//  Created by YONGFU on 7/4/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLCustomerService10000ViewController.h"
#import "BoncDataGridDataSource.h"
#import "ZXTextField.h"
#import "ZXColorButton.h"
#import "TLModuleDataHelper.h"
#import "TLCommentRequestDTO.h"
#import "TLCommentListRequestDTO.h"
#import "TLCommentRequestDTO.h"
#import "UserDataHelper.h"
#import "UserInfoDTO.h"
#import "MJRefresh.h"

#define TLCOMMENT_INPUT_HEIGHT 40.f
@interface TLCustomerService10000ViewController (){
    int currentPage;
    int pageCount;
    NSString *travelId;
    NSString *type;
    NSArray *commentList;
    
    
    ZXTextField *commentField;
}
@property (nonatomic,strong) UITableView *commentTableView;
@property (nonatomic,strong) BoncDataGridDataSource *commentTableViewDataSource;
@end

@implementation TLCustomerService10000ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    travelId = [self.itemData valueForKey:@"travelId"];
    type = [self.itemData valueForKey:@"type"];
    currentPage = 1;
    pageCount = TABLE_PAGE_SIZE;
    self.title = @"10000";
    [self addCommentTable];
    [self addCommentIntput];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)addCommentTable{
    
    //    NSArray *dataList = @[@{@"ID":@"C0001",@"COMMENT_CONTEXT":@"文字描述是最真实的",@"COMMENT_TIME":@"2014-05-05",@"USER":@{@"USER_NAME":@"途乐MAN",@"USER_ID":@"20151001",@"USER_ICON":@"http://hiphotos.baidu.com/lvpics/pic/item/30adcbef76094b36c74b294ca0cc7cd98c109db1.jpg"},@"isAction":@"1"},
    //                        @{@"ID":@"C0001",@"COMMENT_CONTEXT":@"文字描述是最真字描述是最真实字描述是最真实字描述是最真实字描述是最真实字描述是最真实字描述是最真实字描述是最真实字描述是最真实字描述是最真实实的",@"COMMENT_TIME":@"2014-05-05",@"USER":@{@"USER_NAME":@"途乐MAN",@"USER_ID":@"20151001",@"USER_ICON":@"http://hiphotos.baidu.com/lvpics/pic/item/30adcbef76094b36c74b294ca0cc7cd98c109db1.jpg"},@"isAction":@"1"},
    //                          @{@"ID":@"C0001",@"COMMENT_CONTEXT":@"文字描述是最真字描述是最真实实的",@"COMMENT_TIME":@"2014-05-05",@"USER":@{@"USER_NAME":@"途乐MAN",@"USER_ID":@"20151001",@"USER_ICON":@"http://hiphotos.baidu.com/lvpics/pic/item/30adcbef76094b36c74b294ca0cc7cd98c109db1.jpg"},@"isAction":@"1"},
    //                          @{@"ID":@"C0001",@"COMMENT_CONTEXT":@"文字描述是字描述是最真实字描述是最真实字描述是最真实最真实的",@"COMMENT_TIME":@"2014-05-05",@"USER":@{@"USER_NAME":@"途乐MAN",@"USER_ID":@"20151001",@"USER_ICON":@"http://hiphotos.baidu.com/lvpics/pic/item/30adcbef76094b36c74b294ca0cc7cd98c109db1.jpg"},@"isAction":@"1"}];
    
    commentList = @[];
    
    
    self.commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), self.view.height-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT-TLCOMMENT_INPUT_HEIGHT)];
    [self.view addSubview:self.commentTableView];
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentTableView.backgroundColor = COLOR_DEF_BG;
    [self.commentTableView addHeaderWithTarget:self action:@selector(initData)];
    [self.commentTableView addFooterWithTarget:self action:@selector(refreshData)];
    NSDictionary *itemData = @{
                               @"type": @"REPORT",
                               @"gridType": COMMENT10000_CELL,
                               @"gridId": COMMENT10000_CELL,
                               @"GRID_DATA": @[commentList],
                               @"SECTION_DATA":@[@{@"SECTION_TYPE":@"1",@"CELL_TYPE": COMMENT10000_CELL}],
                               @"isShowHeader": @"0",
                               @"headerData": @{}
                               };
    self.commentTableViewDataSource = [[BoncDataGridDataSource alloc] initWithTableView:self.commentTableView itemData:itemData];
    WEAK_SELF(self);
    
    self.commentTableViewDataSource.ItemSelectedBlock = ^(id itemData){
        [weakSelf itemSelected:itemData];
    };
    [self initData];
}


-(void)initData{
    currentPage = 1;
    TLCommentListRequestDTO *request = [[TLCommentListRequestDTO alloc] init];
    request.currentPage = [NSString stringWithFormat:@"%d",currentPage];
    request.pageSize = [NSString stringWithFormat:@"%d",pageCount];
    request.objId = travelId;
    request.type = type;
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getCommentList:request requestArr:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        [_commentTableView headerEndRefreshing];
        if (ret) {
            
            commentList = obj;
            [weakSelf frashTableView];
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
        
    }];
}



-(void)refreshData{
    currentPage = currentPage + 1;
    TLCommentListRequestDTO *request = [[TLCommentListRequestDTO alloc] init];
    request.currentPage = [NSString stringWithFormat:@"%d",currentPage];
    request.pageSize = [NSString stringWithFormat:@"%d",pageCount];
    request.objId = travelId;
    request.type = type;
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper getCommentList:request requestArr:self.requestArray block:^(id obj, BOOL ret, int pageNumber) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        [_commentTableView footerEndRefreshing];
        if (ret) {
            commentList = [commentList arrayByAddingObjectsFromArray:obj];
            [weakSelf frashTableView];
        }else{
            
        }
        
    }];
}

-(void)frashTableView{
    if (commentList.count==0) {
        return;
    }
    [self.commentTableViewDataSource setGridData:[NSMutableArray arrayWithArray:@[commentList]]];
}

-(void)addCommentIntput{
    UIView *commentInputView = [[UIView alloc] initWithFrame:CGRectMake(0.f, CGRectGetHeight(self.view.frame)-TLCOMMENT_INPUT_HEIGHT, CGRectGetWidth(self.view.frame), TLCOMMENT_INPUT_HEIGHT)];
    commentInputView.backgroundColor = UIColorFromRGBA(0xCCCCCC, 0.5);
    [self.view addSubview:commentInputView];
    
    CGFloat vGap = 5.f;
    CGFloat hGap = 5.f;
    CGFloat btnWidth = 60.f;
    commentField = [[ZXTextField alloc] initWithFrame:CGRectMake(hGap, vGap, CGRectGetWidth(commentInputView.frame)-hGap*3-btnWidth, CGRectGetHeight(commentInputView.frame)-vGap*2)];
    commentField.placeholder = @"写写你想要说的";
    commentField.font = FONT_16;
    commentField.largeTextLength = 200;
    //commentField.keyboardType = UIKeyboardTypeNumberPad;
    commentField.autoHideKeyboard = YES;
    [commentInputView addSubview:commentField];
    
    UIButton *sendBtn = [ZXColorButton buttonWithType:EZXBT_BOX_GRAY frame:CGRectMake(CGRectGetWidth(commentInputView.frame)-vGap-btnWidth, vGap, btnWidth, CGRectGetHeight(commentField.frame)) title:@"发送" font:FONT_14 block:^{
        
    }];
    [commentInputView addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(sendBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)sendBtnHandler:(UIButton*)btn{
    [self doComment];
}

-(void)itemSelected:(id)itemData{
    
}


-(void)doComment{
    NSString *commentStr = commentField.text;
    if (commentStr.length==0) {
        [GHUDAlertUtils toggleMessage:@"请说点什么吧"];
        return;
    }
    
    
    TLCommentRequestDTO *requestDto = [[TLCommentRequestDTO alloc] init];
    requestDto.comment = commentStr;
    requestDto.loginId = GUserDataHelper.tlUserInfo.loginId;
    requestDto.objId = travelId;
    requestDto.type = type;
    WEAK_SELF(self);
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper addComment:requestDto requestArr:self.requestArray block:^(id obj, BOOL ret) {
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            [GHUDAlertUtils toggleMessage:@"发布成功！"];
            [weakSelf initData];
            commentField.text = @"";
        }else{
            
        }
        
    }];
    
}



@end
