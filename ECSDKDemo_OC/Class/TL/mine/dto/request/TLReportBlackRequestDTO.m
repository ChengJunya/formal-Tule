//
//  TLReportBlackRequestDTO.m
//  TL
//
//  Created by YONGFU on 5/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLReportBlackRequestDTO.h"

@implementation TLReportBlackRequestDTO
- (id)formData:(id<AFMultipartFormData>)formData
{
    
    
    [formData appendPartWithFormData:[self.blackUser dataUsingEncoding:NSUTF8StringEncoding] name:@"blackUser"];

    
    for (UIImage *image in self.reportFiles) {
        NSData *data = UIImagePNGRepresentation(image);
        NSString *name = [NSString stringWithFormat:@"image%.0f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *fileName = [name stringByAppendingString:@".png"];
        [formData appendPartWithFileData:data name:@"reportFiles" fileName:fileName mimeType:@"multipart/form-data"];
    }
    if (self.reportFiles.count==0) {
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"reportFiles" fileName:@"userImg" mimeType:@"multipart/form-data"];
    }
    
    return formData;
}
@end


