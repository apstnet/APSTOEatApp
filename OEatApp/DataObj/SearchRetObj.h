//
//  SearchRetObj.h
//  OEatApp
//
//  Created by apstnetmgr on 15/1/22.
//  Copyright (c) 2015年 APST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchRetObj : NSObject

@property (nonatomic) NSInteger typeId;
@property (nonatomic) NSMutableString *OwnId;
@property (nonatomic) NSMutableString *Name;


- (void) initObj;

@end
