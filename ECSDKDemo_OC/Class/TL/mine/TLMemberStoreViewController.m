//
//  TLMemberStoreViewController.m
//  TL
//
//  Created by Rainbow on 2/26/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLMemberStoreViewController.h"
#import "TLFormItem.h"
#import "TLMineStoreListItem.h"
#import "TLMineListItem.h"
#import "RImageList.h"
#import "TLStoreProItem.h"
#import "TLUserViewResultDTO.h"
#import "TLModuleDataHelper.h"
#import "TLOpenVipRequestDTO.h"
#import "TLOpenVipResultDTO.h"
#import "BaseDTOModel.h"
#import "TLOpenVipResultDTO.h"
#define TL_MEMBER_STORE_TOP_IMAGE_HEIGHT 170.f
@interface TLMemberStoreViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    CGFloat yOffSet;
    
    TLMineStoreListItem *storeItemYear;
    TLMineStoreListItem *storeItemMonth;
    TLFormItem *viptitleItem;
    NSString *vipType;//当前要购买的vipType
}
@property (nonatomic,strong) TLUserViewResultDTO *userInfoDto;
@property (nonatomic,strong) UIScrollView *contentScrollView;

@property (nonatomic,strong) NSArray *productIds;
@property (nonatomic,strong )NSArray *products;

@end

@implementation TLMemberStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"途乐商店";
    self.userInfoDto = self.itemData;
    yOffSet = 0.f;
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-NAVIGATIONBAR_HEIGHT-STATUSBAR_HEIGHT)];
    [self.view addSubview:self.contentScrollView];
    
     self.productIds = @[@"com.mst.tl.monthvip",@"com.mst.tl.yearvip"];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    
    if([SKPaymentQueue canMakePayments]){
        [GHUDAlertUtils toggleLoadingInView:self.view];
        [self requestProductData];
    }else{
        NSLog(@"不允许程序内付费");
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarHidden = NO;
    self.navBackItemHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addAllUIResources{
    //imagebg
    [self addTopImage];
    //usericon name vip
    [self addUserImage];
    //bevip
    [self addBeVip];
    [self addAboutVip];
    [self addCallVip];
    //tulewallet
    //[self addTuleWallet];
    //vip experience
    //[self addVipExp];
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentScrollView.frame), yOffSet);
}

-(void)addTopImage{

    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), TL_MEMBER_STORE_TOP_IMAGE_HEIGHT)];
    topImageView.image = [UIImage imageNamed:@"vip_bg2.jpg"];
    [self.contentScrollView addSubview:topImageView];
    
    yOffSet = yOffSet+CGRectGetHeight(topImageView.frame);
}

-(void)addUserImage{
    CGFloat userImageWidth = 60.f;
    CGFloat vGap = 5.f;
    NSDictionary *timeDic = [NSDictionary dictionaryWithObjectsAndKeys:FONT_14,NSFontAttributeName ,nil];
    NSString *userName = self.userInfoDto.userName;
    CGSize userNameSize = [userName sizeWithAttributes:timeDic];
    //*****end add userImage ******
     NSString *userIconUrl = [NSString stringWithFormat:@"%@%@",TL_SERVER_BASE_URL,self.userInfoDto.userIcon];
    UIImageView *userImageView;
    if (userIconUrl) {
        
        userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-userImageWidth/2, yOffSet-userImageWidth-vGap*2-userNameSize.height, userImageWidth, userImageWidth)];
        userImageView.layer.borderWidth = 0.5f;
        userImageView.layer.borderColor = [UIColor grayColor].CGColor;
        userImageView.layer.cornerRadius = userImageWidth/2;
        [self.contentScrollView addSubview:userImageView];

        userImageView.layer.masksToBounds = YES;
        
        [userImageView sd_setImageWithURL:[NSURL URLWithString:userIconUrl] placeholderImage:[UIImage imageNamed:@"ico_loading_logo"]];
        
    }
    
    if (userImageView) {
        UIImageView *vipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userImageView.frame)+vGap, CGRectGetMidY(userImageView.frame)-7.f, 60.f, 14.f)];
        NSString *vipImageStr =[NSString stringWithFormat:@"tl_mine_viplv%@",self.userInfoDto.vipLevel];
        vipImageView.image = [UIImage imageNamed:vipImageStr];
        [self.contentScrollView addSubview:vipImageView];
    }
    
    
    
    

    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2-userNameSize.width/2, yOffSet-vGap-userNameSize.height, userNameSize.width, userNameSize.height)];
    userNameLabel.font = FONT_14;
    userNameLabel.text = userName;
    userNameLabel.textColor = COLOR_MAIN_TEXT;
    [self.contentScrollView addSubview:userNameLabel];
    
    
    
    
    
    //yOffSet = yOffSet + CGRectGetHeight(userNameLabel.frame);
    //*****end userImage ******
}

