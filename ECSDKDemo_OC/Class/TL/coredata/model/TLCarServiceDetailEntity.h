//
//  TLCarServiceDetailEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TLImageEntity, TLTripUserEntity;

@interface TLCarServiceDetailEntity : NSManagedObject

@property (nonatomic, retain) NSString * serviceId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * viewCount;
@property (nonatomic, retain) NSString * commentCount;
@property (nonatomic, retain) NSString * serviceType;
@property (nonatomic, retain) NSString * rank;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * serviceDesc;
@property (nonatomic, retain) NSString * userPhone;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) TLTripUserEntity *user;
@end

@interface TLCarServiceDetailEntity (CoreDataGeneratedAccessors)

- (void)addImagesObject:(TLImageEntity *)value;
- (void)removeImagesObject:(TLImageEntity *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
