//
//  RestProfileObj.h
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestProfileObj : NSObject

@property (nonatomic) NSMutableString *RestId;
@property (nonatomic) NSMutableString *Logo;
@property (nonatomic) NSMutableString *Name;
@property (nonatomic) NSMutableString *City;
@property (nonatomic) NSMutableString *District;
@property (nonatomic) NSMutableString *Address;
@property (nonatomic) NSMutableString *OpenTime;
@property (nonatomic) NSMutableString *Intro;
@property (nonatomic) NSMutableString *Type;
@property (nonatomic) NSMutableString *RestBadgeOne;
@property (nonatomic) NSMutableString *RestBadgeTwo;
@property (nonatomic) NSMutableString *RestBadgeThree;
@property (nonatomic) NSMutableString *RestBadgeFour;
@property (nonatomic) NSMutableString *RestLike;
@property (nonatomic) NSMutableString *RestPrice;

@property (nonatomic) NSMutableString *SupplierStr;
@property (nonatomic) NSMutableString *TrainingStr;
@property (nonatomic) NSMutableString *SanitaryStr;

- (void) initObj;

@end
