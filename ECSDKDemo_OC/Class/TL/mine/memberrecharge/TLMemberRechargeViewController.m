//
//  TLMemberRechargeViewController.m
//  TL
//
//  Created by Rainbow on 4/22/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLMemberRechargeViewController.h"
#import "RUILabel.h"
#import "ZXColorButton.h"
#import "TLUserViewResultDTO.h"
#import "TLBuyTLBRequestDTO.h"
#import "TLModuleDataHelper.h"
#import "TLMineStoreListItem.h"
#import "TLBuyTLBResponseDTO.h"
#import "TLTlbChargeResultDTO.h"
#import "TLTlbChanrgeResponseDTO.h"

@interface TLMemberRechargeViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    CGFloat yOffSet ;
    UITextField *moneyField;
    TLUserViewResultDTO *userDto;
    TLBuyTLBResponseDTO *result;
    RUILabel *count;
}
//@property (nonatomic,strong) NSString *productID;
@property (nonatomic,strong) NSArray *productIds;
@property (nonatomic,strong )NSArray *products;
//@property (nonatomic,strong )NSArray *productNames;


@property (nonatomic,strong) NSString *currentTLB;
@property (nonatomic,assign) BOOL initFlag;
@end

@implementation TLMemberRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.initFlag = YES;
    self.title = @"途乐币充值";
    userDto = self.itemData;
    yOffSet = NAVIGATIONBAR_HEIGHT+STATUSBAR_HEIGHT;
    
    
     [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//     self.productID = @"com.mst.tl.tlb1";
    self.productIds = @[@"com.mst.tl.tlb.120",@"com.mst.tl.tlb.tlb240",@"com.mst.tl.tlb.tlb600",@"com.mst.tl.tlb.tlb1200"];
//    self.productNames = @[@"120个途乐币",@"240个途乐币",@"600个途乐币",@"1200个途乐币"];
    [self addAllUIResources];
    
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addAllUIResources{
    //yu e
    [self addTlbYue];
    //info
    [self addTlbAndMoney];
    //input ok
    //[self addTlbCountAndOkBtn];
    
    
    
    
}

-(void)addTlbYue{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, self.view.width, 50.f)];
    view.backgroundColor = COLOR_WHITE_BG;
    [self.view addSubview:view];
    
    RUILabel *label = [[RUILabel alloc] initWithFrame:CGRectZero str:@"途乐币余额" font:FONT_16 color:COLOR_MAIN_TEXT];
    [label setX:10.f andY:(50-label.height)/2];
    [view addSubview:label];
    
    count = [[RUILabel alloc] initWithFrame:CGRectZero str:[NSString stringWithFormat:@"余额￥%@",userDto.tlb] font:FONT_14 color:COLOR_ASSI_TEXT];
    [count setX:view.width-count.width-10 andY:(50-count.height)/2];
    [view addSubview:count];
    
    yOffSet = yOffSet + 50.f;
    
}
-(void)addTlbAndMoney{
    RUILabel *moneyLabel = [[RUILabel alloc] initWithFrame:CGRectZero str:@"内购产品" font:FONT_14 color:COLOR_ASSI_TEXT];
    [moneyLabel setX:10.f andY:yOffSet+10];
    [self.view addSubview:moneyLabel];

    yOffSet = yOffSet + moneyLabel.height+20.f;
}
-(void)addTlbCountAndOkBtn{
    CGFloat hGap = 10.f;
    CGFloat btnWidth = 80.f;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, yOffSet, self.view.width, 50.f)];
    view.backgroundColor = COLOR_WHITE_BG;
    [self.view addSubview:view];
    
    moneyField = [[UITextField alloc] initWithFrame:CGRectMake(hGap, 0.f, CGRectGetWidth(view.frame)-hGap*3 - btnWidth, CGRectHeight(view.frame))];
    [view addSubview:moneyField];
    moneyField.keyboardType = UIKeyboardTypeNumberPad;
    moneyField.placeholder = @"请输入充值金额";
    WEAK_SELF(self);
    UIButton *newUserBtn = [ZXColorButton buttonWithType:EZXBT_BOX_GREEN frame:CGRectMake(view.width-hGap-btnWidth, hGap, btnWidth, (view.height-hGap*2)) title:@"确定充值" font:FONT_14 block:^{
        [weakSelf chargeFromInPurchent];
    }];
    [self.view addSubview:newUserBtn];
}

