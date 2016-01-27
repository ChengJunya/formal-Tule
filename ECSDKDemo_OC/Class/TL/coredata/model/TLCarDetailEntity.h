//
//  TLCarDetailEntity.h
//  TL
//
//  Created by YONGFU on 5/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TLImageEntity;

@interface TLCarDetailEntity : NSManagedObject

@property (nonatomic, retain) NSString * carDesc;
@property (nonatomic, retain) NSString * carId;
@property (nonatomic, retain) NSString * carType;
@property (nonatomic, retain) NSString * editor;
@property (nonatomic, retain) NSString * publishTime;
@property (nonatomic, retain) NSString * carMaker;
@property (nonatomic, retain) NSString * carBrand;
@property (nonatomic, retain) NSString * seatCount;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * price_low;
@property (nonatomic, retain) NSString * engine_low;
@property (nonatomic, retain) NSString * gearBox_low;
@property (nonatomic, retain) NSString * oilCost_low;
@property (nonatomic, retain) NSString * drive_low;
@property (nonatomic, retain) NSString * oilType_low;
@property (nonatomic, retain) NSString * price_high;
@property (nonatomic, retain) NSString * engine_high;
@property (nonatomic, retain) NSString * gearBox_high;
@property (nonatomic, retain) NSString * oilCost_high;
@property (nonatomic, retain) NSString * drive_high;
@property (nonatomic, retain) NSString * oilType_high;
@property (nonatomic, retain) NSString * viewCount;
@property (nonatomic, retain) NSString * carEvalDesc;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSSet *images;
@end

@interface TLCarDetailEntity (CoreDataGeneratedAccessors)

- (void)addImagesObject:(TLImageEntity *)value;
- (void)removeImagesObject:(TLImageEntity *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
