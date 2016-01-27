//
//  TLSaveSecondGoodsRequest.m
//  TL
//
//  Created by Rainbow on 3/31/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLSaveSecondGoodsRequest.h"

@implementation TLSaveSecondGoodsRequest
- (id)formData:(id<AFMultipartFormData>)formData
{
    
    
    if (self.operateType.integerValue==3) {
        [formData appendPartWithFormData:[self.operateType dataUsingEncoding:NSUTF8StringEncoding] name:@"operateType"];
        [formData appendPartWithFormData:[self.objId dataUsingEncoding:NSUTF8StringEncoding] name:@"objId"];
    }else{
        
        
    
    
    
    [formData appendPartWithFormData:[self.title dataUsingEncoding:NSUTF8StringEncoding] name:@"title"];
    [formData appendPartWithFormData:[self.goodsName dataUsingEncoding:NSUTF8StringEncoding] name:@"goodsName"];
    [formData appendPartWithFormData:[self.oldDesc dataUsingEncoding:NSUTF8StringEncoding] name:@"oldDesc"];
    [formData appendPartWithFormData:[self.price dataUsingEncoding:NSUTF8StringEncoding] name:@"price"];
    [formData appendPartWithFormData:[self.address dataUsingEncoding:NSUTF8StringEncoding] name:@"address"];
    [formData appendPartWithFormData:[self.goodsDesc dataUsingEncoding:NSUTF8StringEncoding] name:@"goodsDesc"];
    [formData appendPartWithFormData:[self.isTop dataUsingEncoding:NSUTF8StringEncoding] name:@"isTop"];
    
    [formData appendPartWithFormData:[self.operateType dataUsingEncoding:NSUTF8StringEncoding] name:@"operateType"];
    [formData appendPartWithFormData:[self.objId dataUsingEncoding:NSUTF8StringEncoding] name:@"objId"];
        [formData appendPartWithFormData:[self.goodsType dataUsingEncoding:NSUTF8StringEncoding] name:@"goodsType"];
    }

    for (UIImage *image in self.goodsImage) {
        NSData *data = UIImagePNGRepresentation(image);
        NSString *name = [NSString stringWithFormat:@"image%.0f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *fileName = [name stringByAppendingString:@".png"];
        [formData appendPartWithFileData:data name:@"goodsImage" fileName:fileName mimeType:@"multipart/form-data"];
    }
    if (self.goodsImage.count==0) {
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"goodsImage" fileName:@"goodsImage" mimeType:@"multipart/form-data"];
    }
    
    
    return formData;
}
@end