-(void)addTLBItems{
    
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
    
    
    [sortArray enumerateObjectsUsingBlock:^(SKProduct* pro, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *itemDataYear = @{@"NAME":[NSString stringWithFormat:@"%@ - %@元",pro.localizedTitle,pro.price],@"IMAGE":@"charge",@"product":pro};
        TLMineStoreListItem *storeItemYear = [[TLMineStoreListItem alloc] initWithFrame:CGRectMake(0.f, yOffSet, CGRectGetWidth(self.view.frame), 50.f) itemData:itemDataYear isShowAction:YES];
        [self.view addSubview:storeItemYear];
        yOffSet = yOffSet + CGRectGetHeight(storeItemYear.frame);
        [storeItemYear addTarget:self action:@selector(buyHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        

    }];
    
    self.initFlag = NO;
   
}


/*
 * 1，调用后台购买， 2，调用内购 3，调用后台
 */
-(void)buyHandler:(TLMineStoreListItem*)btn{
    
    [GHUDAlertUtils toggleLoadingInView:self.view];
    
    NSDictionary *itemData = btn.itemData;
    SKProduct * product = [itemData valueForKey:@"product"];
   self.currentTLB =[NSString stringWithFormat:@"%@",product.price];
    
    
//    [GHUDAlertUtils showZXColorAlert:@"请确认购买信息" subTitle:[NSString stringWithFormat:@"您想用￥%@的价格购买%@",product.price,product.localizedTitle] cancleButton:@"取消" sureButtonTitle:@"购买" COLORButtonType:0 buttonHeight:40 clickedBlock:^(ZXColorAlert *alert, NSUInteger index) {
//        
//        
//        if (index == 1) {
    
            TLBuyTLBRequestDTO *request = [[TLBuyTLBRequestDTO alloc] init];
            request.money = self.currentTLB;
            request.baseUrl = [NSString stringWithFormat:@"%@",TL_SERVER_BASE_URL];
            
            [GTLModuleDataHelper buyTLB:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
                result = obj;
                if (ret) {
                    SKPayment *payment = [SKPayment paymentWithProduct:product];
                    NSLog(@"发送购买请求");

                    [[SKPaymentQueue defaultQueue] addPayment:payment];
                    self.currentTLB  = @"0";
                }else{
                    ResponseDTO *response = obj;
                    [GHUDAlertUtils toggleMessage:response.resultDesc];
                     [GHUDAlertUtils hideLoadingInView:self.view];
                }
            }];
//        }
    
        
//    }];

    
    
   
    
}

-(void)sendTlbCountToServer{
 
    if (result==nil||result.result.orderId.length==0) {
        return;
    }
    
    TLTlbChargeRequestDTO *request = [[TLTlbChargeRequestDTO alloc] init];
    request.orderId = result.result.orderId;

        [GTLModuleDataHelper tlbCharge:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
            TLTlbChanrgeResponseDTO*dto = obj;
            if (ret) {
                userDto.tlb = [NSString stringWithFormat:@"%lu",dto.result.tlb.integerValue];
                count.text = [NSString stringWithFormat:@"余额￥%@",userDto.tlb];
                [count setWidth:[count.text sizeWithAttributes:@{NSFontAttributeName:FONT_14}].width];
                [count setX:self.view.width-count.width-10 andY:(50-count.height)/2];
                self.currentTLB  = @"0";
                [GHUDAlertUtils toggleMessage:dto.resultDesc];
            }else{
                ResponseDTO *response = obj;
                [GHUDAlertUtils toggleMessage:response.resultDesc];
            }
        }];

}

-(void)charge{
    [self.view endEditing:YES];
    NSString *money =  moneyField.text;
    if (money.length==0) {
        [GHUDAlertUtils toggleMessage:@"请输入金额"];
        return;
    }
    
    
    TLBuyTLBRequestDTO *request = [[TLBuyTLBRequestDTO alloc] init];
    request.money = money;
    request.baseUrl = [NSString stringWithFormat:@"%@",TL_SERVER_BASE_URL];
    
    
    //从服务购买途乐币功能 --- 注销
    
//    [GHUDAlertUtils toggleLoadingInView:self.view];
//    [GTLModuleDataHelper buyTLB:request requestArr:self.requestArray block:^(id obj, BOOL ret) {
//        
//        [GHUDAlertUtils hideLoadingInView:self.view];
//        if (ret) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            ResponseDTO *response = obj;
//            [GHUDAlertUtils toggleMessage:response.resultDesc];
//        }
//    }];
    
    
}


-(void)chargeFromInPurchent{
    [self.view endEditing:YES];
    NSString *money =  moneyField.text;
    if (money.length==0) {
        [GHUDAlertUtils toggleMessage:@"请输入金额"];
        return;
    }
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
    
    SKProduct *p = nil;
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        
//        if([pro.productIdentifier isEqualToString:self.productID]){
//            p = pro;
//        }
    }
    
    self.products = product;
    
    [self addTLBItems];
    
//    SKPayment *payment = [SKPayment paymentWithProduct:p];
//    
//    NSLog(@"发送购买请求");
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
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
                [self sendTlbCountToServer];
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
                if (self.initFlag) {
                    
                }else{
                    [GHUDAlertUtils toggleMessage:@"交易失败"];
                }
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
