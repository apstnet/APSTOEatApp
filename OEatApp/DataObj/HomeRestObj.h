//
//  HomeRestObj.h
//  OEatSrvApp
//
//  Created by apstnetmgr on 14/12/12.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeRestObj : NSObject

@property (nonatomic) NSMutableString *RestId;
@property (nonatomic) NSMutableString *LogoPic;
@property (nonatomic) NSMutableString *CoverPic;
@property (nonatomic) NSMutableString *Name;
@property (nonatomic) NSMutableString *Highlight;

- (void) initObj;

@end
