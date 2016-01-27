//
//  TLTripDataEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TLTripTravelEntity;

@interface TLTripDataEntity : NSManagedObject

@property (nonatomic, retain) NSString * travelId;
@property (nonatomic, retain) NSString * cityId;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * viewCount;
@property (nonatomic, retain) NSString * userIcon;
@property (nonatomic, retain) NSString * userPic;
@property (nonatomic, retain) NSSet *travel;
@property (nonatomic, retain) NSString *type;
@end

@interface TLTripDataEntity (CoreDataGeneratedAccessors)

- (void)addTravelObject:(TLTripTravelEntity *)value;
- (void)removeTravelObject:(TLTripTravelEntity *)value;
- (void)addTravel:(NSSet *)values;
- (void)removeTravel:(NSSet *)values;

@end