-(void)addBeVip{
    
    NSComparator cmptr = ^(SKProduct* obj1, SKProduct* obj2){
        
        if (obj1.price.integerValue > obj2.price.integerValue) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (obj1.price.integerValue < obj2.price.integerValue) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    
    NSArray *sortArray = [self.products sortedArrayUsingComparator:cmptr];

    
    NSString *vipEndDate =  self.userInfoDto.vipEndTime.length==0?@"":self.userInfoDto.vipEndTime;
    if (vipEndDate.length>0) {
        vipEndDate = [vipEndDate substringToIndex:10];
    }
    
    NSString *valueStr = vipEndDate.length==0?@"":[NSString stringWithFormat:@"会员到期日期：(%@)",vipEndDate];
    
    CGFloat vGap = 5.f;
    CGFloat vLineSpace = 1.f;
    viptitleItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet+vLineSpace, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"成为会员",@"LABEL_VALUE":valueStr}];
    viptitleItem.frame = viptitleItem.itemFrame;
    [viptitleItem setW:self.view.width];
    [self.contentScrollView addSubview:viptitleItem];
    yOffSet = yOffSet + CGRectGetHeight(viptitleItem.frame)+vLineSpace*2;
    
    
   
    
    

    
    //sortArray.count >0
    if (sortArray.count>0) {
        SKProduct* proMonth = sortArray[0];
        NSDictionary *itemDataMonth = @{@"vipType":@"1",@"NAME":[NSString stringWithFormat:@"%@ - %@元",proMonth.localizedTitle,proMonth.price],@"IMAGE":@"month_vip",@"product":proMonth};
        
        
        //NSDictionary *itemDataYear = @{@"NAME":[NSString stringWithFormat:@"年会员(%@)",vipEndDate],@"IMAGE":@"year_vip"};
        storeItemYear = [[TLMineStoreListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 50.f) itemData:itemDataMonth isShowAction:YES];
        [self.contentScrollView addSubview:storeItemYear];
        yOffSet = yOffSet + CGRectGetHeight(storeItemYear.frame);
        [storeItemYear addTarget:self action:@selector(storeItemYearHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
  
    //sortArray.count >1
    if (sortArray.count>1) {
        SKProduct* proYear = sortArray[1];
        
        NSDictionary *itemDataYear = @{@"vipType":@"2",@"NAME":[NSString stringWithFormat:@"%@ - %@元",proYear.localizedTitle,proYear.price],@"IMAGE":@"year_vip",@"product":proYear};
        
        //NSDictionary *itemDataMonth = @{@"NAME":[NSString stringWithFormat:@"月会员(%@)",vipEndDate],@"IMAGE":@"month_vip"};
        storeItemMonth = [[TLMineStoreListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 50.f) itemData:itemDataYear isShowAction:YES];
        [self.contentScrollView addSubview:storeItemMonth];
        yOffSet = yOffSet + CGRectGetHeight(storeItemMonth.frame)+vGap;
        [storeItemMonth addTarget:self action:@selector(storeItemYearHandler:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(void)storeItemYearHandler:(TLMineStoreListItem*)btn{
    [GHUDAlertUtils toggleLoadingInView:self.view];
    
    NSDictionary *itemData = btn.itemData;
    SKProduct * product = [itemData valueForKey:@"product"];
    vipType = [itemData valueForKey:@"vipType"];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    NSLog(@"发送购买请求");
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
//    TLOpenVipRequestDTO *request = [[TLOpenVipRequestDTO alloc] init];
//    request.vipType  = @"2";
//    request.operateType = @"1";
//    WEAK_SELF(self);
//    [GHUDAlertUtils toggleLoadingInView:self.view];
//    [GTLModuleDataHelper openVip:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
//        //buyInfo endDate
//        [GHUDAlertUtils hideLoadingInView:self.view];
//        if (ret) {
//            TLOpenVipResultDTO *result = obj;
//            [GHUDAlertUtils showZXColorAlert:result.buyInfo subTitle:@"" cancleButton:MultiLanguage(comCancel) sureButtonTitle:MultiLanguage(comSure)  COLORButtonType:(RED_BUTTON_TYPE) buttonHeight:35 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
//                if (index == 1) {
//                    [weakSelf buyVipByType:request.vipType];
//                }
//            }];
//
//            
//
//        }else{
//            ResponseDTO *response = obj;
//            [GHUDAlertUtils toggleMessage:response.resultDesc];
//        }
//    }];

}

-(void)buyVipByType{
    TLOpenVipRequestDTO *request = [[TLOpenVipRequestDTO alloc] init];
    request.vipType  = vipType;
    request.operateType = @"2";

    [GHUDAlertUtils toggleLoadingInView:self.view];
    [GTLModuleDataHelper openVip:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
        //buyInfo endDate
        [GHUDAlertUtils hideLoadingInView:self.view];
        if (ret) {
            TLOpenVipResultDTO *result = obj;
            NSString *vipEndDate =  result.endDate.length==0?@"":result.endDate;
            if (vipEndDate.length>0) {
                vipEndDate = [vipEndDate substringToIndex:10];
            }
//            [storeItemYear setTitle:[NSString stringWithFormat:@"年会员(%@)",vipEndDate]];
//            [storeItemMonth setTitle:[NSString stringWithFormat:@"年会员(%@)",vipEndDate]];
            [viptitleItem setValueStr:[NSString stringWithFormat:@"会员到期日期：(%@)",vipEndDate]];
            [GHUDAlertUtils toggleMessage:@"开通VIP成功！"];
        }else{
            ResponseDTO *response = obj;
            [GHUDAlertUtils toggleMessage:response.resultDesc];
        }
    }];
}




-(void)storeItemMonthHandler:(id)btn{
    
//    TLOpenVipRequestDTO *request = [[TLOpenVipRequestDTO alloc] init];
//    request.vipType  = @"1";
//    request.operateType = @"1";
//    WEAK_SELF(self);
//    [GHUDAlertUtils toggleLoadingInView:self.view];
//    [GTLModuleDataHelper openVip:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
//        //buyInfo endDate
//        [GHUDAlertUtils hideLoadingInView:self.view];
//        if (ret) {
//            TLOpenVipResultDTO *result = obj;
//            [GHUDAlertUtils showZXColorAlert:result.buyInfo subTitle:@"" cancleButton:MultiLanguage(comCancel) sureButtonTitle:MultiLanguage(comSure)  COLORButtonType:(RED_BUTTON_TYPE) buttonHeight:35 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
//                if (index == 1) {
//                    [weakSelf buyVipByType:request.vipType];
//                }
//            }];
//            
//            
//            
//        }else{
//            ResponseDTO *response = obj;
//            [GHUDAlertUtils toggleMessage:response.resultDesc];
//        }
//    }];

}

-(void)addTuleWallet{
    CGFloat vGap = 5.f;
    NSDictionary *itemData = @{@"NAME":@"途乐钱包",@"IMAGE":@"wallet"};
    TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 50.f) itemData:itemData];
    [self.contentScrollView addSubview:storeItem];
    [storeItem addTarget:self action:@selector(walletHanlder:) forControlEvents:UIControlEventTouchUpInside];
    yOffSet = yOffSet + CGRectGetHeight(storeItem.frame)+vGap;
}

-(void)addAboutVip{
    CGFloat vGap = 5.f;
    NSDictionary *itemData = @{@"NAME":@"会员说明",@"IMAGE":@"vip_remark_icon"};
    TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 50.f) itemData:itemData];
    [self.contentScrollView addSubview:storeItem];
    [storeItem addTarget:self action:@selector(aboutHanlder:) forControlEvents:UIControlEventTouchUpInside];
    yOffSet = yOffSet + CGRectGetHeight(storeItem.frame)+vGap;
}

-(void)addCallVip{
     CGFloat vGap = 5.f;
    NSDictionary *itemData = @{@"NAME":@"会员专线",@"IMAGE":@"vip_phone_icon"};
    TLMineListItem *storeItem = [[TLMineListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 50.f) itemData:itemData isShowAction:NO];
    [self.contentScrollView addSubview:storeItem];
   
    yOffSet = yOffSet + CGRectGetHeight(storeItem.frame)+vGap;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake( storeItem.width-60.f-10.f, 10.f, 60.f, storeItem.height-20.f)];
    [btn setBackgroundImage:[UIImage imageNamed:@"vip_call_icon"] forState:UIControlStateNormal];
    [storeItem addSubview:btn];
     [btn addTarget:self action:@selector(callHanlder:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)aboutHanlder:(id)btn{
    NSLog(@"about");
    [self pushViewControllerWithName:@"TLAboutVipViewController" block:^(id obj) {
        
    }];
}

-(void)callHanlder:(id)btn{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.userInfoDto.phoneNum];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

-(void)walletHanlder:(id)btn{
    
}

-(void)addVipExp{
    CGFloat vGap = 5.f;
    CGFloat vLineSpace = 1.f;
    CGFloat hGap = 10.f;
    TLFormItem *titleItem = [[TLFormItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 40.f) itemData:@{@"LABEL_NAME":@"特权体验",@"LABEL_VALUE":@""}];
    titleItem.frame = titleItem.itemFrame;
    [self.contentScrollView addSubview:titleItem];
    yOffSet = yOffSet + CGRectGetHeight(titleItem.frame)+vLineSpace;
    
    
    
    UIScrollView *proScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 100.f)];
    proScroll.backgroundColor = UIColorFromRGBA(0xffffff, 0.5f);
    [self.contentScrollView addSubview:proScroll];
    CGFloat itemHeight = CGRectGetHeight(proScroll.frame);
    CGFloat itemWidth = itemHeight-20.f;
    
    TLStoreProItem *levelItem = [[TLStoreProItem alloc] initWithFrame:CGRectMake(hGap, vGap, itemWidth, itemHeight-vGap*2) itemData:@{@"NAME":@"等级购买",@"IMAGE":@"buy_lv"}];
    [proScroll addSubview:levelItem];
    
    TLStoreProItem *hornItem = [[TLStoreProItem alloc] initWithFrame:CGRectMake(hGap+CGRectGetMaxX(levelItem.frame), vGap, itemWidth, itemHeight-vGap*2) itemData:@{@"NAME":@"等级购买",@"IMAGE":@"buy_horn"}];
    [proScroll addSubview:hornItem];
    
    proScroll.contentSize = CGSizeMake(CGRectGetWidth(proScroll.frame), CGRectGetHeight(proScroll.frame));
    yOffSet = yOffSet+CGRectGetHeight(proScroll.frame)+vGap;
}






