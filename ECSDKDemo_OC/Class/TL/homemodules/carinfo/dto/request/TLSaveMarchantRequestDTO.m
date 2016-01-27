//
//  TLSaveMarchantRequestDTO.m
//  TL
//
//  Created by YONGFU on 5/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLSaveMarchantRequestDTO.h"

@implementation TLSaveMarchantRequestDTO
- (id)formData:(id<AFMultipartFormData>)formData
{
   
    
    [formData appendPartWithFormData:[self.merchantName dataUsingEncoding:NSUTF8StringEncoding] name:@"merchantName"];
    [formData appendPartWithFormData:[self.merchantType dataUsingEncoding:NSUTF8StringEncoding] name:@"merchantType"];
    [formData appendPartWithFormData:[self.openTime dataUsingEncoding:NSUTF8StringEncoding] name:@"openTime"];
    [formData appendPartWithFormData:[self.address dataUsingEncoding:NSUTF8StringEncoding] name:@"address"];
    [formData appendPartWithFormData:[self.parking dataUsingEncoding:NSUTF8StringEncoding] name:@"parking"];
    [formData appendPartWithFormData:[self.merchantDesc dataUsingEncoding:NSUTF8StringEncoding] name:@"merchantDesc"];
    [formData appendPartWithFormData:[self.cityId dataUsingEncoding:NSUTF8StringEncoding] name:@"cityId"];
        [formData appendPartWithFormData:[self.phone dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
        [formData appendPartWithFormData:[self.longtitude dataUsingEncoding:NSUTF8StringEncoding] name:@"longtitude"];
        [formData appendPartWithFormData:[self.latitude dataUsingEncoding:NSUTF8StringEncoding] name:@"latitude"];
    
    
    for (UIImage *image in self.merchantImages) {
        NSData *data = UIImagePNGRepresentation(image);
        NSString *name = [NSString stringWithFormat:@"image%.0f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *fileName = [name stringByAppendingString:@".png"];
        [formData appendPartWithFileData:data name:@"merchantImages" fileName:fileName mimeType:@"multipart/form-data"];
    }
    if (self.merchantImages.count==0) {
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"merchantImages" fileName:@"merchantImages" mimeType:@"multipart/form-data"];
    }
    
    if (self.merchantIcon!=nil) {
        UIImage *image  = self.merchantIcon;
        NSData *data = UIImagePNGRepresentation(image);
        NSString *name = [NSString stringWithFormat:@"image%.0f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *fileName = [name stringByAppendingString:@".png"];
        [formData appendPartWithFileData:data name:@"merchantIcon" fileName:fileName mimeType:@"multipart/form-data"];
    }else{
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"merchantIcon" fileName:@"merchantIcon" mimeType:@"multipart/form-data"];
    }
    
    
    return formData;
}
@end
