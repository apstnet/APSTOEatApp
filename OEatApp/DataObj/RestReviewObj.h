//
//  RestReviewObj.h
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestReviewObj : NSObject

@property (nonatomic) NSMutableString *RestId;
@property (nonatomic) NSMutableString *Review;
@property (nonatomic) NSMutableString *Avatar;
@property (nonatomic) NSMutableString *Name;


- (void) initObj;

@end
