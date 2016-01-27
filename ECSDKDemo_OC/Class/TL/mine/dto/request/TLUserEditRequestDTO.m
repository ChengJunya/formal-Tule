//
//  TLUserEditRequestDTO.m
//  TL
//
//  Created by Rainbow on 4/8/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "TLUserEditRequestDTO.h"

@implementation TLUserEditRequestDTO

- (id)formData:(id<AFMultipartFormData>)formData
{
    
    if (self.userName.length==0) {
        self.userName = @"";
    }
    
    if (self.gender.length==0) {
        self.gender = @"";
    }
    if (self.birthday.length==0) {
        self.birthday = @"";
    }
    if (self.profession.length==0) {
        self.profession = @"";
    }
    if (self.hobby.length==0) {
        self.hobby = @"";
    }
    if (self.signature.length==0) {
        self.signature = @"";
    }
    if (self.school.length==0) {
        self.school = @"";
    }
    if (self.job.length==0) {
        self.job = @"";
    }
    
    
    [formData appendPartWithFormData:[self.userName dataUsingEncoding:NSUTF8StringEncoding] name:@"userName"];
    [formData appendPartWithFormData:[self.gender dataUsingEncoding:NSUTF8StringEncoding] name:@"gender"];
    [formData appendPartWithFormData:[self.birthday dataUsingEncoding:NSUTF8StringEncoding] name:@"birthday"];
    [formData appendPartWithFormData:[self.profession dataUsingEncoding:NSUTF8StringEncoding] name:@"profession"];
    [formData appendPartWithFormData:[self.hobby dataUsingEncoding:NSUTF8StringEncoding] name:@"hobby"];
    [formData appendPartWithFormData:[self.signature dataUsingEncoding:NSUTF8StringEncoding] name:@"signature"];
    [formData appendPartWithFormData:[self.school dataUsingEncoding:NSUTF8StringEncoding] name:@"school"];
    [formData appendPartWithFormData:[self.job dataUsingEncoding:NSUTF8StringEncoding] name:@"job"];
    [formData appendPartWithFormData:[self.cityId dataUsingEncoding:NSUTF8StringEncoding] name:@"cityId"];
    
    for (UIImage *image in self.userImg) {
        NSData *data = UIImagePNGRepresentation(image);
        NSString *name = [NSString stringWithFormat:@"image%.0f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *fileName = [name stringByAppendingString:@".png"];
        [formData appendPartWithFileData:data name:@"userImg" fileName:fileName mimeType:@"multipart/form-data"];
    }
    if (self.userImg.count==0) {
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"userImg" fileName:@"userImg" mimeType:@"multipart/form-data"];
    }
    
    if (self.userIcon!=nil) {
        NSData *data = UIImagePNGRepresentation(self.userIcon);
        NSString *name = [NSString stringWithFormat:@"image%.0f", [NSDate timeIntervalSinceReferenceDate]];
        NSString *fileName = [name stringByAppendingString:@".png"];
        [formData appendPartWithFileData:data name:@"userIcon" fileName:fileName mimeType:@"multipart/form-data"];
    }else{
        [formData appendPartWithFileData:[[NSData alloc] init] name:@"userIcon" fileName:@"userIcon" mimeType:@"multipart/form-data"];
    }
   
    
    return formData;
}




@end
