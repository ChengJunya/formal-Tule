//
//  TLSaveCarServiceRequest.m
//  TL
//
//  Created by Rainbow on 3/30/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLSaveCarServiceRequest.h"

@implementation TLSaveCarServiceRequest
- (id)formData:(id<AFMultipartFormData>)formData
{
    
    if (self.operateType.integerValue==3) {
        [formData appendPartWithFormData:[self.operateType dataUsingEncoding:NSUTF8StringEncoding] name:@"operateType"];
        [formData appendPartWithFormData:[self.objId dataUsingEncoding:NSUTF8StringEncoding] name:@"objId"];
    }else{
    
    [formData appendPartWithFormData:[self.title dataUsingEncoding:NSUTF8StringEncoding] name:@"title"];
    [formData appendPartWithFormData:[self.serviceType dataUsingEncoding:NSUTF8StringEncoding] name:@"serviceType"];
    [formData appendPartWithFormData:[self.address dataUsingEncoding:NSUTF8StringEncoding] name:@"address"];
    [formData appendPartWithFormData:[self.serviceDesc dataUsingEncoding:NSUTF8StringEncoding] name:@"serviceDesc"];
    [formData appendPartWithFormData:[self.isTop dataUsingEncoding:NSUTF8StringEncoding] name:@"isTop"];
    [formData appendPartWithFormData:[self.operateType dataUsingEncoding:NSUTF8StringEncoding] name:@"operateType"];
    [formData appendPartWithFormData:[self.objId dataUsingEncoding:NSUTF8StringEncoding] name:@"objId"];
        [formData appendPartWithFormData:[self.longtitude dataUsingEncoding:NSUTF8StringEncoding] name:@"longtitude"];
        [formData appendPartWithFormData:[self.latitude dataUsingEncoding:NSUTF8StringEncoding] name:@"latitude"];
    
    
    
    }
    
    for (UIImage *image in self.serviceImage) {
        NSData *data = UIImagePNGRepresentation(image);
        NSString *name = [NSString stringWithFormat:@"image%.0f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *fileName = [name stringByAppendingString:@".png"];
        [formData appendPartWithFileData:data name:@"serviceImage" fileName:fileName mimeType:@"multipart/form-data"];
    }
    if (self.serviceImage.count==0) {
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"serviceImage" fileName:@"carImage" mimeType:@"multipart/form-data"];
    }
    
    
    return formData;
}
@end
