//
//  TLUploadChatFileRequest.h
//  TL
//
//  Created by YONGFU on 6/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "BaseDTOModel.h"

@interface TLUploadChatFileRequest : RequestDTO
@property (nonatomic,copy) NSData *chatFile;
@end
