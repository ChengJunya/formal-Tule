//
//  TLHomeHelper.h
//  TL
//
//  Created by Rainbow on 3/8/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperDataHelper.h"
@interface TLHomeHelper : SuperDataHelper


//单例define
ZX_DECLARE_SINGLETON(TLHomeHelper)

- (void)getHomeImageList:(NSString*)height width:(NSString*)width requestArr:(__weak NSMutableArray*)requestArr block:(DataHelper_Block)block;

@end
