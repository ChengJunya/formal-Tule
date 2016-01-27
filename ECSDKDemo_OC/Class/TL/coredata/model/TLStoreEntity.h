//
//  TLStoreEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TLStoreEntity : NSManagedObject

@property (nonatomic, retain) NSString * merchantId;
@property (nonatomic, retain) NSString * merchantName;
@property (nonatomic, retain) NSString * rank;
@property (nonatomic, retain) NSString * merchantType;
@property (nonatomic, retain) NSString * editor;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * merchantImageUrl;
@property (nonatomic, retain) NSString * distance;

@end
