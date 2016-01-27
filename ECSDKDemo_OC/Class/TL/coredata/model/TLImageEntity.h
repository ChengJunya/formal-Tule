//
//  TLImageEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TLImageEntity : NSManagedObject

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * imageUrl;

@end
