//
//  ProdListObj.h
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProdListObj : NSObject

@property (nonatomic) NSMutableString *ProdId;
@property (nonatomic) NSMutableString *Logo;
@property (nonatomic) NSMutableString *Name;
@property (nonatomic) NSMutableString *Type;
@property (nonatomic) NSMutableString *ProdBadgeOne;
@property (nonatomic) NSMutableString *ProdBadgeTwo;
@property (nonatomic) NSMutableString *ProdBadgeThree;
@property (nonatomic) NSMutableString *ProdBadgeFour;
@property (nonatomic) NSMutableString *ProdLike;
@property (nonatomic) NSMutableString *ProdPrice;


- (void) initObj;

@end
