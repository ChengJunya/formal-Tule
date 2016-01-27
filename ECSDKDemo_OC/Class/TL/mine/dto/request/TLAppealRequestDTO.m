//
//  TLAppealRequestDTO.m
//  TL
//
//  Created by Rainbow on 4/17/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLAppealRequestDTO.h"

@implementation TLAppealRequestDTO
- (id)formData:(id<AFMultipartFormData>)formData
{
    
    
    [formData appendPartWithFormData:[self.title dataUsingEncoding:NSUTF8StringEncoding] name:@"title"];
    [formData appendPartWithFormData:[self.phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
    [formData appendPartWithFormData:[self.email dataUsingEncoding:NSUTF8StringEncoding] name:@"email"];
    [formData appendPartWithFormData:[self.content dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
    
    
    for (UIImage *image in self.images) {
        NSData *data = UIImagePNGRepresentation(image);
        NSString *name = [NSString stringWithFormat:@"image%.0f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *fileName = [name stringByAppendingString:@".png"];
        [formData appendPartWithFileData:data name:@"images" fileName:fileName mimeType:@"multipart/form-data"];
    }
    if (self.images.count==0) {
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"images" fileName:@"images" mimeType:@"multipart/form-data"];
    }
    
    
    
    return formData;
}


@end
