//
//  TLSaveCarRectRequestDTO.m
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLSaveCarRectRequestDTO.h"

@implementation TLSaveCarRectRequestDTO
- (id)formData:(id<AFMultipartFormData>)formData
{
    
 
    if (self.operateType.integerValue==3) {
        [formData appendPartWithFormData:[self.operateType dataUsingEncoding:NSUTF8StringEncoding] name:@"operateType"];
        [formData appendPartWithFormData:[self.objId dataUsingEncoding:NSUTF8StringEncoding] name:@"objId"];
    }else{
        
    
    
    [formData appendPartWithFormData:[self.title dataUsingEncoding:NSUTF8StringEncoding] name:@"title"];
    [formData appendPartWithFormData:[self.carType dataUsingEncoding:NSUTF8StringEncoding] name:@"carType"];
    [formData appendPartWithFormData:[self.rentType dataUsingEncoding:NSUTF8StringEncoding] name:@"rentType"];
    [formData appendPartWithFormData:[self.driveDistance dataUsingEncoding:NSUTF8StringEncoding] name:@"driveDistance"];
    [formData appendPartWithFormData:[self.address dataUsingEncoding:NSUTF8StringEncoding] name:@"address"];
        [formData appendPartWithFormData:[self.carDesc dataUsingEncoding:NSUTF8StringEncoding] name:@"carDesc"];
        [formData appendPartWithFormData:[self.isTop dataUsingEncoding:NSUTF8StringEncoding] name:@"isTop"];
    
    [formData appendPartWithFormData:[self.carAge dataUsingEncoding:NSUTF8StringEncoding] name:@"carAge"];
    [formData appendPartWithFormData:[self.price dataUsingEncoding:NSUTF8StringEncoding] name:@"price"];
    [formData appendPartWithFormData:[self.operateType dataUsingEncoding:NSUTF8StringEncoding] name:@"operateType"];
    [formData appendPartWithFormData:[self.objId dataUsingEncoding:NSUTF8StringEncoding] name:@"objId"];
    
            [formData appendPartWithFormData:[self.cityId dataUsingEncoding:NSUTF8StringEncoding] name:@"cityId"];
    
   
    }
    
    for (UIImage *image in self.carImage) {
        NSData *data = UIImagePNGRepresentation(image);
        NSString *name = [NSString stringWithFormat:@"image%.0f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *fileName = [name stringByAppendingString:@".png"];
        [formData appendPartWithFileData:data name:@"carImage" fileName:fileName mimeType:@"multipart/form-data"];
    }
    if (self.carImage.count==0) {
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"carImage" fileName:@"carImage" mimeType:@"multipart/form-data"];
    }
    
    
    return formData;
}
@end
