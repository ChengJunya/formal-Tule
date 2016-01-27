//
//  TLUserViewResultDTO.h
//  TL
//
//  Created by Rainbow on 4/8/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLImageDTO.h"
#import "TLTripUserDTO.h"
#import "TLOrgDataDTO.h"
#import "TLGroupDataDTO.h"

@interface TLUserViewResultDTO : JSONModel
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *shortIndex;
@property (nonatomic,copy) NSString *birthDay;
@property (nonatomic,copy) NSString *provinceName;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString<Optional> *cityId;
@property (nonatomic,copy) NSString *profession;
@property (nonatomic,copy) NSString<Optional> *age;
@property (nonatomic,copy) NSString<Optional> *isFriend;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *vipLevel;
@property (nonatomic,copy) NSString *tlb;
@property (nonatomic,copy) NSString *loginId;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *subAccount;
@property (nonatomic,copy) NSString *subToken;
@property (nonatomic,copy) NSString *voipAccount;
@property (nonatomic,copy) NSString *voipToken;
@property (nonatomic,copy) NSString *phoneNum;
@property (nonatomic,copy) NSString *signature;
@property (nonatomic,copy) NSString *hobbies;
@property (nonatomic,copy) NSString *school;
@property (nonatomic,copy) NSString *job;
@property (nonatomic,copy) NSString *userIcon;
@property (nonatomic,copy) NSString<Optional> *vipEndTime;
@property (nonatomic,copy) NSString<Optional> *isAuth;
@property (nonatomic,copy) NSString<Optional> *grow;
@property (nonatomic,copy) NSArray<TLImageDTO> *userImages;
@property (nonatomic,copy) NSArray<TLTripUserDTO> *visitors;
@property (nonatomic,copy) NSArray<TLGroupDataDTO,Optional> *joinGroupInfo;
@property (nonatomic,copy) NSArray<TLOrgDataDTO,Optional> *orgInfo;
@property (nonatomic,copy) NSArray<TLGroupDataDTO,Optional> *createGroupInfo;

@end


/*


 "userName":"舒淇",          --姓名
 "shortIndex":"S",               --姓名首字母的缩写
 "birthDay": "1987-12-23",     --生日
 "provinceName":"北京",       --省份/直辖市
 "cityName":"通州",                 --地市/区县
 "profession":"演员",            --职业
 "gender":"0",       --"0":代表女 ，“1”:代表男
 "vipLevel":"1",    --vip等级
 "tlb":0, --途乐币
 "loginId":"2938347",       --登陆账号
 "createTime":"2013-01-01 00:00:00",     --创建时间
 "subAccount":"46ec477faa1511e48ad3ac853d9f54f2",        --子账户（文本聊天需要）
 "subToken":"b63229de3754f6df8132c22c29544856",          --子账户token（文本聊天需要）
 "voipAccount":"84760500000006",    --voip子账户账户（语音聊天需要）
 "voipToken":"zDhnS7Nq",                 --voip子账户账户Token（语音聊天需要）
 "   phoneNum":"18612701019",           --用户绑定的手机号码
 "signature":"把最美的留给大家，把最好的献给大家！",      --个人签名
 "hobbies":"看书,逛街,摄影,化妆",      --兴趣爱好
 "school":"内蒙古师范大学",           --毕业院校
 "job":"阿里",                                   --工作单位
 "userIcon":"    http://img1.cache.netease.com/catchpic/E/EF/EFFF24DDCAB29F4BC5AD83A58980B1B1.jpg",                                           --用户头像
 "userImages": [
 {"imageUrl":"   http://a1.att.hudong.com/950.jpg","imageName":"舒淇-玫瑰红"}
 ],                        --用户上传的图片
 "visitors": [
 {"userName":"途乐MAN","   loginId":"20151001","userIcon":"    http://hiphotos.baidu.com/aa.jpg"," visitTime":" 2015-04-08 01:37:40"}
 ]                                --访问者信息
 }


*/