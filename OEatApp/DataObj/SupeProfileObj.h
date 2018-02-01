//
//  SupeProfileObj.h
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupeProfileObj : NSObject

@property (nonatomic) NSMutableString *SMId;
@property (nonatomic) NSMutableString *Logo;
@property (nonatomic) NSMutableString *Name;
@property (nonatomic) NSMutableString *City;
@property (nonatomic) NSMutableString *District;
@property (nonatomic) NSMutableString *Address;
@property (nonatomic) NSMutableString *OpenTime;
@property (nonatomic) NSMutableString *Intro;
@property (nonatomic) NSMutableString *Type;
@property (nonatomic) NSMutableString *SupeBadgeOne;
@property (nonatomic) NSMutableString *SupeBadgeTwo;
@property (nonatomic) NSMutableString *SupeBadgeThree;
@property (nonatomic) NSMutableString *SupeBadgeFour;
@property (nonatomic) NSMutableString *SupeLike;
@property (nonatomic) NSMutableString *SupePrice;

@property (nonatomic) NSMutableString *SupplierStr;
@property (nonatomic) NSMutableString *TrainingStr;
@property (nonatomic) NSMutableString *SanitaryStr;

- (void) initObj;

@end
