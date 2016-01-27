//
//  TLOrgInfoViewController.m
//  TL
//
//  Created by Rainbow on 5/5/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLOrgInfoViewController.h"
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
#import "TLOrgDataDTO.h"
#import "RUILabel.h"
#import "RUtiles.h"
#import "TLSendOrgMessageResponseDTO.h"
#import "KxMenu.h"

#define TLCOMMENT_INPUT_HEIGHT 40.f
#define TL_ORGINFO_TOPVIEW_HEIGHT 40.f
@interface TLOrgInfoViewController (){
    int currentPage;
    int pageCount;
    NSString *travelId;
    NSString *type;
    NSArray *commentList;
    
    
    ZXTextField *commentField;
}
@property (nonatomic,strong) UITableView *commentTableView;
@property (nonatomic,strong) BoncDataGridDataSource *commentTableViewDataSource;
@property (nonatomic,strong) TLOrgDataDTO *orgDto;

@property (nonatomic,strong) NSString *refrashTime;
@end

@implementation TLOrgInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orgDto = self.itemData;
    
    currentPage = 1;
    pageCount = TABLE_PAGE_SIZE;
    self.title = self.orgDto.organizationName;
    //[self addTopInfoView];
    [self addCommentTable];
    [self addCommentIntput];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    [self createActionButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark-
#pragma mark-添加右侧菜单

- (void)createActionButtons{

    NSArray *actionButtons = @[[self createMenuButton]];
    self.navView.actionBtns = actionButtons;
    
    
}

- (UIButton*)createMenuButton
{
    
    //    UIImage *backImage = [UIImage imageNamed:@"ico_backon"];
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    [actionBtn setImage:[UIImage imageNamed:@"tl_right_more"] forState:UIControlStateNormal];
    //    [actionBtn setImage:[UIImage imageNamed:@"ico_backon" ] forState:UIControlStateHighlighted];
    [actionBtn addTarget:self action:@selector(showExpandMenu:) forControlEvents:UIControlEventTouchUpInside];
    return actionBtn;
}

-(void)navMessageAction:(id)sender
{
    [self showExpandMenu:sender];
}

- (void)showExpandMenu:(UIButton*)sender
{
    
    
    
    NSArray *menuItems;
    KxMenuItem *item1 = [KxMenuItem menuItem:@"退出组织"
                                       image:nil
                                      extNum:0
                                      target:self
                                      action:@selector(deleteAction)];
    item1.foreColor = COLOR_MAIN_TEXT;
   
    
    
    menuItems = @[item1];
    
    KxMenuItem *first = menuItems[0];
    first.alignment = NSTextAlignmentLeft;
    
    CGRect rect = sender.frame;
    rect.size = CGSizeMake(40.f, 40.f);
    [KxMenu setTintColor:[UIColor whiteColor]];
    
    [KxMenu showMenuInView:self.view
                  fromRect:rect
                 menuItems:menuItems];
    
}

#pragma mark-
#pragma mark-操作事件
-(void)deleteAction{
    WEAK_SELF(self);
    [GHUDAlertUtils showZXColorAlert:@"您是否确认退出该组织" subTitle:@"" cancleButton:MultiLanguage(comCancel) sureButtonTitle:MultiLanguage(comSure)  COLORButtonType:(RED_BUTTON_TYPE) buttonHeight:35 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
        if (index == 1) {
            TLOperOrgRequestDTO *request = [[TLOperOrgRequestDTO alloc] init];
            request.organizationId = self.orgDto.organizationId;
            request.type = @"2";
            [GHUDAlertUtils toggleLoadingInView:self.view];
            [GTLModuleDataHelper operateOrganization:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
                
                [GHUDAlertUtils hideLoadingInView:self.view];
                if (ret) {
                    [GHUDAlertUtils toggleMessage:@"退出成功"];
                    
                    [weakSelf gobackAction];
                }else{
                    ResponseDTO *resDTO = obj;
                    [GHUDAlertUtils toggleMessage:resDTO.resultDesc];
                }
            }];
        }
    }];
}

