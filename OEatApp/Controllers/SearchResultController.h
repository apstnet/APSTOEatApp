//
//  SearchResultController.h
//  OEatApp
//
//  Created by apstnetmgr on 15/1/22.
//  Copyright (c) 2015年 APST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultController : UITableViewController<UISearchResultsUpdating>

@property (nonatomic, copy) NSString *filterString;

@property (nonatomic) NSInteger searchType; //1-Rest, 2-Supe, 3-Prod


@end
