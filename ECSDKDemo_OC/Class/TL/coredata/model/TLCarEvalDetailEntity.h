//
//  TLCarEvalDetailEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TLImageEntity;

@interface TLCarEvalDetailEntity : NSManagedObject

@property (nonatomic, retain) NSString * carEvaId;
@property (nonatomic, retain) NSString * carType;
@property (nonatomic, retain) NSString * oilCost;
@property (nonatomic, retain) NSString * publishTime;
@property (nonatomic, retain) NSString * editor;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * carEvalDesc;
@property (nonatomic, retain) NSSet *images;
@end

@interface TLCarEvalDetailEntity (CoreDataGeneratedAccessors)

- (void)addImagesObject:(TLImageEntity *)value;
- (void)removeImagesObject:(TLImageEntity *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
