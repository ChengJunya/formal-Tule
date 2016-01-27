//
//  TLLeftViewController.m
//  TL
//
//  Created by Rainbow on 2/6/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLLeftViewController.h"
#import "BoncDataGridDataSource.h"
#import "ZXColorButton.h"
#import "TLHelper.h"
#import "UserDataHelper.h"
#import "TLShareDTO.h"
#import "TLSysMessageListRequestDTO.h"
#import "RUtiles.h"
#import "TLModuleDataHelper.h"
#import "AppversionHelper.h"


#define TLeftMenuItemHeight 40.f

@interface TLLeftViewController (){
    NSArray *settingMenuList;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) BoncDataGridDataSource *tableViewDataSource;
@property (nonatomic,strong) ZXColorButton *exitBtn;
@property (nonatomic,assign) CGFloat yOffSet;
@property (nonatomic,strong) NSString *isHasNewMesage;
@end

@implementation TLLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHasNewMesage = @"0";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = [UIImage imageNamed:@"left_bg.png"];
    [self.view addSubview:backgroundImageView];
    backgroundImageView.alpha = 0.3;
    
    
    [self addAllUIResources];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
}








-(void)addAllUIResources{
    
    
    _yOffSet = 100.f;
    
    UIView *leftContentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, DRAWER_LEFT_WIDTH, CGRectGetHeight(self.view.frame))];
    [self.view addSubview:leftContentView];
    
    
    [self addMenuList];
    [leftContentView addSubview:self.tableView];
    
    CGFloat lineHGap = 20.f;
    CALayer *line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5].CGColor;
    line.frame = CGRectMake(lineHGap, _yOffSet+20.f, CGRectGetWidth(leftContentView.frame)-lineHGap*2, 1.f);
    [leftContentView.layer addSublayer:line];
    _yOffSet = _yOffSet + 20.f + 1.f;
    

    _exitBtn = [ZXColorButton buttonWithType:EZXBT_SOLID_ORANGE frame:CGRectMake((CGRectGetWidth(leftContentView.frame)-UI_COMM_SHORT_BTN_HEIGHT)/2, _yOffSet+20.f, UI_COMM_SHORT_BTN_HEIGHT, UI_COMM_BTN_HEIGHT) title:MultiLanguage(setvcExitButton) font:FONT_18 block:^{
        
        [self logoutUser];
    }];
    [leftContentView addSubview:_exitBtn];

}

-(void)logoutUser{
    
    
    if(GUserDataHelper.isLoginSucceed){
        [GHUDAlertUtils showZXColorAlert:@"是否退出当前登录？" subTitle:@"" cancleButton:MultiLanguage(comCancel) sureButtonTitle:@"确定" COLORButtonType:0 buttonHeight:40 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
            if (index == 1) {
                [GUserDataHelper exitLoginServer:^(ResponseDTO* obj, BOOL ret) {
                    if (ret) {
                        [GUserDataHelper exitLogin:YES];
                    }else{
                        [GHUDAlertUtils toggleMessage:obj.resultDesc];
                    }
                }];
            }
        }];

    }else{
        [RTLHelper gotoLoginViewController];
    }
    
    
    
    
    
    
}

