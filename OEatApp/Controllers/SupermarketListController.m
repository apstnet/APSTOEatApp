//
//  SupermarketListController.m
//  OEatApp
//
//  Created by apstnetmgr on 15/1/23.
//  Copyright (c) 2015年 APST. All rights reserved.
//

#import "SupermarketListController.h"
#import "SupeDetailController.h"
#import "AccountManager.h"
#import "SupeListObj.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface SupermarketListController ()<MBProgressHUDDelegate>
{
    NSMutableArray *supeListArray;
    NSMutableArray *supeNameArray;
    NSMutableArray *imageKeyArray;
    MBProgressHUD *HUD;
    
    UIButton *safetyBtn;
    UIButton *priceBtn;
    UIButton *districtBtn;
    NSInteger filterId;
    
    UITextField *cityTf;
    UITextField *districtTf;
    UIButton *distrctSearchBtn;
    
    UILabel *priceLbl;
    UISegmentedControl *priceSG;
}

- (IBAction)safetyFilterAct:(id)sender;
- (IBAction)priceFilterAct:(id)sender;
- (IBAction)districtFilterAct:(id)sender;


@end

@implementation SupermarketListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *_titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 28)];
    [_titleLbl setText:@"Markets"];
    [_titleLbl setTextColor:[UIColor whiteColor]];
    _titleLbl.font = [UIFont fontWithName:@"HelveticaNeue Bold" size:20];
    _titleLbl.backgroundColor = [UIColor clearColor];
    [_titleLbl sizeToFit];
    self.navigationItem.titleView = _titleLbl;
    
    UIImage *backButtonBackgroundImage = [UIImage imageNamed:@"back-btn1"];
    // The background should be pinned to the left and not stretch.
    backButtonBackgroundImage = [backButtonBackgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonBackgroundImage.size.width - 1, 0, 0)];
    
    id appearance = [UIBarButtonItem appearanceWhenContainedIn:[CustomBackButtonNavController class], nil];
    [appearance setBackButtonBackgroundImage:backButtonBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:NULL];
    self.navigationItem.backBarButtonItem = backBarButton;
    
    [self initSupeArray];
}

- (void)initSupeArray
{
    if (!supeListArray) {
        supeListArray = [NSMutableArray array];
    }
    if (!supeNameArray) {
        supeNameArray = [NSMutableArray array];
    }
    if (!imageKeyArray) {
        imageKeyArray = [NSMutableArray array];
    }
}

- (void) clearOldData
{
    if (!supeListArray) {
        supeListArray = [NSMutableArray array];
    }
    [supeListArray removeAllObjects];
    if (!supeNameArray) {
        supeNameArray = [NSMutableArray array];
    }
    [supeNameArray removeAllObjects];
    
    if (!imageKeyArray) {
        imageKeyArray = [NSMutableArray array];
        
    }
    [imageKeyArray removeAllObjects];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] clearMemory];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self applyBarTintColorToTheNavigationBar];
    
    filterId = 0;
    [self reqSupermaketList];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
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

- (void)applyBarTintColorToTheNavigationBar
{
    UIColor *barTintColor = [UIColor colorWithHexString:@"#68bf60"];
    
    id navigationBarAppearance = self.navigationController.navigationBar;
    
    [navigationBarAppearance setBarTintColor:barTintColor];
    
}

