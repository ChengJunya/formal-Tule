//
//  TLTripTravelEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TLImageEntity;

@interface TLTripTravelEntity : NSManagedObject

@property (nonatomic, retain) NSString * lsNodeId;
@property (nonatomic, retain) NSString * travelId;
@property (nonatomic, retain) NSString * cityId;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * createUser;
@property (nonatomic, retain) NSString * modifyTime;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSSet *images;
@end

@interface TLTripTravelEntity (CoreDataGeneratedAccessors)

- (void)addImagesObject:(TLImageEntity *)value;
- (void)removeImagesObject:(TLImageEntity *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
