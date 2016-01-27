//
//  TLActivityDetailEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TLImageEntity, TLTripUserEntity;

@interface TLActivityDetailEntity : NSManagedObject

@property (nonatomic, retain) NSString * activityId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * destnation;
@property (nonatomic, retain) NSString * costAverage;
@property (nonatomic, retain) NSString * personNum;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * viewCount;
@property (nonatomic, retain) NSString * commentCount;
@property (nonatomic, retain) NSString * collectCount;
@property (nonatomic, retain) NSString * enrollCount;
@property (nonatomic, retain) NSString * publishTime;
@property (nonatomic, retain) NSString * userPhone;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) TLTripUserEntity *user;
@property (nonatomic, retain) NSSet *enrollUsers;
@end

@interface TLActivityDetailEntity (CoreDataGeneratedAccessors)

- (void)addImagesObject:(TLImageEntity *)value;
- (void)removeImagesObject:(TLImageEntity *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addEnrollUsersObject:(TLTripUserEntity *)value;
- (void)removeEnrollUsersObject:(TLTripUserEntity *)value;
- (void)addEnrollUsers:(NSSet *)values;
- (void)removeEnrollUsers:(NSSet *)values;

@end
