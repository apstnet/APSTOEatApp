//
//  HomePageController.m
//  OEatApp
//
//  Created by apstnetmgr on 14/12/8.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import "HomePageController.h"

#import "AccountManager.h"
#import "RestaurantsListController.h"
#import "RestaurantDetailController.h"
#import "SupermarketListController.h"
#import "ProductsListController.h"
#import "QrScanController.h"
#import "HomeRestObj.h"
#import "SearchResultController.h"
#import "DetectiveController.h"

#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "AAPLCoolTransitioner.h"

@interface HomePageController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,UIActionSheetDelegate>


{
    NSMutableArray *homeRestArray;
    NSMutableArray *imageKeyArray;
    NSMutableArray *logoKeyArray;
    
    MBProgressHUD *HUD;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *topTableView;


- (void)restaurantAct:(id)sender;
- (void)superMarketAct:(id)sender;
- (void)productAct:(id)sender;
- (void)scanQrAct:(id)sender;


@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *backButtonBackgroundImage = [UIImage imageNamed:@"back-btn1"];
    // The background should be pinned to the left and not stretch.
    backButtonBackgroundImage = [backButtonBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonBackgroundImage.size.width - 1, 0, 0)];
    
    id appearance = [UIBarButtonItem appearanceWhenContainedIn:[CustomBackButtonNavController class], nil];
    [appearance setBackButtonBackgroundImage:backButtonBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:NULL];
    self.navigationItem.backBarButtonItem = backBarButton;
    
    if (!homeRestArray) {
        homeRestArray = [NSMutableArray array];
    }
    if (!imageKeyArray) {
        imageKeyArray = [NSMutableArray array];
    }
    if (!logoKeyArray) {
        logoKeyArray = [NSMutableArray array];
    }
    
//    _tableView.backgroundColor = [UIColor colorWithHexString:@"#68bf60"];
    _tableView.backgroundColor = [UIColor whiteColor];
    
//    _tableView.estimatedRowHeight = 44.0f;
//    _tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewWillAppear:(BOOL)animated
{

    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self reqHomeRestList];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void) clearOldData
{
    if (!homeRestArray) {
        homeRestArray = [NSMutableArray array];
    }
    [homeRestArray removeAllObjects];
    if (!imageKeyArray) {
        imageKeyArray = [NSMutableArray array];
        
    }
    [imageKeyArray removeAllObjects];
    if (!logoKeyArray) {
        logoKeyArray = [NSMutableArray array];
        
    }
    [logoKeyArray removeAllObjects];
}

- (void)showReqInfor:(NSString*)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:3];
}

- (void)showLoadingHud
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = NSLocalizedString(@"Loading Data...", @"数据加载中..." );
    
    [HUD show:YES];
}

- (void)hideLoadingHud
{
    [HUD hide:YES];
}
- (IBAction)SearchAct:(id)sender
{
    UIActionSheet *_sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString( @"Select Search Type",@"选择搜索类型")
                                              delegate:self
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString( @"Restaurant",@"餐馆"),
                                                        NSLocalizedString( @"Market",@"超市"),
                                                        NSLocalizedString( @"Product",@"产品"),
                                                        NSLocalizedString(@"Cancel",@"取消"),nil];
    _sheet.actionSheetStyle = UIActionSheetStyleDefault;
    _sheet.destructiveButtonIndex = 3;	// make the second button red (destructive)
    [_sheet showInView:self.view];
    
}

#pragma mark - actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self showSearchResultVC:1];
            
        }
            break;
        case 1:
        {
            [self showSearchResultVC:2];
        }
    
            break;
        case 2:
        {
            [self showSearchResultVC:3];
        }
            
            break;
        case 3:
            return;
    }

}

