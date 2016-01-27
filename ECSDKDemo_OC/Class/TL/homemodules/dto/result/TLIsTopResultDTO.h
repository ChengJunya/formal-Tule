//
//  TLIsTopResultDTO.h
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"

@interface TLIsTopResultDTO : JSONModel
@property (nonatomic,copy) NSString<Optional> *isTop;// isTop:"1"     -- 1:已经置顶    0:未置顶
@property (nonatomic,copy) NSString<Optional> *topEndTime;

@end
