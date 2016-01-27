//
//  TLActivitySaveRequestDTO.m
//  TL
//
//  Created by Rainbow on 3/20/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLActivitySaveRequestDTO.h"

@implementation TLActivitySaveRequestDTO
- (id)formData:(id<AFMultipartFormData>)formData
{
    
    
    
    if (self.operateType.integerValue==3) {
        [formData appendPartWithFormData:[self.operateType dataUsingEncoding:NSUTF8StringEncoding] name:@"operateType"];
        [formData appendPartWithFormData:[self.objId dataUsingEncoding:NSUTF8StringEncoding] name:@"objId"];
    }else{
    
    [formData appendPartWithFormData:[self.title dataUsingEncoding:NSUTF8StringEncoding] name:@"title"];
    [formData appendPartWithFormData:[self.cityId dataUsingEncoding:NSUTF8StringEncoding] name:@"cityId"];
    [formData appendPartWithFormData:[self.costAverage dataUsingEncoding:NSUTF8StringEncoding] name:@"costAverage"];
        [formData appendPartWithFormData:[self.personNum dataUsingEncoding:NSUTF8StringEncoding] name:@"personNum"];
        [formData appendPartWithFormData:[self.desc dataUsingEncoding:NSUTF8StringEncoding] name:@"desc"];
        [formData appendPartWithFormData:[self.isTop dataUsingEncoding:NSUTF8StringEncoding] name:@"isTop"];
    
            [formData appendPartWithFormData:[self.startDate dataUsingEncoding:NSUTF8StringEncoding] name:@"startDate"];
            [formData appendPartWithFormData:[self.endDate dataUsingEncoding:NSUTF8StringEncoding] name:@"endDate"];
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
