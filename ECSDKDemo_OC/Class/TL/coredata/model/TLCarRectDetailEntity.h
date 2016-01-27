//
//  TLCarRectDetailEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TLImageEntity, TLTripUserEntity;

@interface TLCarRectDetailEntity : NSManagedObject

@property (nonatomic, retain) NSString * rentId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * viewCount;
@property (nonatomic, retain) NSString * commentCount;
@property (nonatomic, retain) NSString * carType;
@property (nonatomic, retain) NSString * driveDistance;
@property (nonatomic, retain) NSString * rentType;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * carDesc;
@property (nonatomic, retain) NSString * userPhone;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) TLTripUserEntity *user;
@end

@interface TLCarRectDetailEntity (CoreDataGeneratedAccessors)

- (void)addImagesObject:(TLImageEntity *)value;
- (void)removeImagesObject:(TLImageEntity *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
