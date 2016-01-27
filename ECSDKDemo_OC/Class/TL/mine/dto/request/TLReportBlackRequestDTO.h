//
//  TLReportBlackRequestDTO.h
//  TL
//
//  Created by YONGFU on 5/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLReportBlackRequestDTO : RequestDTO
@property (nonatomic,copy) NSString *blackUser;
@property (nonatomic,copy) NSArray *reportFiles;
@end

/**
 reportFiles
 文件数组
 是
 举报文件数组
 blackUser

*/