//
//  TLListCarEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TLListCarEntity : NSManagedObject

@property (nonatomic, retain) NSString * carId;
@property (nonatomic, retain) NSString * carType;
@property (nonatomic, retain) NSString * priceRange;
@property (nonatomic, retain) NSString * publishTime;
@property (nonatomic, retain) NSString * editor;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * carImageUrl;

@end
