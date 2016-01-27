//
//  TLCarServiceEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TLCarServiceEntity : NSManagedObject

@property (nonatomic, retain) NSString * serviceId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * rank;
@property (nonatomic, retain) NSString * serviceType;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * serviceImageUrl;

@end
