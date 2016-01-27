//
//  TLUploadChatFileRequest.m
//  TL
//
//  Created by YONGFU on 6/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLUploadChatFileRequest.h"
#import "RUTiles.h"

@implementation TLUploadChatFileRequest
- (id)formData:(id<AFMultipartFormData>)formData
{
    
    NSString *currentTime = [RUtiles stringFromDateWithFormat:[NSDate new] format:@"yyyyMMddhhmmss"];
    NSString *fileName = [currentTime stringByAppendingString:@".txt"];

    
    if (self.chatFile!=nil) {
                [formData appendPartWithFileData:self.chatFile name:@"chatFile" fileName:fileName mimeType:@"multipart/form-data"];
    }else{
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"chatFile" fileName:fileName mimeType:@"multipart/form-data"];
    }
    
    
    return formData;
}
@end
