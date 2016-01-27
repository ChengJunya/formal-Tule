//
//  TLSaveGroupRequestDTO.m
//  TL
//
//  Created by Rainbow on 5/6/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLSaveGroupRequestDTO.h"

@implementation TLSaveGroupRequestDTO
- (id)formData:(id<AFMultipartFormData>)formData
{
    
   
    [formData appendPartWithFormData:[self.groupName dataUsingEncoding:NSUTF8StringEncoding] name:@"groupName"];
    [formData appendPartWithFormData:[self.provinceId dataUsingEncoding:NSUTF8StringEncoding] name:@"provinceId"];
    [formData appendPartWithFormData:[self.cityId dataUsingEncoding:NSUTF8StringEncoding] name:@"cityId"];
    [formData appendPartWithFormData:[self.groupDesc dataUsingEncoding:NSUTF8StringEncoding] name:@"groupDesc"];
    [formData appendPartWithFormData:[self.longtitude dataUsingEncoding:NSUTF8StringEncoding] name:@"longtitude"];
    [formData appendPartWithFormData:[self.latitude dataUsingEncoding:NSUTF8StringEncoding] name:@"latitude"];
    
    
    if (self.groupIcon!=nil) {
        NSData *data = UIImagePNGRepresentation(self.groupIcon);
        NSString *name = [NSString stringWithFormat:@"image%.0f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *fileName = [name stringByAppendingString:@".png"];
        [formData appendPartWithFileData:data name:@"groupIcon" fileName:fileName mimeType:@"multipart/form-data"];
    }else{
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"groupIcon" fileName:@"groupIcon" mimeType:@"multipart/form-data"];
    }
    
    return formData;
}

@end
