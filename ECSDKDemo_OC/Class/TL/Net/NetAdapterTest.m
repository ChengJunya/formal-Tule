//
//  NetAdapterTest.m
//  alijk
//
//  Created by easy on 14/7/25.
//  Copyright (c) 2014年 zhongxin. All rights reserved.
//

#import "NetAdapterTest.h"

@implementation NetAdapterTest

#pragma mark-
#pragma mark shareManager

static NetAdapterTest* _shareInstance = nil;

+(NetAdapterTest*)sharedManager
{
    if (nil != _shareInstance)
    {
        return _shareInstance;
    }
    
    @synchronized([NetAdapterTest class])
    {
        if (nil == _shareInstance)
        {
            _shareInstance = [[NetAdapterTest alloc] init];
        }
    }
    
    return _shareInstance;
}


#pragma mark-
#pragma mark init

-(id)init
{
    if (self = [super init])
    {
        //
    }
    
    return self;
}

-(void)dealloc
{
    //
}

-(void)runTest
{
//    [self runTestFunc:NetAdapter_User_Login];
//    [self runTestFunc:NetAdapter_Prescription_GetMyPrescription];
//    [self runTestFunc:NetAdapter_User_Register_GetUserKey];
//    [self runTestFunc:NetAdapter_Prescription_UploadPhoto];
//    [self runTestFunc:NetAdapter_Prescription_GetPhotoPresc];
//    [self runTestFunc:NetAdapter_Drug_CodeQuery];
//    [self runTestFunc:NetAdapter_User_Authentication_New_GetRegion];
//    [self runTestFunc:NetAdapter_Drug_GetHotWords];

}



@end