- (void)priceSegmentAction:(id)sender
{
    UISegmentedControl *_control = (UISegmentedControl*)sender;
    NSUInteger _segId = [_control selectedSegmentIndex];
    switch (_segId) {
        case 0:
            [priceLbl setText:@"Low Price"];
        break;
        case 1:
        [priceLbl setText:@"Medium Price"];
        break;
        case 2:
        [priceLbl setText:@"High Price"];
        break;
        default:
        [priceLbl setText:@""];
        return;
    }
    [self reqSupeListWithPrice];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger _ret = 0;
    NSInteger _num = [supeListArray count];
    switch (section) {
        case 0:
            if (filterId==2 || filterId==3) {
                _ret = 2;
            }else{
                _ret = 1;
            }
            break;
        case 1:
        {
            if (_num == 0) {
                _ret = 1;
            }else{
                _ret = _num;
            }
        }
            break;
        default:
            break;
    }
    return _ret;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat _ret = 0;
    NSInteger _num = [supeListArray count];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                _ret = 44;
            }
            if (filterId==2) {
                if (indexPath.row==1) {
                    _ret = 44;
                }
            }
            if (filterId==3) {
                if (indexPath.row==1) {
                    _ret = 80;
                }
            }
        }
            break;
        case 1:
        {
            if (_num == 0) {
                _ret = 372;
            }else{
                _ret = 87;
            }
        }
            break;
            
        default:
            break;
    }
    return _ret;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FilterBtnCell = @"FilterBtnCell";
    static NSString *SearchPriceLevelCell = @"SearchPriceLevelCell";
    static NSString *SearchAreaCell = @"SearchAreaCell";
    static NSString *SupermarketListCell = @"SupermarketListCell";
    static NSString *BlankNoDataCell = @"BlankNoDataCell";
    
    UITableViewCell *cell;
    UILabel *_lbl;
    NSString *keyName;
    SupeListObj *_obj;
    UIImageView *_logoImv;
    UIImageView *_imv;
    NSString *_strTmp;
    NSInteger _num = [supeListArray count];
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                cell = [tableView dequeueReusableCellWithIdentifier:FilterBtnCell];
                if (!cell)
                {
                    cell=[[[NSBundle mainBundle] loadNibNamed:@"FilterBtnCell" owner:nil options:nil] lastObject];
                }
                
                safetyBtn = (UIButton*)[cell viewWithTag:1];
                if (![safetyBtn respondsToSelector:@selector(safetyFilterAct:)]) {
                    [safetyBtn addTarget:self action:@selector(safetyFilterAct:) forControlEvents:UIControlEventTouchUpInside];
                }
                if (filterId==1) {
                    [safetyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }else{
                    [safetyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                }
                
                priceBtn = (UIButton*)[cell viewWithTag:2];
                if (![priceBtn respondsToSelector:@selector(priceFilterAct:)]) {
                    [priceBtn addTarget:self action:@selector(priceFilterAct:) forControlEvents:UIControlEventTouchUpInside];
                }
                if (filterId==2) {
                    [priceBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }else{
                    [priceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                }
                
                districtBtn = (UIButton*)[cell viewWithTag:3];
                if (![districtBtn respondsToSelector:@selector(districtFilterAct:)]) {
                    [districtBtn addTarget:self action:@selector(districtFilterAct:) forControlEvents:UIControlEventTouchUpInside];
                }
                if (filterId==3) {
                    [districtBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }else{
                    [districtBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                }
            }
            if (filterId==2)
            {
                
                if (indexPath.row==1)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:SearchPriceLevelCell];
                    if (!cell)
                    {
                        cell=[[[NSBundle mainBundle] loadNibNamed:@"SearchPriceLevelCell" owner:nil options:nil] lastObject];
                    }
                    
                    priceLbl = (UILabel*)[cell viewWithTag:1];
                    [priceLbl setTextColor:[UIColor colorWithHexString:@"#68bf60"]];
                    
                    priceSG = (UISegmentedControl*)[cell viewWithTag:2];
                    if (![priceSG respondsToSelector:@selector(priceSegmentAction:)]) {
                        [priceSG addTarget:self action:@selector(priceSegmentAction:) forControlEvents:UIControlEventValueChanged];
                        priceSG.tintColor = [UIColor colorWithHexString:@"#5a9752"];
                    }
                    
                }
                
                
            }
            if (filterId==3)
            {
                
                if (indexPath.row==1)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:SearchAreaCell];
                    if (!cell)
                    {
                        cell=[[[NSBundle mainBundle] loadNibNamed:@"SearchAreaCell" owner:nil options:nil] lastObject];
                    }
                    
                    cityTf = (UITextField*)[cell viewWithTag:1];
                    districtTf = (UITextField*)[cell viewWithTag:2];
                    distrctSearchBtn = (UIButton*)[cell viewWithTag:3];
                    
                    if (![distrctSearchBtn respondsToSelector:@selector(districtSearchAct:)]) {
                        [distrctSearchBtn addTarget:self action:@selector(districtSearchAct:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                
                
            }
        }
            break;
            
        case 1:
        {
            
            if (_num == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:BlankNoDataCell];
                if (!cell)
                {
                    cell=[[[NSBundle mainBundle] loadNibNamed:@"BlankNoDataCell" owner:nil options:nil] lastObject];
                }
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:SupermarketListCell];
                if (!cell)
                {
                    cell=[[[NSBundle mainBundle] loadNibNamed:@"SupermarketListCell" owner:nil options:nil] lastObject];
                }
                
                _obj = supeListArray[indexPath.row];
                
                _logoImv = (UIImageView*)[cell viewWithTag:1];
                if ([imageKeyArray count] < indexPath.row)
                    return cell;
                
                keyName = imageKeyArray[indexPath.row];
                [[SDImageCache sharedImageCache] queryDiskCacheForKey:keyName done:^(UIImage *image, SDImageCacheType cacheType)
                 {
                     
                     if (image) {
                         [_logoImv setImage:image];
                     }else{
                         //                     [_imv setImage:[UIImage imageNamed:@"card.jpg"]];
                     }
                     
                 }];
                
                _lbl = (UILabel*)[cell viewWithTag:2];
                [_lbl setText:_obj.Name];
                
                _imv = (UIImageView*)[cell viewWithTag:3];
                if ([_obj.SupeBadgeOne isEqualToString:@"1"]) {
                    [_imv setImage:[UIImage imageNamed:@"oil-icon1"]];
                }else{
                    [_imv setImage:[UIImage imageNamed:@"oil-none-icon1"]];
                }
                
                _imv = (UIImageView*)[cell viewWithTag:4];
                if ([_obj.SupeBadgeTwo isEqualToString:@"1"]) {
                    [_imv setImage:[UIImage imageNamed:@"meat-icon1"]];
                }else{
                    [_imv setImage:[UIImage imageNamed:@"meat-none-icon1"]];
                }
                
                _imv = (UIImageView*)[cell viewWithTag:5];
                if ([_obj.SupeBadgeThree isEqualToString:@"1"]) {
                    [_imv setImage:[UIImage imageNamed:@"water-icon1"]];
                }else{
                    [_imv setImage:[UIImage imageNamed:@"water-none-icon1"]];
                }
                
                _imv = (UIImageView*)[cell viewWithTag:6];
                if ([_obj.SupeBadgeFour isEqualToString:@"1"]) {
                    [_imv setImage:[UIImage imageNamed:@"veg-icon1"]];
                }else{
                    [_imv setImage:[UIImage imageNamed:@"veg-none-icon1"]];
                }
                
                _lbl = (UILabel*)[cell viewWithTag:8];
                _strTmp = [NSString stringWithFormat:@"%@",_obj.SupeLike];
                [_lbl setText:_strTmp];
                
                _lbl = (UILabel*)[cell viewWithTag:9];
                _strTmp = [NSString stringWithFormat:@"Price Range: %@",_obj.SupePrice];
                [_lbl setText:_strTmp];
            }
        }
            
            
            break;
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([supeListArray count]<1) {
        return;
    }
    SupeListObj *_obj;
    if (indexPath.section==1) {
        _obj = [supeListArray objectAtIndex:indexPath.row];
        [self showSupeDetailVC:_obj.SMId sname:_obj.Name];
    }
    
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

- (void) reqSupermaketList
{
    
    NSMutableString *URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getSupeUrl]];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[@"interface_code=supermarketList&" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [self clearOldData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"reqSupermaketList: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleReqSupeList:jsonDict];
            }else{
                [self hideLoadingHud];
            }
        }else{
            [self hideLoadingHud];
        }
        
        
    }];
    
}

