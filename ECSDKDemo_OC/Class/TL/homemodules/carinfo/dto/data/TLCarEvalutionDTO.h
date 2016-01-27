//
//  TLCarEvalutionDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@protocol TLCarEvalutionDTO

@end

@interface TLCarEvalutionDTO : JSONModel
@property (nonatomic,copy) NSString *carEvaId;
@property (nonatomic,copy) NSString *carType;
@property (nonatomic,copy) NSString *oilCost;
@property (nonatomic,copy) NSString *evalText;
@property (nonatomic,copy) NSString *editor;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *carImageUrl;
@end


/*


 {
 "carEvaId":10                                 --车评编号
 " carType":"别克英朗",               --车型
 "oilCost":"7.3/100km"            --油耗
 "evalText":""                           --评测文章（默认取前20个字）
 "editor":"admin"                     --编辑用户
 "createTime":"2014-01-02"    --咨询发布日期
 "carImageUrl":"http://www.test.com/a.jpg"   --新车图片
 
 }
*/