//
//  NetHttpClient.m
//  alijk
//
//  Created by easy on 14/7/23.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//


#import "NetHttpClient.h"
#import "NetMappingModel.h"
#import "BaseDTOModel.h"
#import "NSString+Json.h"
#import "NetUploader.h"
#import "AFNetworkReachabilityManager.h"

#import "MMObjectModel.h"
#import "MMXMLReader.h"

#define APP_To_Publish @"PUBLISH"
// 正式发布
#ifdef APP_To_Publish
#define SERVER_BASE_URL  @"http://210.73.202.85:9080/travel" // 生产服务器测试ip http://210.73.202.84:9080/travel/  http://121.42.208.158:8080/travel
#endif

// 测试使用
#ifdef APP_To_Test
#define SERVER_BASE_URL  @"http://210.73.202.85:9080/travel" // 生产服务器测试ip http://210.73.202.84:9080/travel/  http://121.42.208.158:8080/travel
#endif

// 开发使用
#ifdef APP_To_Develop
#define SERVER_BASE_URL  @"http://210.73.202.85:9080/travel" // 生产服务器测试ip http://210.73.202.84:9080/travel/  http://121.42.208.158:8080/travel

#endif



@interface NetHttpClient ()

@property (nonatomic, strong) NetUploader *netUploader;//上传者
@property (nonatomic, strong) NSMutableArray *adapterMappingList; //适配器数组

@end



@implementation NetHttpClient

static CGFloat NETHTTP_OPERATION_TIMEOUT = 120.f; //网络超时时间

#pragma mark-
#pragma mark init

//单例
+(NetHttpClient*)sharedHTTPClient
{
    static NetHttpClient *_sharedHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:SERVER_BASE_URL]];
    });
    
    return _sharedHTTPClient;
}

-(instancetype)initWithBaseURL:(NSURL*)url
{
    if (self = [super initWithBaseURL:url])
    {
        [self initMappingList];
        [self deleteCookies];
        
        self.operationQueue.maxConcurrentOperationCount = 10;
        
        AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        jsonResponseSerializer.removesKeysWithNullValues = NO; // 注意：处理<null>性能消耗较大，先禁用
        NSSet *acceptSet = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/html", nil];
        [jsonResponseSerializer.acceptableContentTypes setByAddingObjectsFromSet:acceptSet];
        self.responseSerializer = jsonResponseSerializer;
        
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        self.requestSerializer.timeoutInterval = NETHTTP_OPERATION_TIMEOUT;
        
        // uploader
        self.netUploader = [[NetUploader alloc] initWithBaseURL:url];
        self.netUploader.requestSerializer = self.requestSerializer;
        self.netUploader.responseSerializer = self.responseSerializer;
    }
    
    return self;
}

-(void)initMappingList
{
    self.adapterMappingList = [NSMutableArray array];
    //读取适配数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NetAdapterList" ofType:@"plist"];
    NSMutableArray *mappingArray = [NSMutableArray arrayWithContentsOfFile:path];
    for (NSDictionary *dict in mappingArray) {
        NetMappingModel *model = [[NetMappingModel alloc] init];
        model.requestDTO = [dict objectForKey:@"RequestDTO"];//请求的dto
        model.pathPattern = [dict objectForKey:@"PathPattern"];//访问路径
        model.responseDTO = [dict objectForKey:@"ResponseDTO"];//反馈的dto
        model.describe = [dict objectForKey:@"Describe"];//描述
        model.requestType = [[dict objectForKey:@"RequestType"] integerValue];//请求类型
        
        [self.adapterMappingList addObject:model];
    }
}


#pragma mark-
#pragma mark post request

/* 异步发送数据请求
 参数：
 adapterType: 获取数据的网络接口类型
 requestDTO: 网络接口需要的参数列表，若没有为nil
 requestHelper: request base model helper
 compBlock: 获取数据完成后需要执行的操作
 
 返回值：
 task: 请求task
 */
