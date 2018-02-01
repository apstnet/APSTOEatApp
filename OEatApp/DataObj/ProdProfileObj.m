//
//  ProdProfileObj.m
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import "ProdProfileObj.h"

@implementation ProdProfileObj

- (void) initObj
{
    
    _ProdId = [NSMutableString string];
    _Logo = [NSMutableString string];
    _Name = [NSMutableString string];
    _City = [NSMutableString string];
    _District = [NSMutableString string];
    _Address = [NSMutableString string];
    _OpenTime = [NSMutableString string];
    _Intro = [NSMutableString string];
    _Type = [NSMutableString string];
    _ProdBadgeOne = [NSMutableString stringWithString:@"0"];
    _ProdBadgeTwo = [NSMutableString stringWithString:@"0"];
    _ProdBadgeThree = [NSMutableString stringWithString:@"0"];
    _ProdBadgeFour = [NSMutableString stringWithString:@"0"];
    _ProdLike = [NSMutableString string];
    _ProdPrice = [NSMutableString string];
    
    _SupplierStr = [NSMutableString string];
    _TrainingStr = [NSMutableString string];
    _SanitaryStr = [NSMutableString string];
}

@end
