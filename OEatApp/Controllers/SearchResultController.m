//
//  SearchResultController.m
//  OEatApp
//
//  Created by apstnetmgr on 15/1/22.
//  Copyright (c) 2015年 APST. All rights reserved.
//

#import "SearchResultController.h"
#import "AccountManager.h"
#import "SearchRetObj.h"
#import "RestaurantDetailController.h"
#import "SupeDetailController.h"
#import "ProdDetailController.h"

@interface SearchResultController ()

@property (nonatomic) NSMutableArray *searchObjArray;
@property (nonatomic) NSMutableArray *allResults;
@property (nonatomic) NSMutableArray *visibleResults;

@property (nonatomic, strong) UISearchController *searchController;

@end

NSString *const APSTSearchBaseControllerCellId = @"searchResultsCell";

@implementation SearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *_titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 28)];
    
    
    self.allResults = [NSMutableArray array];
    _searchObjArray = [NSMutableArray array];
    switch (_searchType) {
        case 1:
            [_titleLbl setText:@"Restaurant Search"];
            break;
        case 2:
            [_titleLbl setText:@"Market Search"];
            break;
        case 3:
            [_titleLbl setText:@"Product Search"];
            break;
            
        default:
            break;
    }
    
    [_titleLbl setTextColor:[UIColor whiteColor]];
    _titleLbl.font = [UIFont fontWithName:@"HelveticaNeue Bold" size:20];
    _titleLbl.backgroundColor = [UIColor clearColor];
    [_titleLbl sizeToFit];
    self.navigationItem.titleView = _titleLbl;
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    self.navigationItem.backBarButtonItem = backBarButton;
    
    _visibleResults = [NSMutableArray arrayWithArray:_allResults];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    // Make sure the that the search bar is visible within the navigation bar.
    [self.searchController.searchBar sizeToFit];
    
    // Include the search controller's search bar within the table's header view.
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // -updateSearchResultsForSearchController: is called when the controller is being dismissed to allow those who are using the controller they are search as the results controller a chance to reset their state. No need to update anything if we're being dismissed.
    if (!searchController.active) {
        return;
    }
    
    self.filterString = searchController.searchBar.text;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self applyBarTintColorToTheNavigationBar];
    
    [self reqGetSearchName];
}

- (void)applyBarTintColorToTheNavigationBar
{
    UIColor *barTintColor = [UIColor colorWithHexString:@"#68bf60"];
    
    id navigationBarAppearance = self.navigationController.navigationBar;
    
    [navigationBarAppearance setBarTintColor:barTintColor];
    
}

- (void)showRestDetailVC:(NSString*)restId restname:(NSString*)restName
{
    UIStoryboard *_theStoryboard = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    RestaurantDetailController *_controller = [_theStoryboard instantiateViewControllerWithIdentifier:@"RestaurantDetailController"];
    if (!_controller.restId) {
        _controller.restId = [NSMutableString string];
    }
    [_controller.restId setString:restId];
    if (!_controller.restName) {
        _controller.restName = [NSMutableString string];
    }
    [_controller.restName setString:restName];
    
    [self.navigationController pushViewController:_controller animated:YES];
}

- (void)showSupeDetailVC:(NSString*)smId sname:(NSString*)supeName
{
    UIStoryboard *_theStoryboard = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    SupeDetailController *_controller = [_theStoryboard instantiateViewControllerWithIdentifier:@"SupeDetailController"];
    if (!_controller.smId) {
        _controller.smId = [NSMutableString string];
    }
    [_controller.smId setString:smId];
    
    if (!_controller.smName) {
        _controller.smName = [NSMutableString string];
    }
    [_controller.smName setString:supeName];
    
    [self.navigationController pushViewController:_controller animated:YES];
}

- (void)showProdDetailVC:(NSString*)prodId prodname:(NSString*)prodName
{
    UIStoryboard *_theStoryboard = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    ProdDetailController *_controller = [_theStoryboard instantiateViewControllerWithIdentifier:@"ProdDetailController"];
    if (!_controller.prodId) {
        _controller.prodId = [NSMutableString string];
    }
    [_controller.prodId setString:prodId];
    
    if (!_controller.prodName) {
        _controller.prodName = [NSMutableString string];
    }
    [_controller.prodName setString:prodName];
    
    [self.navigationController pushViewController:_controller animated:YES];
}