-(void)requestByType:(int)adapterType andObject:(RequestDTO*)requestDTO requestHelper:(__weak NetRequestHelper*)requestHelper onCompletion:(Bool_Block)compBlock
{
    //网络状态
    AFNetworkReachabilityStatus curNetStatus = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    //网络不可用
    if (curNetStatus == AFNetworkReachabilityStatusNotReachable)
    {
        //回调block中有些地方展示错误信息 有些页面不会 （不展示的如 我的处方刷新请求）
        [GHUDAlertUtils toggleMessage:MultiLanguage(netConnectErr)];

        //创建假的response 用于架构内传输错误状态值
        NSHTTPURLResponse *puppetResponse = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:999 HTTPVersion:nil headerFields:nil];
        NSError *error = [NSError errorWithDomain:@"netContentFailed" code:10 userInfo:[NSDictionary dictionaryWithObject:puppetResponse forKey:AFNetworkingOperationFailingURLResponseErrorKey]];
        [requestHelper requestFailed:error];
        if (compBlock) {
            compBlock(NO);
        }
        return;
    }

    
    //adapterType 索引index
    if (adapterType < 0 ) {//|| adapterType >= self.adapterMappingList.count
        if (compBlock) {
            compBlock(NO);
        }
        return;
    }
    
    NetMappingModel *adapter = [self.adapterMappingList objectAtIndex:adapterType];
    requestHelper.responseDTO = adapter.responseDTO;
    switch (adapter.requestType) {
        case 0: { // 常规的请求
            [self post:adapter andObject:requestDTO requestHelper:requestHelper onCompletion:compBlock];
        }
            break;
        case 1: { // 有附带信息的请求
            [self postWithFormData:adapter andObject:requestDTO requestHelper:requestHelper onCompletion:compBlock];
        }
            break;
        case 2: { // 上传文件请求
            [self uploadFile2:adapter andObject:requestDTO requestHelper:requestHelper onCompletion:compBlock];
        }
            break;
        case 3: { // 返回XML格式的请求
            [self postForXML:adapter andObject:requestDTO requestHelper:requestHelper onCompletion:compBlock];
        }
            break;
        default:
            break;
    }
}

/* 常规post请求
 参数：
 adapter: 接口信息对象
 requestDTO: 网络接口需要的参数列表，若没有为nil
 requestHelper: request base model helper
 compBlock: 获取数据完成后需要执行的操作
 
 返回值：
 task: 请求task
 */
- (NSURLSessionDataTask*)post:(NetMappingModel*)adapter andObject:(RequestDTO*)requestDTO requestHelper:(__weak NetRequestHelper*)requestHelper onCompletion:(Bool_Block)compBlock
{
    NSURLSessionDataTask *task = [self POST:adapter.pathPattern parameters:[requestDTO paramter] success:^(NSURLSessionDataTask *task, id responseObject) {
        ZXLog(@"NetHttpClient:requestByType succeed: %@", responseObject);
        compBlock([requestHelper requestSucceed:responseObject]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ZXLog(@"NetHttpClient:requestByType failed: %@", error);
        //网络超时处理
        if (error.code == kCFURLErrorTimedOut)
        {
            [GHUDAlertUtils toggleMessage:MultiLanguage(netConnectTimeOut)];
            
            NSHTTPURLResponse *puppetResponse = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:998 HTTPVersion:nil headerFields:nil];
            NSError *err = [NSError errorWithDomain:@"netConnectTimeOut" code:error.code userInfo:[NSDictionary dictionaryWithObject:puppetResponse forKey:AFNetworkingOperationFailingURLResponseErrorKey]];
            [requestHelper requestFailed:err];
        }
        else
        {
            [requestHelper requestFailed:error];
        }
        compBlock(NO);
        
    }];
    requestHelper.task = task;
    
    return task;
}

/* 带formData信息的post请求
 参数：
 adapter: 接口信息对象
 requestDTO: 网络接口需要的参数列表，若没有为nil
 requestHelper: request base model helper
 compBlock: 获取数据完成后需要执行的操作
 
 返回值：
 task: 请求task
 */
- (NSURLSessionDataTask*)postWithFormData:(NetMappingModel*)adapter andObject:(RequestDTO*)requestDTO requestHelper:(__weak NetRequestHelper*)requestHelper onCompletion:(Bool_Block)compBlock
{
    NSURLSessionDataTask *task = [self POST:adapter.pathPattern parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        formData = [requestDTO formData:formData];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        ZXLog(@"NetHttpClient:requestByTypeWithImages succeed: %@", responseObject);
        [requestHelper requestSucceed:responseObject];
        if (compBlock) {
            compBlock(YES);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ZXLog(@"NetHttpClient:requestByTypeWithImages failed: %@", error);
        [requestHelper requestFailed:error];
        if (compBlock) {
            compBlock(NO);
        }
    }];
    requestHelper.task = task;
    
    return task;
}

