//
//  TLSecondGoodsEntity.h
//  TL
//
//  Created by Rainbow on 4/15/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TLSecondGoodsEntity : NSManagedObject

@property (nonatomic, retain) NSString * goodsId;
@property (nonatomic, retain) NSString * goodsName;
@property (nonatomic, retain) NSString * oldDesc;
@property (nonatomic, retain) NSString * goodsDesc;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * editor;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * goodsImageUrl;

@end
