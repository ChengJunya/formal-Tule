//
//  TLStoreDetailEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TLImageEntity;

@interface TLStoreDetailEntity : NSManagedObject

@property (nonatomic, retain) NSString * merchantId;
@property (nonatomic, retain) NSString * merchantName;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * viewCount;
@property (nonatomic, retain) NSString * commentCount;
@property (nonatomic, retain) NSString * rank;
@property (nonatomic, retain) NSString * openTime;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * park;
@property (nonatomic, retain) NSString * merchantDesc;
@property (nonatomic, retain) NSString * merchantIcon;
@property (nonatomic, retain) NSSet *images;
@end

@interface TLStoreDetailEntity (CoreDataGeneratedAccessors)

- (void)addImagesObject:(TLImageEntity *)value;
- (void)removeImagesObject:(TLImageEntity *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
