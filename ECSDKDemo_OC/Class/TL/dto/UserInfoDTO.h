//
//  UserInfoDTO.h
//  alijk
//
//  Created by easy on 14/7/28.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "JSONModel.h"


@interface UserInfoDTO : JSONModel

//@property (nonatomic, copy) NSString *name;  //用户姓名
//@property (nonatomic, copy) NSString *createDate;  //用户询价时间
//@property (nonatomic, copy) NSString *remain; //剩余时间
//@property (nonatomic, copy) NSString *distance;  //距离
//@property (nonatomic, copy) NSString *billNo;  //订单ID
//@property (nonatomic, copy) NSString *requestInfoId;  //申请药单报价请求ID
//@property (nonatomic, assign) NSInteger prescType;//  1;医院处方；2：照片处方
//@property (nonatomic, copy) NSString *serialNo;// 处方医嘱记录流水号   医院编码为 12个9 时根据次字段查询图片
//@property (nonatomic, copy) NSString *hospitalCode; //医院代码
//@property (nonatomic, copy) NSString *prescNo;//处方序号
//@property (nonatomic, copy) NSString *hosCodeAndserialNo;// 处方异常 医院编码+流水号 逗号分隔
//@property (nonatomic, copy) NSString *drugPrice; //药价
//@property (nonatomic, copy) NSString *expressPrice; //运费
//@property (nonatomic, copy) NSString *totalPrice; //总价
//@property (nonatomic, copy) NSString *sellerSendHour; //预计送达时间
//@property (nonatomic, assign) NSInteger sendFlag; //配送：0 不送      1 送
//@property (nonatomic, assign) NSInteger feedBackFlag; //0 没有上报处方异常  1已经上报处方异常
//

@property (nonatomic, copy) NSString *birthDay;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *hobbies;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *loginId;
@property (nonatomic, copy) NSString *loginPwd;
@property (nonatomic, copy) NSString *modifyTime;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *shortIndex;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *subAccount;
@property (nonatomic, copy) NSString *subToken;
@property (nonatomic,copy) NSNumber *tlb;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userIndex;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *vipLevel;
@property (nonatomic, copy) NSString *voipAccount;
@property (nonatomic, copy) NSString *voipToken;
@property (nonatomic, copy) NSString<Optional> *isAuth;
@property (nonatomic, copy) NSString<Optional> *isVip;//1 是 0 不是



@end
