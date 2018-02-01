//
//  ProdBadgeObj.h
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProdBadgeObj : NSObject

@property (nonatomic) NSMutableString *ProdId;
@property (nonatomic) NSMutableString *ProdBadgeOne;
@property (nonatomic) NSMutableString *ProdBadgeTwo;
@property (nonatomic) NSMutableString *ProdBadgeThree;
@property (nonatomic) NSMutableString *ProdBadgeFour;

- (void) initObj;

@end
