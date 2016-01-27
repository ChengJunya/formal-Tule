//
//  TLAddBookNodeRequestDTO.m
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLAddBookNodeRequestDTO.h"

@implementation TLAddBookNodeRequestDTO
- (id)formData:(id<AFMultipartFormData>)formData
{
    
    
    [formData appendPartWithFormData:[self.travelId dataUsingEncoding:NSUTF8StringEncoding] name:@"travelId"];
    [formData appendPartWithFormData:[self.cityId dataUsingEncoding:NSUTF8StringEncoding] name:@"cityId"];
    [formData appendPartWithFormData:[self.content dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
    [formData appendPartWithFormData:[self.isTop dataUsingEncoding:NSUTF8StringEncoding] name:@"isTop"];
    [formData appendPartWithFormData:[self.operateType dataUsingEncoding:NSUTF8StringEncoding] name:@"operateType"];
    [formData appendPartWithFormData:[self.objId dataUsingEncoding:NSUTF8StringEncoding] name:@"objId"];
    
    for (UIImage *image in self.userImage) {
        NSData *data = UIImagePNGRepresentation(image);
        NSString *name = [NSString stringWithFormat:@"image%.0f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *fileName = [name stringByAppendingString:@".png"];
        [formData appendPartWithFileData:data name:@"userImage" fileName:fileName mimeType:@"multipart/form-data"];
    }
    if (self.userImage.count==0) {
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"userImage" fileName:@"userImage" mimeType:@"multipart/form-data"];
    }
    
    
    return formData;
}
@end
