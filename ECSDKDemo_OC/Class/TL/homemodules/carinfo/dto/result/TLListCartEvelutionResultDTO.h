//
//  TLListCartEvelutionResultDTO.h
//  TL
//
//  Created by Rainbow on 3/29/15.
//  Copyright (c) 2015 MST. All rights reserved.
//

#import "JSONModel.h"
#import "TLCarEvalutionDTO.h"
@interface TLListCartEvelutionResultDTO : JSONModel
@property (nonatomic,copy) NSArray <TLCarEvalutionDTO> *data;
@end
