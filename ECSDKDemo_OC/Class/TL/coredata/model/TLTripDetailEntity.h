//
//  TLTripDetailEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TLImageEntity, TLTripTravelEntity, TLTripUserEntity;

@interface TLTripDetailEntity : NSManagedObject

@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * viewCount;
@property (nonatomic, retain) NSString * commentCount;
@property (nonatomic, retain) NSString * collectCount;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * cityId;
@property (nonatomic, retain) NSString * travelId;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) TLTripUserEntity *user;
@property (nonatomic, retain) NSSet *travel;
@end

@interface TLTripDetailEntity (CoreDataGeneratedAccessors)

- (void)addImagesObject:(TLImageEntity *)value;
- (void)removeImagesObject:(TLImageEntity *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addTravelObject:(TLTripTravelEntity *)value;
- (void)removeTravelObject:(TLTripTravelEntity *)value;
- (void)addTravel:(NSSet *)values;
- (void)removeTravel:(NSSet *)values;

@end
