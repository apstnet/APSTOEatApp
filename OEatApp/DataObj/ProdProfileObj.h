//
//  ProdProfileObj.h
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProdProfileObj : NSObject

@property (nonatomic) NSMutableString *ProdId;
@property (nonatomic) NSMutableString *Logo;
@property (nonatomic) NSMutableString *Name;
@property (nonatomic) NSMutableString *City;
@property (nonatomic) NSMutableString *District;
@property (nonatomic) NSMutableString *Address;
@property (nonatomic) NSMutableString *OpenTime;
@property (nonatomic) NSMutableString *Intro;
@property (nonatomic) NSMutableString *Type;
@property (nonatomic) NSMutableString *ProdBadgeOne;
@property (nonatomic) NSMutableString *ProdBadgeTwo;
@property (nonatomic) NSMutableString *ProdBadgeThree;
@property (nonatomic) NSMutableString *ProdBadgeFour;
@property (nonatomic) NSMutableString *ProdLike;
@property (nonatomic) NSMutableString *ProdPrice;

@property (nonatomic) NSMutableString *SupplierStr;
@property (nonatomic) NSMutableString *TrainingStr;
@property (nonatomic) NSMutableString *SanitaryStr;

- (void) initObj;

@end
