//
//  InspectObj.h
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InspectObj : NSObject

@property (nonatomic) NSMutableString *InspId;
@property (nonatomic) NSMutableString *InspDesc;
@property (nonatomic) NSMutableString *Logo;
@property (nonatomic) NSMutableString *Name;

- (void) initObj;

@end
