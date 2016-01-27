//
//  ADPersonalInfoViewController.m
//  alijk
//
//  Created by Rainbow on 4/4/15.
//  Copyright (c) 2015 zhongxin. All rights reserved.
//

#import "ADPersonalInfoViewController.h"
#import "ZXTableViewDataSource.h"
#import "AKRedPointCell.h"
#import "ZXUIHelper.h"
#import "RUILabel.h"
#import "ADPersonCenterDTO.h"
#import "ZXCropViewController.h"

#define PEROSN_INFO_HEIGHT 76.f
#define CODE_ICON_HEIGHT 22.f
@interface ADPersonalInfoViewController()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>{
    CGFloat _yOffSet;
    CGFloat _tableViewHeight;
    
    NSInteger unRead_ask;
    NSInteger unRead_order;
    NSInteger unRead_plus;
    
    UILabel *phoneLabel;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ZXTableViewDataSource *dataSource;

@end

@implementation ADPersonalInfoViewController

- (id)init {
    if (self = [super init]) {
        self.title = @"应用设置";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    [self addAllUIResources];
    //加载数据
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)addAllUIResources{
    _yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    _tableViewHeight = self.view.height - NAVIGATIONBAR_HEIGHT - STATUSBAR_HEIGHT - self.tabBarController.tabBar.height - PEROSN_INFO_HEIGHT;
    
    //添加tableview
    [self addSettingTableView];
    
}


#pragma mark - 
#pragma mark - 添加视图


/*
 * 添加设置按钮
 */
//-(void)addSettingBtn{
//    UIImage *settingImage = [UIImage imageNamed:@"ico_shezhi_n"];
//    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    settingButton.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
//    [settingButton setBackgroundImage:settingImage forState:UIControlStateNormal];
//    [settingButton addTarget:self action:@selector(settingButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
//    self.navigationItem.leftBarButtonItem = settingBarButton;
//    
//}

/*
 *添加tableview
 */
-(void)addSettingTableView{
    
    WEAK_SELF(self);
    NSMutableArray *dataList = [[NSMutableArray alloc] init];
    NSArray *sectionList = @[];
    NSDictionary *itemData = @{
                               @"GRID_DATA": @[dataList],
                               @"SECTION_DATA":sectionList
                               };
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, _yOffSet, CGRectWidth(self.view.frame),_tableViewHeight) style:UITableViewStyleGrouped];
    
    self.tableView.backgroundColor = COLOR_DEF_BG;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  
    self.dataSource = [[ZXTableViewDataSource alloc] initWithTableView:self.tableView itemData:itemData];
    self.dataSource.canEditRow = NO;
    self.dataSource.CellBlock = ^UITableViewCell *(id cellData,id sectionData,UITableView *tableView){
        
        return [weakSelf createMicroShoppingListItemCell:cellData sectinData:sectionData tableView:tableView];
        
    };
    
    self.dataSource.CellHeightBlock = ^CGFloat(){
        return [AKRedPointCell cellHeight];
    };
    
    
    
    //选择列表行
    self.dataSource.ItemSelectedBlock = ^(id itemData){
        [weakSelf rowSelected:itemData];
    };
    //创建sections
    self.dataSource.HeaderBlock = ^UIView*(NSDictionary *sectionData,UITableView *tableView){
        if ([sectionData[@"GROUP"] integerValue]==1) {
            return [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.width, 0.01f)];
        }else{
            return [weakSelf createHeaderView:tableView.width];
        }
        
    };
    
    
}


#pragma mark - 
#pragma mark - 视图辅助方法
/*
 * 创建有效药品Cell
 */
-(UITableViewCell *)createMicroShoppingListItemCell:(id)cellData sectinData:(id)sectionData tableView:(UITableView *)tableView{
    ADPersonCenterDTO *dto = cellData;
    static NSString *identifier = @"AKRedPointCell";
    AKRedPointCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AKRedPointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellDto:dto];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (dto.type.integerValue==1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    }
    
    
    return cell;
}

/*
 * 创建失效药品列表Section表头
 */
-(UIView*)createHeaderView:(CGFloat)width{
    UIView *invalidHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, width, 13.f)];
    invalidHeaderView.backgroundColor = COLOR_DEF_BG;
    return invalidHeaderView;
}






/*
 * 信息加密
 */
-(NSString *)changeNumberToAsterisk:(NSString *) str
{
    //截取中间部分
    NSString * str1 = [str substringToIndex:3];
    NSString * str2 = [str substringFromIndex:[str length]-4];
    NSString * str3 = @"****";
    return [[str1 stringByAppendingString:str3] stringByAppendingString:str2];
    
}


#pragma mark -
#pragma mark - 数据处理
/*
 * 初始化数据
 */