/* 上传文件请求：此接口没有限制同时上传使用的线程数
 参数：
 adapter: 接口信息对象
 requestDTO: 网络接口需要的参数列表，若没有为nil
 requestHelper: request base model helper
 compBlock: 获取数据完成后需要执行的操作
 
 返回值：
 task: 请求task
 */
- (NSURLSessionDataTask*)uploadFile:(NetMappingModel*)adapter andObject:(RequestDTO*)requestDTO  requestHelper:(__weak NetRequestHelper*)requestHelper onCompletion:(Bool_Block)compBlock
{
    NSString *url = [[NSURL URLWithString:adapter.pathPattern relativeToURL:self.baseURL] absoluteString];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    NSURLSessionUploadTask *uploadTask = [self uploadTaskWithRequest:request fromData:[requestDTO formData:nil]  progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            ZXLog(@"NetHttpClient:uploadFile failed: %@", error);
            [requestHelper requestFailed:error];
            if (compBlock) {
                compBlock(NO);
            }
        } else {
            ZXLog(@"NetHttpClient:uploadFile succeed: %@", responseObject);
            [requestHelper requestSucceed:responseObject];
            if (compBlock) {
                compBlock(YES);
            }
        }
    }];
    [uploadTask resume];
    requestHelper.task = uploadTask;
    
    return uploadTask;
}

/* 上传文件请求2：此接口限制了同时上传使用的线程数
 参数：
 adapter: 接口信息对象
 requestDTO: 网络接口需要的参数列表，若没有为nil
 requestHelper: request base model helper
 compBlock: 获取数据完成后需要执行的操作
 
 返回值：
 task: 请求task
 */
- (NSURLSessionDataTask*)uploadFile2:(NetMappingModel*)adapter andObject:(RequestDTO*)requestDTO  requestHelper:(__weak NetRequestHelper*)requestHelper onCompletion:(Bool_Block)compBlock
{
    NSURLSessionUploadTask *uploadTask = [self.netUploader upload:adapter.pathPattern fromData:[requestDTO formData:nil] progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        ZXLog(@"uploadTask finish");
        if (error) {
            ZXLog(@"NetHttpClient:uploadFile failed: %@", error);
            [requestHelper requestFailed:error];
            if (compBlock) {
                compBlock(NO);
            }
        } else {
            ZXLog(@"NetHttpClient:uploadFile succeed: %@", responseObject);
            [requestHelper requestSucceed:responseObject];
            if (compBlock) {
                compBlock(YES);
            }
        }
    }];
    requestHelper.task = uploadTask;
    
    return uploadTask;
    
}

/* 扫描药品码后，请求获取药品信息
 参数：
 adapter: 接口信息对象
 requestDTO: 网络接口需要的参数列表，若没有为nil
 requestHelper: request base model helper
 compBlock: 获取数据完成后需要执行的操作
 
 返回值：
 task: 请求task
 */
- (NSURLSessionDataTask*)postForXML:(NetMappingModel*)adapter andObject:(RequestDTO*)requestDTO requestHelper:(__weak NetRequestHelper*)requestHelper onCompletion:(Bool_Block)compBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];

   
    NSString *url = [NSString stringWithFormat:@""];
    NSURLSessionDataTask *task = [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, NSXMLParser *responseObject) {
        MMXMLReader *reader = [[MMXMLReader alloc] initWithXMLParser:responseObject];
        NSMutableDictionary *infoDict = [reader convertToDictionary];
        ZXLog(@"NetHttpClient:postForXML succeed: %@", infoDict);
        
        infoDict = infoDict[@"info"];
        if (nil != infoDict) {
            [infoDict setObject:infoDict[@"retcode"] forKey:@"retCode"];
            [infoDict setObject:@"" forKey:@"retMessage"];
        }
        compBlock([requestHelper requestSucceed:infoDict]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ZXLog(@"NetHttpClient:postForXML failed: %@", error);
        [requestHelper requestFailed:error];
        compBlock(NO);
    }];
    requestHelper.task = task;
    
    return task;
}

#pragma mark-
#pragma mark Cancel request

/* 取消请求
 * task：请求的标志
 */
- (void)cancelTask:(NSURLSessionDataTask*)task
{
    [task cancel];
}


#pragma mark-
#pragma mark Cookies

/* 删除cookies
 */
- (void)deleteCookies
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:SERVER_BASE_URL]];
    for (NSHTTPCookie *cookie in cookies)
    {
        [cookieStorage deleteCookie:cookie];
    }
}

@end
