//
//  SupeReviewObj.h
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SupeReviewObj : NSObject

@property (nonatomic) NSMutableString *SMId;
@property (nonatomic) NSMutableString *Review;
@property (nonatomic) NSMutableString *Avatar;
@property (nonatomic) NSMutableString *Name;


- (void) initObj;

@end