-(void)initData{
    // 我的订单 我的询价
    NSArray *section1DataArray = @[
                                   [[ADPersonCenterDTO alloc] initWithId:@"11" title:@"绑定手机号" info:@"" toViewControllers:@[@"TLBindPhoneViewController"] icon:@"icon_wddd" isRedDotHidden:YES],
                                   [[ADPersonCenterDTO alloc] initWithId:@"12" title:@"修改密码" info:@"" toViewControllers:@[@"TLUpdatePasswordViewController"] icon:@"icon_wdxj" isRedDotHidden:YES]
   ];
    
    //我的处方 管理关联医院
    NSArray *section2DataArray = @[
                                   [[ADPersonCenterDTO alloc] initWithId:@"21" title:@"隐身模式" info:@"" toViewControllers:@[@"AssociatedHospitalListViewController",@"HospitalListViewController"]  icon:@"icon_wdcf" isRedDotHidden:YES type:@"2" isOn:YES]
                              ];
    
    //优惠券 我的地址 我的收藏
    NSArray *section3DataArray = @[
                              [[ADPersonCenterDTO alloc] initWithId:@"31" title:@"群组消息提醒" info:@"" toViewControllers:@[@"MyCouponViewController"] icon:@"icon_yhq" isRedDotHidden:YES type:@"2" isOn:YES],
                              [[ADPersonCenterDTO alloc] initWithId:@"32" title:@"所有人的消息提醒" info:@"" toViewControllers:@[@"MyAddressController"] icon:@"icon_wddz" isRedDotHidden:YES type:@"2" isOn:YES]
                              ];
    
    //AK 我的医生 我的加号 我的挂号 我的关注
    NSArray *section4DataArray = @[
                              [[ADPersonCenterDTO alloc] initWithId:@"41" title:@"聊天背景设置" info:@"" toViewControllers:@[@"TLSetChatBackgroundViewController"] icon:@"icon_wdys" isRedDotHidden:YES]
                              ];
    
    //AK 我的医生 我的加号 我的挂号 我的关注
    NSArray *section5DataArray = @[
                                   [[ADPersonCenterDTO alloc] initWithId:@"41" title:@"3G/4G下载文件" info:@"" toViewControllers:@[@""] icon:@"icon_wdys" isRedDotHidden:YES type:@"2" isOn:YES]
                                   ];
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:@[section1DataArray,section2DataArray,section3DataArray,section4DataArray,section5DataArray]];
    
    NSArray *sectionArray = @[
                              @{@"GROUP":@"1",@"CELL_TYPE": @"CELL_AD"},
                              @{@"GROUP":@"2",@"CELL_TYPE": @"CELL_AD"},
                              @{@"GROUP":@"3",@"CELL_TYPE": @"CELL_AD"},
                              @{@"GROUP":@"4",@"CELL_TYPE": @"CELL_AD"},
                              @{@"GROUP":@"5",@"CELL_TYPE": @"CELL_AD"}
    
                              ];
    self.dataSource.sections = sectionArray;
    self.dataSource.gridData = dataArray;
    //[self.tableView reloadData];
}





#pragma mark -
#pragma mark - 事件处理




/*
 * 选择行事件
 */
-(void)rowSelected:(id)cellData{
    ADPersonCenterDTO *cellDto = cellData;
    NSString *toVcName = cellDto.toViewControllers[0];
    
    //特殊处理部分
    switch (cellDto.dtoId.intValue) {
       
        case 41:
        {
            [self didImageSelected];
            break;
        }
        default:{
            //默认部分
            if (toVcName.length>0) {
                [self pushViewControllerWithName:toVcName block:^(id obj) {
                    
                }];
            }
            break;
        }
    }
}


/**
 *  ////////////////////////////////////  图片选择
 */



#pragma mark-

//textMessageDelegate选择图库按钮事件
-(void)didImageSelected{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setEditing:NO];
    
    imagePicker.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.allowsEditing = NO;
    //isCamera = 0;
    
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

//图片选择
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    NSString *strType = [info valueForKey:UIImagePickerControllerMediaType];//媒体类型
    
    if ([strType hasSuffix:@"image"]) {
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];//获取图片
        
        
        
        ZXCropViewController* pecontroller = [[ZXCropViewController alloc] init];
        pecontroller.delegate = self;
        pecontroller.image = image;
        
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat length = MIN(width, height);
        pecontroller.imageCropRect = CGRectMake((width - length) / 2,
                                                (height - length) / 2,
                                                length,
                                                length);
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pecontroller];
        [self presentViewController:nav animated:NO completion:nil];
        
        
    }

    
}

#pragma mark -
#pragma mark - PECropViewControllerDelegate method

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller.navigationController dismissViewControllerAnimated:YES completion:nil];

    
    WEAK_SELF(self);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *newImage = [croppedImage cropImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf saveAndShowImage:newImage];
            
            
        });
    });
}

-(void)saveAndShowImage:(UIImage*)image{
    

    
    NSString *fileName = [NSString stringWithFormat:@"%@.JPEG",CHAT_BG_IMAGE_NAME];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //并给文件起个文件名
    NSString *imageDir = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"MST"] stringByAppendingPathComponent:@"images"];
    NSLog(@"imagedir:%@",imageDir);
    
    NSString *imagePath =[imageDir stringByAppendingPathComponent:fileName];
    NSLog(@"imagePath:%@",imagePath);
    
    
    //创建文件夹路径
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    //创建图片
    //[UIImagePNGRepresentation([UIImage imageWithData:data]) writeToFile:imagePath atomically:YES];
    [UIImageJPEGRepresentation(image,1) writeToFile:imagePath atomically:YES];
    
    [GUserDefault setValue:fileName forKey:CHAT_BG_IMAGE_NAME];
    NSLog(@"聊天背景图片名称:%@",[GUserDefault valueForKey:CHAT_BG_IMAGE_NAME]);
    
    [GHUDAlertUtils toggleMessage:@"设置成功"];
}



-(void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller.navigationController dismissViewControllerAnimated:YES completion:nil];
}





@end
