//
//  TLCarEvalutionEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TLCarEvalutionEntity : NSManagedObject

@property (nonatomic, retain) NSString * carEvaId;
@property (nonatomic, retain) NSString * carType;
@property (nonatomic, retain) NSString * oilCost;
@property (nonatomic, retain) NSString * evalText;
@property (nonatomic, retain) NSString * editor;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * carImageUrl;



@end