- (void) handleReqSupeList:(NSDictionary*)dictData
{
    [self hideLoadingHud];
    
    NSDictionary *_dataItem;
    NSArray *_items = [dictData objectForKey:@"item"];
    
    SupeListObj *_obj;
    NSMutableString *keyName;
    
    NSUInteger _num = [_items count];
    if (_num < 1) {
        [self.tableView reloadData];
        return;
    }
    
    for (int i = 0; i < _num; i++) {
        _obj = [[SupeListObj alloc] init];
        [_obj initObj];
        
        _dataItem = [_items objectAtIndex:i];
        _obj.SMId = [_dataItem objectForKey:@"SMId"];
        _obj.Logo = [_dataItem objectForKey:@"Logo"];
        _obj.Name = [_dataItem objectForKey:@"Name"];
        _obj.Type = [_dataItem objectForKey:@"Type"];
        _obj.SupeBadgeOne = [_dataItem objectForKey:@"SupeBadgeOne"];
        _obj.SupeBadgeTwo = [_dataItem objectForKey:@"SupeBadgeTwo"];
        _obj.SupeBadgeThree = [_dataItem objectForKey:@"SupeBadgeThree"];
        _obj.SupeBadgeFour = [_dataItem objectForKey:@"SupeBadgeFour"];
        _obj.SupeLike = [_dataItem objectForKey:@"SupeLike"];
        _obj.SupePrice = [_dataItem objectForKey:@"SupePrice"];
        
        [supeListArray addObject:_obj];
        keyName = [NSMutableString stringWithString:[[AccountManager theAccountManager] getLogoPreUrl]];
        [keyName appendString:_obj.Logo];
        [imageKeyArray addObject:keyName];
    }
    
    if ([imageKeyArray count] > 0) {
        [self updateCacheImages];
        [self.tableView reloadData];
    }else{
        [self.tableView reloadData];
    }
}

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
        
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)safetyFilterAct:(id)sender
{
    filterId = 1;
    
    [safetyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [priceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [districtBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self reqSupeListWithSafety];
}

- (IBAction)priceFilterAct:(id)sender
{
    filterId = 2;
    
    [safetyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [priceBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [districtBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}

- (IBAction)districtFilterAct:(id)sender
{
    filterId = 3;
    
    [safetyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [priceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [districtBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    
    [self.tableView reloadData];
}

- (IBAction)districtSearchAct:(id)sender
{
    [cityTf resignFirstResponder];
    [districtTf resignFirstResponder];
    
    if ([cityTf.text length] < 1) {
        [self showReqInfor:@"Need City Name"];
        return;
    }
    if ([districtTf.text length] < 1) {
        [self showReqInfor:@"Need District Name"];
        return;
    }
    
    [self reqSupeListWithCity:cityTf.text District:districtTf.text];
    
}

//compare safety, price, district
- (void) reqSupeListWithSafety
{
    NSMutableString *URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getSupeUrl]];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[@"interface_code=searchSupeBySafety&" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [self clearOldData];
    [self showLoadingHud];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"reqSupeListWithSafety: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleReqSupeList:jsonDict];
            }else{
                [self hideLoadingHud];
            }
        }else{
            [self hideLoadingHud];
        }
    }];
}

- (void) reqSupeListWithPrice
{
    NSMutableString *URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getSupeUrl]];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    switch (priceSG.selectedSegmentIndex) {
        case 0:
            [body appendData:[@"interface_code=searchSupeByPriceLow&" dataUsingEncoding:NSUTF8StringEncoding]];
        break;
        case 1:
        [body appendData:[@"interface_code=searchSupeByPriceMedium&" dataUsingEncoding:NSUTF8StringEncoding]];
        break;
        case 2:
        [body appendData:[@"interface_code=searchSupeByPriceHigh&" dataUsingEncoding:NSUTF8StringEncoding]];
        break;
        default:
            [body appendData:[@"interface_code=searchSupeByPriceLow&" dataUsingEncoding:NSUTF8StringEncoding]];
        break;
    }
    
    [request setHTTPBody:body];
    
    [self clearOldData];
    [self showLoadingHud];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"reqSupeListWithPrice: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleReqSupeList:jsonDict];
            }else{
                [self hideLoadingHud];
            }
        }else{
            [self hideLoadingHud];
        }
    }];
}

- (void) reqSupeListWithCity:(NSString*)strCity District:(NSString*)strDist
{
    NSMutableString *URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getSupeUrl]];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSString *_tmpStr;
    NSMutableData *body = [NSMutableData data];
    [body appendData:[@"interface_code=searchSupeByDistrct&" dataUsingEncoding:NSUTF8StringEncoding]];
    
    _tmpStr = [NSString stringWithFormat:@"City=%@&",strCity];
    [body  appendData: [_tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    _tmpStr = [NSString stringWithFormat:@"District=%@&",strDist];
    [body  appendData: [_tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [self clearOldData];
    [self showLoadingHud];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"reqSupeListWithCity: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleReqSupeList:jsonDict];
            }else{
                [self hideLoadingHud];
            }
        }else{
            [self hideLoadingHud];
        }
    }];
}


@end
