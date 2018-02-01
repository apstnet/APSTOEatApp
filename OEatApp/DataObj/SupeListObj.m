//
//  SupeListObj.m
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import "SupeListObj.h"

@implementation SupeListObj

- (void) initObj
{
    
    _SMId = [NSMutableString string];
    _Logo = [NSMutableString string];
    _Name = [NSMutableString string];
    _Type = [NSMutableString string];
    _SupeBadgeOne = [NSMutableString stringWithString:@"0"];
    _SupeBadgeTwo = [NSMutableString stringWithString:@"0"];
    _SupeBadgeThree = [NSMutableString stringWithString:@"0"];
    _SupeBadgeFour = [NSMutableString stringWithString:@"0"];
    _SupeLike = [NSMutableString string];
    _SupePrice = [NSMutableString string];
}

@end
