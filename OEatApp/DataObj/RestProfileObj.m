//
//  RestProfileObj.m
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import "RestProfileObj.h"

@implementation RestProfileObj

- (void) initObj
{
    
    _RestId = [NSMutableString string];
    _Logo = [NSMutableString string];
    _Name = [NSMutableString string];
    _City = [NSMutableString string];
    _District = [NSMutableString string];
    _Address = [NSMutableString string];
    _OpenTime = [NSMutableString string];
    _Intro = [NSMutableString string];
    _Type = [NSMutableString string];
    
    _RestBadgeOne = [NSMutableString string];
    _RestBadgeTwo = [NSMutableString string];
    _RestBadgeThree = [NSMutableString string];
    _RestBadgeFour = [NSMutableString string];
    _RestLike = [NSMutableString string];
    _RestPrice = [NSMutableString string];

    _SupplierStr = [NSMutableString string];
    _TrainingStr = [NSMutableString string];
    _SanitaryStr = [NSMutableString string];
}

@end
