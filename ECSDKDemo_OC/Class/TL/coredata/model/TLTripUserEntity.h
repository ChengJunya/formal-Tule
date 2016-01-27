//
//  TLTripUserEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TLTripUserEntity : NSManagedObject

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userIndex;
@property (nonatomic, retain) NSString * userIcon;
@property (nonatomic, retain) NSString * visitTime;
@property (nonatomic, retain) NSString * loginId;

@end