-(void)updateUI{
    NSString *cellHeight = [NSString stringWithFormat:@"%f",TLeftMenuItemHeight];
    settingMenuList = @[
//                                 @{@"ID":@"1",@"NAME":@"更新系统",@"IMAGE":@"update",@"height":cellHeight,@"isAction":@"1",@"isShowPoint":RTLHelper.hasNewVersion?@"1":@"0"},
                                 @{@"ID":@"2",@"NAME":@"系统消息",@"IMAGE":@"message",@"height":cellHeight,@"isAction":@"1",@"isShowPoint":RTLHelper.hasNewSystemMessage?@"1":@"0"},
                                 @{@"ID":@"3",@"NAME":@"应用分享",@"IMAGE":@"share",@"height":cellHeight,@"isAction":@"1",@"isShowPoint":@"0"},
                                  @{@"ID":@"6",@"NAME":@"应用设置",@"IMAGE":@"left_menu_set",@"height":cellHeight,@"isAction":@"1",@"isShowPoint":@"0"},
                                 @{@"ID":@"4",@"NAME":@"关于我们",@"IMAGE":@"about",@"height":cellHeight,@"isAction":@"1",@"isShowPoint":@"0"},
                                 @{@"ID":@"5",@"NAME":@"清除缓存",@"IMAGE":@"clean",@"height":cellHeight,@"isAction":@"1",@"isShowPoint":@"0"}];
    
    
    self.tableViewDataSource.sections = @[@{@"SECTION_TYPE":@"1",@"CELL_TYPE": @"LEFT_MENU_LIST_GRID"}];
    NSMutableArray *gridData = [NSMutableArray array];
    [gridData addObject:settingMenuList];
    self.tableViewDataSource.gridData = gridData;
    
    if(GUserDataHelper.isLoginSucceed){
        [_exitBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    }else{
        [_exitBtn setTitle:@"登录" forState:UIControlStateNormal];
    }

}

-(void)addMenuList{

//    NSString *cellHeight = [NSString stringWithFormat:@"%f",TLeftMenuItemHeight];
//    settingMenuList = @[
//                        @{@"ID":@"1",@"NAME":@"更新系统",@"IMAGE":@"update",@"height":cellHeight,@"isAction":@"1",@"isShowPoint":@"0"},
//                        @{@"ID":@"2",@"NAME":@"系统消息",@"IMAGE":@"message",@"height":cellHeight,@"isAction":@"1",@"isShowPoint":@"0"},
//                        @{@"ID":@"3",@"NAME":@"应用分享",@"IMAGE":@"share",@"height":cellHeight,@"isAction":@"1",@"isShowPoint":@"1"},
//                        @{@"ID":@"4",@"NAME":@"关于我们",@"IMAGE":@"about",@"height":cellHeight,@"isAction":@"1",@"isShowPoint":@"0"},
//                        @{@"ID":@"5",@"NAME":@"清除缓存",@"IMAGE":@"clean",@"height":cellHeight,@"isAction":@"1",@"isShowPoint":@"0"}];

    

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, _yOffSet, CGRectGetWidth(self.view.frame), TLeftMenuItemHeight*6)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    NSDictionary *itemData = @{
                               @"type": @"REPORT",
                               @"gridType": @"LEFT_MENU_LIST_GRID",
                               @"gridId": @"LEFT_MENU_LIST_GRID",
                               @"GRID_DATA": @[],
                               @"SECTION_DATA":@[],
                               @"isShowHeader": @"0",
                               @"headerData": @{}
                               };
    self.tableViewDataSource = [[BoncDataGridDataSource alloc] initWithTableView:self.tableView itemData:itemData];
    
    __weak TLLeftViewController *weakController = self;
    self.tableViewDataSource.ItemSelectedBlock = ^(id itemData){
        [weakController itemSelected:itemData];
    };
    
    _yOffSet = _yOffSet+CGRectGetHeight(self.tableView.frame);
    
    
    [self.tableView reloadData];

}


