//
//  SupeProfileObj.m
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import "SupeProfileObj.h"

@implementation SupeProfileObj

- (void) initObj
{
    
    _SMId = [NSMutableString string];
    _Logo = [NSMutableString string];
    _Name = [NSMutableString string];
    _City = [NSMutableString string];
    _District = [NSMutableString string];
    _Address = [NSMutableString string];
    _OpenTime = [NSMutableString string];
    _Intro = [NSMutableString string];
    _Type = [NSMutableString string];
    _SupeBadgeOne = [NSMutableString stringWithString:@"0"];
    _SupeBadgeTwo = [NSMutableString stringWithString:@"0"];
    _SupeBadgeThree = [NSMutableString stringWithString:@"0"];
    _SupeBadgeFour = [NSMutableString stringWithString:@"0"];
    _SupeLike = [NSMutableString string];
    _SupePrice = [NSMutableString string];
    
    _SupplierStr = [NSMutableString string];
    _TrainingStr = [NSMutableString string];
    _SanitaryStr = [NSMutableString string];
}

@end