- (void) showSearchResultVC:(NSInteger)nType
{
    UIStoryboard *_theStoryboard = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
    SearchResultController *_controller = [_theStoryboard instantiateViewControllerWithIdentifier:@"SearchResultController"];
    
    _controller.searchType = nType;
    
    [self.navigationController pushViewController:_controller animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _topTableView) {
        return 2;
    }
    if (tableView == _tableView) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger _ret = 0;
    NSInteger _num = [homeRestArray count];
    if (tableView == _topTableView) {
        switch (section) {
            case 0:
            case 1:
                _ret = 1;
                break;
            default:
                break;
        }
    }
    if (tableView == _tableView) {
        switch (section) {
            case 0:
            {
                if (_num == 0) {
                    _ret = 1;
                }else{
                    _ret = _num;
                }
            }
                
            default:
                break;
        }
    }

    return _ret;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger _num = [homeRestArray count];
    CGFloat _ret = 0;
    if (tableView == _topTableView) {
        switch (indexPath.section) {
            case 0:
                _ret = 184;
                break;
            case 1:
                _ret = 90;
                break;
            default:
                break;
        }
    }
    if (tableView == _tableView) {
        switch (indexPath.section) {
            case 0:
            {
                if (_num == 0) {
                    _ret = 372;
                }else{
                    _ret = 199;
                }
            }
                
                break;
            default:
                break;
        }
    }
    
    return _ret;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *QRScanCell = @"QRScanCell";
    static NSString *ToolBarCell = @"ToolBarCell";
    static NSString *RestListCell = @"RestListCell";
    static NSString *BlankNoDataCell = @"BlankNoDataCell";
    
    UITableViewCell *cell;
    UIButton *_btn;
    UIImageView *_imv;
    NSString *keyName;
    UILabel *_lbl;
    
    NSInteger _num = [homeRestArray count];
    if (tableView == _topTableView) {
        switch (indexPath.section) {
            case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:QRScanCell];
                if (!cell)
                {
                    cell=[[[NSBundle mainBundle] loadNibNamed:@"QRScanCell" owner:nil options:nil] lastObject];
                }
                
                _btn = (UIButton*)[cell viewWithTag:1];
                if (![_btn respondsToSelector:@selector(scanQrAct:)]) {
                    [_btn addTarget:self action:@selector(scanQrAct:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                _btn = (UIButton*)[cell viewWithTag:2];
                if (![_btn respondsToSelector:@selector(SearchAct:)]) {
                    [_btn addTarget:self action:@selector(SearchAct:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                _btn = (UIButton*)[cell viewWithTag:4];
                if (![_btn respondsToSelector:@selector(detectiveAct:)]) {
                    [_btn addTarget:self action:@selector(detectiveAct:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                cell.backgroundColor = [UIColor colorWithHexString:@"#68bf60"];
                
                _lbl = (UILabel*)[cell viewWithTag:3];
                [_lbl setTextColor:[UIColor colorWithHexString:@"#5a9752"]];
                
                _lbl = (UILabel*)[cell viewWithTag:6];
                [_lbl setTextColor:[UIColor colorWithHexString:@"#5a9752"]];
            }
                
                break;
            case 1:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:ToolBarCell];
                if (!cell)
                {
                    cell=[[[NSBundle mainBundle] loadNibNamed:@"ToolBarCell" owner:nil options:nil] lastObject];
                }
                _btn = (UIButton*)[cell viewWithTag:1];
                if (![_btn respondsToSelector:@selector(restaurantAct:)]) {
                    [_btn addTarget:self action:@selector(restaurantAct:) forControlEvents:UIControlEventTouchUpInside];
                }
                _btn = (UIButton*)[cell viewWithTag:2];
                if (![_btn respondsToSelector:@selector(superMarketAct:)]) {
                    [_btn addTarget:self action:@selector(superMarketAct:) forControlEvents:UIControlEventTouchUpInside];
                }
                _btn = (UIButton*)[cell viewWithTag:3];
                if (![_btn respondsToSelector:@selector(productAct:)]) {
                    [_btn addTarget:self action:@selector(productAct:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                cell.backgroundColor = [[AccountManager theAccountManager] defaultFontColor];
            }
                
                break;
        }
    }
    HomeRestObj *_obj;
    if (tableView == _tableView) {
        switch (indexPath.section) {
            
            case 0:
            {
                if (_num == 0) {
                    cell = [tableView dequeueReusableCellWithIdentifier:BlankNoDataCell];
                    if (!cell)
                    {
                        cell=[[[NSBundle mainBundle] loadNibNamed:@"BlankNoDataCell" owner:nil options:nil] lastObject];
                    }
                }else{
                    cell = [tableView dequeueReusableCellWithIdentifier:RestListCell];
                    if (!cell)
                    {
                        cell=[[[NSBundle mainBundle] loadNibNamed:@"RestListCell" owner:nil options:nil] lastObject];
                    }
                    _imv = (UIImageView*)[cell viewWithTag:1];
                    if ([imageKeyArray count] < indexPath.row)
                        return cell;
                    
                    keyName = imageKeyArray[indexPath.row];
                    [[SDImageCache sharedImageCache] queryDiskCacheForKey:keyName done:^(UIImage *image, SDImageCacheType cacheType)
                     {
                         
                         if (image) {
                             [_imv setImage:image];
                         }else{
//                             UIImage *_tmpImg = [[UIImage alloc] init];
//                             [[SDImageCache sharedImageCache] storeImage:_tmpImg forKey:keyName];
                         }
                         
                     }];
                    
                    
                    _imv = (UIImageView*)[cell viewWithTag:2];
                    if ([logoKeyArray count] < indexPath.row)
                        return cell;
                    
                    keyName = logoKeyArray[indexPath.row];
                    [[SDImageCache sharedImageCache] queryDiskCacheForKey:keyName done:^(UIImage *image, SDImageCacheType cacheType)
                     {
                         
                         if (image) {
                             [_imv setImage:image];
                         }else{
                             [_imv setImage:[UIImage imageNamed:@"rest.png"]];
                         }
                         
                     }];
                    _obj = [homeRestArray objectAtIndex:indexPath.row];
                    _lbl = (UILabel*)[cell viewWithTag:4];
                    _lbl.numberOfLines = 0;
//                    [_lbl setText:@"New winter menu is here to bring warmth to your days."];
                    [_lbl setText:_obj.Highlight];
                }
            }
                
                
            break;
                
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([homeRestArray count] < 1) {
        return;
    }
    HomeRestObj *_restObj;
    if (tableView == _tableView) {
        _restObj = [homeRestArray objectAtIndex:indexPath.row];
        [self showRestDetailVC:_restObj.RestId restName:_restObj.Name];
    }
}

- (void)showRestaurantVC
{
    UIStoryboard *_theStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestaurantsListController *_controller = [_theStoryboard instantiateViewControllerWithIdentifier:@"RestaurantsListController"];
    
    [self.navigationController pushViewController:_controller animated:YES];
}

- (void)showRestDetailVC:(NSString*)restId restName:(NSString*)restname
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
    [_controller.restName setString:restname];
    
    [self.navigationController pushViewController:_controller animated:YES];
}

- (void)showSuperMarketVC
{
    UIStoryboard *_theStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SupermarketListController *_controller = [_theStoryboard instantiateViewControllerWithIdentifier:@"SupermarketListController"];
    
    [self.navigationController pushViewController:_controller animated:YES];
}

- (void)showProductVC
{
    UIStoryboard *_theStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProductsListController *_controller = [_theStoryboard instantiateViewControllerWithIdentifier:@"ProductsListController"];
    
    [self.navigationController pushViewController:_controller animated:YES];
}

- (void)showQrScanVC
{
    UIStoryboard *_theStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QrScanController *_controller = [_theStoryboard instantiateViewControllerWithIdentifier:@"QrScanController"];
    
    [self.navigationController pushViewController:_controller animated:YES];
}

- (void)showDetectiveVC
{
    DetectiveController *overlay = [[DetectiveController alloc] initWithNibName:@"DetectiveController" bundle:nil];
    
    _transitioningDelegate = [[AAPLCoolTransitioningDelegate alloc] init];
    
    [overlay setTransitioningDelegate:[self transitioningDelegate]];
    
    [self presentViewController:overlay animated:YES completion:NULL];
}

- (void)restaurantAct:(id)sender
{
    [self showRestaurantVC];
}

- (void)superMarketAct:(id)sender
{
    [self showSuperMarketVC];
}

- (void)productAct:(id)sender
{
    [self showProductVC];
}

- (void)scanQrAct:(id)sender
{
    [self showQrScanVC];
}

- (void)detectiveAct:(id)sender
{
    [self showDetectiveVC];
}

- (void) reqHomeRestList
{
    
    NSMutableString *URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getPublicUrl] ];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[@"interface_code=homeRestList&" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [self showLoadingHud];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"reqHomeRestList: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                
                [self handleReqHomeRestList:jsonDict];
            }else{
                [self hideLoadingHud];
            }
        }else{
            [self hideLoadingHud];
        }
        
        
    }];
}

- (void) handleReqHomeRestList:(NSDictionary*)dictData
{
    [self hideLoadingHud];
    
    NSDictionary *_dataItem;
    NSArray *_items = [dictData objectForKey:@"item"];
    NSMutableString *keyName;
    NSMutableString *logoKeyName;
    HomeRestObj *_obj;
    
    if (!homeRestArray) {
        homeRestArray = [NSMutableArray array];
    }
    [homeRestArray removeAllObjects];
    
    if (!imageKeyArray) {
        imageKeyArray = [NSMutableArray array];
        
    }
    [imageKeyArray removeAllObjects];
    
    if (!logoKeyArray) {
        logoKeyArray = [NSMutableArray array];
        
    }
    [logoKeyArray removeAllObjects];
    
    NSUInteger _num = [_items count];
    if (_num < 1) {
        [self.tableView reloadData];
        return;
    }
    
    for (int i = 0; i < _num; i++) {
        _obj = [[HomeRestObj alloc] init];
        [_obj initObj];
        
        _dataItem = [_items objectAtIndex:i];
        _obj.RestId = [_dataItem objectForKey:@"RestId"];
        _obj.CoverPic = [_dataItem objectForKey:@"CoverPic"];
        _obj.LogoPic = [_dataItem objectForKey:@"LogoPic"];
        _obj.Name = [_dataItem objectForKey:@"Name"];
        _obj.Highlight = [_dataItem objectForKey:@"Highlight"];
        
        [homeRestArray addObject:_obj];
        
        keyName = [NSMutableString stringWithString:[[AccountManager theAccountManager] getIp6PPreUrl]];
        [keyName appendString:_obj.CoverPic];
        [imageKeyArray addObject:keyName];
        
        logoKeyName = [NSMutableString stringWithString:[[AccountManager theAccountManager] getLogoPreUrl]];
        [logoKeyName appendString:_obj.LogoPic];
        [logoKeyArray addObject:logoKeyName];
    }
    if ([imageKeyArray count] > 0) {
        [self updateCacheImages];
    }else{
        [self.tableView reloadData];
    }
    
    
    [self.tableView reloadData];
}

//SDWebImage Cache Download
- (void)updateCacheImages
{
    NSString *cacheKey;
    NSUInteger keyNum;
    __block UIImageView *tmpImv;
    
    keyNum = [imageKeyArray count];
    for (int i = 0; i < keyNum; i++) {
        cacheKey = imageKeyArray[i];
        
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:cacheKey done:^(UIImage *image, SDImageCacheType cacheType)
         {
             
             if (image) {
                 
             }else{
                 tmpImv = [[UIImageView alloc] initWithFrame:CGRectZero];
                 [tmpImv sd_setImageWithURL:[NSURL URLWithString:cacheKey] placeholderImage:[UIImage imageNamed:@"no_image"]];
             }
             
         }];
        
        //        [tmpImv setImageWithURL:[NSURL URLWithString:cacheKey]];
    }
    keyNum = [logoKeyArray count];
    for (int i = 0; i < keyNum; i++) {
        cacheKey = logoKeyArray[i];
        
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:cacheKey done:^(UIImage *image, SDImageCacheType cacheType)
         {
             
             if (image) {
                 
             }else{
                 tmpImv = [[UIImageView alloc] initWithFrame:CGRectZero];
                 [tmpImv sd_setImageWithURL:[NSURL URLWithString:cacheKey] placeholderImage:[UIImage imageNamed:@"no_image"]];
             }
             
         }];
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

@end
