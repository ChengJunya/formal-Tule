//
//  TLAuthorityRequestDTO.m
//  TL
//
//  Created by Rainbow on 4/27/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLAuthorityRequestDTO.h"

@implementation TLAuthorityRequestDTO
- (id)formData:(id<AFMultipartFormData>)formData
{
    
   
    
    for (UIImage *image in self.authImage) {
        NSData *data = UIImagePNGRepresentation(image);
        NSString *name = [NSString stringWithFormat:@"image%.0f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *fileName = [name stringByAppendingString:@".png"];
        [formData appendPartWithFileData:data name:@"authImage" fileName:fileName mimeType:@"multipart/form-data"];
    }
    if (self.authImage.count==0) {
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"authImage" fileName:@"authImage" mimeType:@"multipart/form-data"];
    }
    
    
    
    return formData;
}

@end
