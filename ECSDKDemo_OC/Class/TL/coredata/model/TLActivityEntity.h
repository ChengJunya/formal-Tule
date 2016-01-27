//
//  TLActivityEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TLActivityEntity : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * destnation;
@property (nonatomic, retain) NSString * costAverage;
@property (nonatomic, retain) NSString * personNum;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * viewCount;
@property (nonatomic, retain) NSString * commentCount;
@property (nonatomic, retain) NSString * activityImage;
@property (nonatomic, retain) NSString * activityId;
@property (nonatomic, retain) NSString * enrollCount;
@property (nonatomic, retain) NSString * publishTime;

@end