//请求商品
- (void)requestProductData{
    NSLog(@"-------------请求对应的产品信息----------------");
    
    
    NSSet *nsset = [NSSet setWithArray:self.productIds];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    [GHUDAlertUtils hideLoadingInView:self.view];
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    if([product count] == 0){
        NSLog(@"--------------没有商品------------------");
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",[product count]);
    
    
    self.products = product;
    
    [self addAllUIResources];
    
}



//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
    //    [GHUDAlertUtils toggleMessage:@"请求失败，请查看网络"];
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
    //    [GHUDAlertUtils toggleMessage:@"请求成功"];
}


//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        NSLog(@"队列状态变化 %@", transaction);
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                //[GHUDAlertUtils toggleMessage:@"交易完成"];
                [self buyVipByType];
                [self verifyPruchase];
                
                // 将交易从交易队列中删除
                [self completeTransaction:tran];
                
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                //[GHUDAlertUtils toggleMessage:@"商品添加进列表"];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [GHUDAlertUtils toggleMessage:@"已经购买过商品"];
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
                [self completeTransaction:tran];
                break;
            default:
                break;
        }
    }
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    [GHUDAlertUtils hideLoadingInView:self.view];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


#pragma mark 验证购买凭据
- (void)verifyPruchase
{
    
    //https://sandbox.itunes.apple.com/verifyReceipt
    //    当应用程序通过审核上架App Store时，使用商品URL：https://buy.itunes.apple.com/verifyReceipt
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    // 发送网络POST请求，对购买凭据进行验证
    NSURL *url = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
    // 国内访问苹果服务器比较慢，timeoutInterval需要长一点
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    
    request.HTTPMethod = @"POST";
    
    // 在网络中传输数据，大多情况下是传输的字符串而不是二进制数据
    // 传输的是BASE64编码的字符串
    /**
     BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
     BASE64是可以编码和解码的
     */
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = payloadData;
    
    // 提交验证请求，并获得官方的验证JSON结果
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // 官方验证结果为空
    if (result == nil) {
        NSLog(@"验证失败");
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"%@", dict);
    
    if (dict != nil) {
        // 比对字典中以下信息基本上可以保证数据安全
        // bundle_id&application_version&product_id&transaction_id
        NSLog(@"验证成功");
    }
}



@end