-(void)gobackAction{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 
#pragma mark - 添加视图
-(void)addTopInfoView{
    //tupin 文字
    UIView *topInfoView = [[UIView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, self.view.width, TLCOMMENT_INPUT_HEIGHT)];
    topInfoView.backgroundColor = COLOR_WHITE_BG;
    [self.view addSubview:topInfoView];
    
    UIImageView *speakerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 5.f, 30.f,30.f)];
    speakerIcon.image = [UIImage imageNamed:@"tl_trumpet_bar"];
    [topInfoView addSubview:speakerIcon];
    
    RUILabel *topInfoLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:@"" font:FONT_16 color:COLOR_MAIN_TEXT];
    topInfoLabel.frame = CGRectMake(50.f, (topInfoView.height-topInfoLabel.height)/2, topInfoView.width-60.f, topInfoLabel.height);
    [topInfoView addSubview:topInfoLabel];
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
                               @"gridType": TL_ORG_MSSAGE_CELL,
                               @"gridId": TL_ORG_MSSAGE_CELL,
                               @"GRID_DATA": @[commentList],
                               @"SECTION_DATA":@[@{@"SECTION_TYPE":@"1",@"CELL_TYPE": TL_ORG_MSSAGE_CELL}],
                               @"isShowHeader": @"0",
                               @"headerData": @{}
                               };
    self.commentTableViewDataSource = [[BoncDataGridDataSource alloc] initWithTableView:self.commentTableView itemData:itemData];
    __weak TLOrgInfoViewController *weakController = self;
    
    self.commentTableViewDataSource.ItemSelectedBlock = ^(id itemData){
        [weakController itemSelected:itemData];
    };
    [self initData];
}


-(void)initData{
    self.refrashTime = [RUtiles stringFromDateWithFormat:[NSDate new] format:@"yyyyMMddHHmmss"];
    currentPage = 1;
    TLListOrgMesssageRequestDTO *request = [[TLListOrgMesssageRequestDTO alloc] init];
    request.currentPage = [NSString stringWithFormat:@"%d",currentPage];
    request.pageSize = [NSString stringWithFormat:@"%d",pageCount];
    request.currentTime = self.refrashTime ;
    request.organizationId = self.orgDto.organizationId;
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper listOrgMessage:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
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
    TLListOrgMesssageRequestDTO *request = [[TLListOrgMesssageRequestDTO alloc] init];
    request.currentPage = [NSString stringWithFormat:@"%d",currentPage];
    request.pageSize = [NSString stringWithFormat:@"%d",pageCount];
    request.currentTime = self.refrashTime ;
    request.organizationId = self.orgDto.organizationId;
    
    
    WEAK_SELF(self);
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper listOrgMessage:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        [_commentTableView footerEndRefreshing];
        if (ret) {
            
            commentList = [commentList arrayByAddingObjectsFromArray:obj];
            [weakSelf frashTableView];
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
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
    CGFloat btnWidth = 40.f;
    commentField = [[ZXTextField alloc] initWithFrame:CGRectMake(hGap, vGap, CGRectGetWidth(commentInputView.frame)-hGap*3-btnWidth, CGRectGetHeight(commentInputView.frame)-vGap*2)];
    commentField.placeholder = @"写写你想要说的";
    commentField.font = FONT_16;
    commentField.largeTextLength = 200;
    //commentField.keyboardType = UIKeyboardTypeNumberPad;
    commentField.autoHideKeyboard = YES;
    [commentInputView addSubview:commentField];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(commentInputView.frame)-vGap-btnWidth, vGap, btnWidth, CGRectGetHeight(commentField.frame))];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"tl_btn_send"] forState:UIControlStateNormal];
    [commentInputView addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(sendBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)sendBtnHandler:(UIButton*)btn{
    [self.view endEditing:YES];
    [self doComment:@"1"];
}

-(void)itemSelected:(id)itemData{
    
}


-(void)doComment:(NSString *)operType{
    NSString *commentStr = commentField.text;
    if (commentStr.length==0) {
        [GHUDAlertUtils toggleMessage:@"请说点什么吧"];
        return;
    }
    
    
    TLSendOrgMessageRequestDTO *requestDto = [[TLSendOrgMessageRequestDTO alloc] init];
    requestDto.content = commentStr;
    requestDto.organizationId = self.orgDto.organizationId;
    requestDto.type = operType;//获取使用的tlb 确认信息
    WEAK_SELF(self);
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper sendOrgMessage:requestDto requestArr:self.requestArray block:^(id obj, BOOL ret) {
        
        [GHUDAlertUtils hideLoadingInView:self.view];
        TLSendOrgMessageResponseDTO *response = obj;
        if (ret) {
            
            if (operType.integerValue==1) {
                
                [GHUDAlertUtils showZXColorAlert:response.result.message subTitle:@"" cancleButton:MultiLanguage(comCancel) sureButtonTitle:MultiLanguage(comSure)  COLORButtonType:(RED_BUTTON_TYPE) buttonHeight:35 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
                    if (index == 1) {
                       [weakSelf doComment:@"2"];
                    }
                }];

                
            }
            
            
            //发送成功
            if (operType.integerValue==2) {
                [GHUDAlertUtils toggleMessage:@"发送成功"];
                [weakSelf initData];
                commentField.text = @"";
            }
            
            
            
        }else{
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
        
    }];
    
}


@end
