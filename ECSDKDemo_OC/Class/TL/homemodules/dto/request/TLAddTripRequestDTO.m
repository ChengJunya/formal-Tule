//
//  TLAddTripRequestDTO.m
//  TL
//
//  Created by Rainbow on 3/17/15.
//  Copyright (c) 2015 ronglian. All rights reserved.
//

#import "TLAddTripRequestDTO.h"

@implementation TLAddTripRequestDTO



- (id)formData:(id<AFMultipartFormData>)formData
{
    
    if (self.operateType.integerValue==3) {
        [formData appendPartWithFormData:[self.type dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
        [formData appendPartWithFormData:[self.operateType dataUsingEncoding:NSUTF8StringEncoding] name:@"operateType"];
        [formData appendPartWithFormData:[self.objId dataUsingEncoding:NSUTF8StringEncoding] name:@"objId"];
        
    }else{
        [formData appendPartWithFormData:[self.title dataUsingEncoding:NSUTF8StringEncoding] name:@"title"];
        [formData appendPartWithFormData:[self.cityId dataUsingEncoding:NSUTF8StringEncoding] name:@"cityId"];
        [formData appendPartWithFormData:[self.content dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
        [formData appendPartWithFormData:[self.isTop dataUsingEncoding:NSUTF8StringEncoding] name:@"isTop"];
        [formData appendPartWithFormData:[self.type dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
        [formData appendPartWithFormData:[self.operateType dataUsingEncoding:NSUTF8StringEncoding] name:@"operateType"];
        [formData appendPartWithFormData:[self.objId dataUsingEncoding:NSUTF8StringEncoding] name:@"objId"];
    }
    
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