#pragma mark - Property Overrides

- (void)setFilterString:(NSString *)filterString {
    _filterString = filterString;
    NSString *_strObj;
    if (!filterString || filterString.length <= 0) {
        [_visibleResults removeAllObjects];
        for (int i = 0; i < [_allResults count]; i++) {
            _strObj = [_allResults[i] copy];
            [_visibleResults addObject:_strObj];
        }
    }
    else {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", filterString];
        NSArray *_array = [self.allResults filteredArrayUsingPredicate:filterPredicate];
        [_visibleResults removeAllObjects];
        for (int i = 0; i < [_array count]; i++) {
            _strObj = [_array[i] copy];
            [_visibleResults addObject:_strObj];
        }
    }
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _visibleResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:APSTSearchBaseControllerCellId forIndexPath:indexPath];
    
    cell.textLabel.text = _visibleResults[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row >= [_searchObjArray count]) {
        return;
    }
    SearchRetObj *_obj = _searchObjArray[indexPath.row];
    
    switch (_searchType) {
        case 1:
            [self showRestDetailVC:_obj.OwnId restname:_obj.Name];
            break;
        case 2:
            [self showSupeDetailVC:_obj.OwnId sname:_obj.Name];
            break;
        case 3:
            [self showProdDetailVC:_obj.OwnId prodname:_obj.Name];
            break;
        default:
            return;
    }
}

#pragma mark - server API
- (void) reqGetSearchName
{
    
    NSMutableString *URLPath;
    switch (_searchType) {
        case 1:
            URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getRestUrl]];
            break;
        case 2:
            URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getSupeUrl]];
            break;
        case 3:
            URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getProdUrl]];
            break;
        default:
            return;
    }
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    switch (_searchType) {
        case 1:
            [body appendData:[@"interface_code=restNamwList&" dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        case 2:
            [body appendData:[@"interface_code=supeNameList&" dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        case 3:
            [body appendData:[@"interface_code=prodNameList&" dataUsingEncoding:NSUTF8StringEncoding]];
            break;
        default:
            return;
    }
    
    
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"reqGetSearchName: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleReqRestList:jsonDict];
            }else{

            }
        }else{

        }
        
        
    }];
    
}

- (void) handleReqRestList:(NSDictionary*)dictData
{
    
    NSDictionary *_dataItem;
    NSArray *_items = [dictData objectForKey:@"item"];
    
    SearchRetObj *_obj;
    
    if (!_searchObjArray) {
        _searchObjArray = [NSMutableArray array];
    }
    [_searchObjArray removeAllObjects];
    if (!_allResults) {
        _allResults = [NSMutableArray array];
    }
    [_allResults removeAllObjects];
    
    NSUInteger _num = [_items count];
    if (_num < 1) {
        [self.tableView reloadData];
        return;
    }
    
    for (int i = 0; i < _num; i++) {
        _obj = [[SearchRetObj alloc] init];
        [_obj initObj];
        
        _dataItem = [_items objectAtIndex:i];
        _obj.typeId = _searchType;
        switch (_searchType) {
            case 1:
                _obj.OwnId = [_dataItem objectForKey:@"RestId"];
                break;
            case 2:
                _obj.OwnId = [_dataItem objectForKey:@"SMId"];
                break;
            case 3:
                _obj.OwnId = [_dataItem objectForKey:@"ProdId"];
                break;
            default:
                break;
        }
        _obj.Name = [_dataItem objectForKey:@"Name"];

        [_searchObjArray addObject:_obj];
        [_allResults addObject:_obj.Name];
        
    }
    NSString *_strObj;
    if ([_allResults count] > 0) {
        [_visibleResults removeAllObjects];
        for (int i = 0; i < [_allResults count]; i++) {
            _strObj = [_allResults[i] copy];
            [_visibleResults addObject:_strObj];
        }
    }
    
    
    [self.tableView reloadData];
    
}

@end