-(void)checkToUpdate:(NSNotification *)notification
{
    id noteObj = [notification object];
    NSUInteger isShowNotice = [[noteObj valueForKey:@"isShowNotice"] integerValue];
    [GAppversionHelper checkVersionUpdate:self.requestArray block:^(int updateFlag, NSString *latestVersion,UpdateInfoResponseDTO *versionData) {
        if (1 == updateFlag) {
            
            NSString *versionMessage = versionData.result.updateNote;
            versionMessage = [versionMessage stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
            
            
            RTLHelper.hasNewVersion = YES;
            
            
        }else{
            if (isShowNotice==1) {
                
            }
            
        }
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)itemSelected:(NSDictionary *)itemData{
    NSLog(@"%@",[itemData valueForKey:@"NAME"]);
    
    switch ([[itemData valueForKey:@"ID"] intValue]) {
        case 1:
        {
//            [GHUDAlertUtils showZXColorAlert:[itemData valueForKey:@"NAME"] subTitle:@"检查到有更新的版本，确定更新吗？" cancleButton:MultiLanguage(comCancel) sureButtonTitle:MultiLanguage(setvcAlertBtnSure) COLORButtonType:0 buttonHeight:40 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
//                if (index == 1) {
//                    //[GAppversionHelper openAppStoreURL];
//                }
//            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:TL_DRAWER_OPEN_LEFT object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHECK_VERSION object:@{@"isShowNotice":@"1"}];
            break;
        }
        case 2:{
            [[NSNotificationCenter defaultCenter] postNotificationName:TL_DRAWER_OPEN_LEFT object:nil];
            RTLHelper.hasNewSystemMessage = NO;
            [self.tableView reloadData];
            [RTLHelper pushViewControllerWithName:@"TLNoticifacationMessageViewController" block:^(id obj) {
                
            }];
            break;
        }
        case 3:{
            [[NSNotificationCenter defaultCenter] postNotificationName:TL_DRAWER_OPEN_LEFT object:nil];
            
            TLShareDTO *shareDto = [[TLShareDTO alloc] init];
            shareDto.shareUrl = UMSOCIAL_WXAPP_URL;//obj.shareUrl;
            shareDto.shareDesc = @"人在旅途，乐在其中";//obj.shareDesc;
            shareDto.shareTitle = @"途乐";//obj.title;
            shareDto.shareImageUrl = @"https://mmbiz.qlogo.cn/mmbiz/8iar9j6LGcQW1SFufDicnDibEFMMmg8VLGMfbB5IDwpgbpONt86vgjeiacWiciaNj2tqsk9uFHeTDT3YiaqCibQVCK9ZibQ/0?wx_fmt=png";//obj.imageUrl;
            shareDto.patAwardId = @"";//obj.patAwardId;
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHARE object:shareDto];
            break;
        }
            
        case 4:{
            [[NSNotificationCenter defaultCenter] postNotificationName:TL_DRAWER_OPEN_LEFT object:nil];
            [RTLHelper pushViewControllerWithName:@"TLAboutViewController" block:^(id obj) {
                
            }];
            break;
        }
            
        case 5:{
            [self clearCacheAlert];
            break;
        }
        case 6:{
            [[NSNotificationCenter defaultCenter] postNotificationName:TL_DRAWER_OPEN_LEFT object:nil];
            [RTLHelper pushViewControllerWithName:@"ADPersonalInfoViewController" block:^(id obj) {
                
            }];
            
            break;
        }
        default:
            break;
    }
}


-(void) timerFired:(NSInteger)stepNumber
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (stepNumber >= 2) {
            [GHUDAlertUtils hideLoadingInView:self.view];
            [GHUDAlertUtils toggleMessage:@"清理缓存完成"];
        }
    });
}

-(void) cleanCacheMethod
{
    __block NSInteger stepNumber = 0;
    __weak TLLeftViewController *weakSelf = self;
    [GHUDAlertUtils toggleLoadingInView:self.view];
    NSInteger cashSize = [[SDImageCache sharedImageCache] getSize];
    //清除图片缓存：
    [[SDImageCache sharedImageCache] clearMemory];
    stepNumber++;
    [self timerFired:stepNumber];
    
    [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:^{
        stepNumber++;
        [weakSelf timerFired:stepNumber];
    }];
    
    //删除声音缓存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[GNSFileManager removeItemAtURL:[ZXCachePathUtils voiceCachePath] error:nil];
        //[GNSFileManager createDirectoryAtURL:[ZXCachePathUtils voiceCachePath] withIntermediateDirectories:NO attributes:nil error:nil];
        //stepNumber++;
        //[weakSelf timerFired:stepNumber];
    });
}


-(void)clearCacheAlert
{
    CustomActionSheet * actinSheet = [[CustomActionSheet alloc] initWithButtonTitles:@[@"确定",@"取消"]];
    [actinSheet setButtonBackGroundImage:[UIImage resizedImage:@"btn_red_p" leftScale:0.2 topScale:1] forState:(UIControlStateNormal)];
    [actinSheet setButtonBackGroundImage:[UIImage resizedImage:@"btn_red_p" leftScale:0.2 topScale:1] forState:(UIControlStateHighlighted)];
    [actinSheet showActionSheetInView:self.navigationController.view];
    
    [actinSheet actionSheetSelectBlock:^(CustomActionSheet *actionSheet, NSUInteger index) {
        //清除缓存
        if (0 == index) {
            [self cleanCacheMethod];
        }
    }];
    
}

@end
