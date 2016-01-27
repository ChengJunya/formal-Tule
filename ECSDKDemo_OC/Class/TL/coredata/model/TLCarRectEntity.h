//
//  TLCarRectEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TLCarRectEntity : NSManagedObject

@property (nonatomic, retain) NSString * rentId;
@property (nonatomic, retain) NSString * carType;
@property (nonatomic, retain) NSString * rentType;
@property (nonatomic, retain) NSString * driveDistance;
@property (nonatomic, retain) NSString * editor;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * carImageUrl;

@end
