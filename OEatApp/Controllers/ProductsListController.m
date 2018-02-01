//
//  ProductsListController.m
//  OEatApp
//
//  Created by apstnetmgr on 15/1/23.
//  Copyright (c) 2015年 APST. All rights reserved.
//

#import "ProductsListController.h"
#import "AccountManager.h"
#import "ProdListObj.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProdDetailController.h"

@interface ProductsListController ()<MBProgressHUDDelegate,UIPopoverPresentationControllerDelegate>
{
    NSMutableArray *productListArray;
    NSMutableArray *prodNameArray;
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
    UISwitch *priceSw;
}

- (IBAction)safetyFilterAct:(id)sender;
- (IBAction)priceFilterAct:(id)sender;
- (IBAction)districtFilterAct:(id)sender;

@end

@implementation ProductsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *_titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 28)];
    [_titleLbl setText:@"Products"];
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
    
    [self initProdArray];
    
}

- (void)initProdArray
{
    if (!productListArray) {
        productListArray = [NSMutableArray array];
    }
    if (!prodNameArray) {
        prodNameArray = [NSMutableArray array];
    }
    if (!imageKeyArray) {
        imageKeyArray = [NSMutableArray array];
    }
}

- (void) clearOldData
{
    if (!productListArray) {
        productListArray = [NSMutableArray array];
    }
    [productListArray removeAllObjects];
    if (!prodNameArray) {
        prodNameArray = [NSMutableArray array];
    }
    [prodNameArray removeAllObjects];
    
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
    [self reqProductList];
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

- (void) switchChange:(UISwitch*)sender
{
    
    if (sender.isOn) {
        [priceLbl setText:@"by Low Price"];
        
    }else{
        [priceLbl setText:@"by How Price"];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger _ret = 0;
    NSInteger _num = [productListArray count];
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
    NSInteger _num = [productListArray count];
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
    static NSString *SearchPriceCell = @"SearchPriceCell";
    static NSString *SearchAreaCell = @"SearchAreaCell";
    static NSString *ProductListCell = @"ProductListCell";
    static NSString *BlankNoDataCell = @"BlankNoDataCell";
    
    UITableViewCell *cell;
    UILabel *_lbl;
    NSString *keyName;
    ProdListObj *_obj;
    UIImageView *_logoImv;
    UIImageView *_imv;
    NSString *_strTmp;
    
    NSInteger _num = [productListArray count];
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
                    cell = [tableView dequeueReusableCellWithIdentifier:SearchPriceCell];
                    if (!cell)
                    {
                        cell=[[[NSBundle mainBundle] loadNibNamed:@"SearchPriceCell" owner:nil options:nil] lastObject];
                    }
                    
                    priceLbl = (UILabel*)[cell viewWithTag:1];
                    [priceLbl setTextColor:[UIColor colorWithHexString:@"#68bf60"]];
                    
                    priceSw = (UISwitch*)[cell viewWithTag:2];
                    if (![priceSw respondsToSelector:@selector(switchChange:)]) {
                        [priceSw addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
                        priceSw.tintColor = [UIColor colorWithHexString:@"#5a9752"];
                    }
                    if (priceSw.isOn) {
                        [priceLbl setText:@"by Low Price"];
                        
                    }else{
                        [priceLbl setText:@"by How Price"];
                    }
//                    [self reqProdListWithPrice];
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
                cell = [tableView dequeueReusableCellWithIdentifier:ProductListCell];
                if (!cell)
                {
                    cell=[[[NSBundle mainBundle] loadNibNamed:@"ProductListCell" owner:nil options:nil] lastObject];
                }
                
                _obj = productListArray[indexPath.row];
                
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
                if ([_obj.ProdBadgeOne isEqualToString:@"1"]) {
                    [_imv setImage:[UIImage imageNamed:@"oil-icon1"]];
                }else{
                    [_imv setImage:[UIImage imageNamed:@"oil-none-icon1"]];
                }
                
                _imv = (UIImageView*)[cell viewWithTag:4];
                if ([_obj.ProdBadgeTwo isEqualToString:@"1"]) {
                    [_imv setImage:[UIImage imageNamed:@"meat-icon1"]];
                }else{
                    [_imv setImage:[UIImage imageNamed:@"meat-none-icon1"]];
                }
                
                _imv = (UIImageView*)[cell viewWithTag:5];
                if ([_obj.ProdBadgeThree isEqualToString:@"1"]) {
                    [_imv setImage:[UIImage imageNamed:@"water-icon1"]];
                }else{
                    [_imv setImage:[UIImage imageNamed:@"water-none-icon1"]];
                }
                
                _imv = (UIImageView*)[cell viewWithTag:6];
                if ([_obj.ProdBadgeFour isEqualToString:@"1"]) {
                    [_imv setImage:[UIImage imageNamed:@"veg-icon1"]];
                }else{
                    [_imv setImage:[UIImage imageNamed:@"veg-none-icon1"]];
                }
                
                _lbl = (UILabel*)[cell viewWithTag:8];
                _strTmp = [NSString stringWithFormat:@"%@",_obj.ProdLike];
                [_lbl setText:_strTmp];
                
                _lbl = (UILabel*)[cell viewWithTag:9];
                _strTmp = [NSString stringWithFormat:@"$%@ per item",_obj.ProdPrice];
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
    ProdListObj *_obj;
    if (indexPath.section==1) {
        _obj = [productListArray objectAtIndex:indexPath.row];
        [self showProdDetailVC:_obj.ProdId prodname:_obj.Name];
    }
    
    
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

- (void) reqProductList
{
    
    NSMutableString *URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getProdUrl]];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[@"interface_code=productList&" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [self clearOldData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"reqProductList: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleReqProdList:jsonDict];
            }
        }else{
            
        }
        
        
    }];
    
}

- (void) handleReqProdList:(NSDictionary*)dictData
{
    NSDictionary *_dataItem;
    NSArray *_items = [dictData objectForKey:@"item"];
    
    ProdListObj *_obj;
    NSMutableString *keyName;
    
    NSUInteger _num = [_items count];
    if (_num < 1) {
        [self.tableView reloadData];
        return;
    }
    
    for (int i = 0; i < _num; i++) {
        _obj = [[ProdListObj alloc] init];
        [_obj initObj];
        
        _dataItem = [_items objectAtIndex:i];
        _obj.ProdId = [_dataItem objectForKey:@"ProdId"];
        _obj.Logo = [_dataItem objectForKey:@"Logo"];
        _obj.Name = [_dataItem objectForKey:@"Name"];
        _obj.Type = [_dataItem objectForKey:@"Type"];
        
        _obj.ProdBadgeOne = [_dataItem objectForKey:@"ProdBadgeOne"];
        _obj.ProdBadgeTwo = [_dataItem objectForKey:@"ProdBadgeTwo"];
        _obj.ProdBadgeFour = [_dataItem objectForKey:@"ProdBadgeFour"];
        _obj.ProdBadgeFour = [_dataItem objectForKey:@"ProdBadgeFour"];
        _obj.ProdPrice = [_dataItem objectForKey:@"ProdPrice"];
        
        [productListArray addObject:_obj];
        keyName = [NSMutableString stringWithString:[[AccountManager theAccountManager] getLogoPreUrl]];
        [keyName appendString:_obj.Logo];
        [imageKeyArray addObject:keyName];
        
    }
    
    if ([imageKeyArray count] > 0) {
        [self updateCacheImages];
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
    
    [self reqProdListWithSafety];
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
    
    [self reqProdListWithCity:cityTf.text District:districtTf.text];
    
}

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController
{
    
}

// Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the
// dismissal of the view.
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    return YES;
}

// Called on the delegate when the user has taken action to dismiss the popover. This is not called when the popover is dimissed programatically.
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    
}

// -popoverPresentationController:willRepositionPopoverToRect:inView: is called on your delegate when the
// popover may require a different view or rectangle.
- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView **)view
{
    
}
//compare safety, price, district
- (void) reqProdListWithSafety
{
    NSMutableString *URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getProdUrl]];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[@"interface_code=searchProdBySafety&" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [self clearOldData];
    [self showLoadingHud];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"reqProdListWithSafety: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleReqProdList:jsonDict];
            }else{
                [self hideLoadingHud];
            }
        }else{
            [self hideLoadingHud];
        }
    }];
}

- (void) reqProdListWithPrice
{
    NSMutableString *URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getProdUrl]];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    if (priceSw.isOn) {
        //ASC
        [body appendData:[@"interface_code=searchProdByPriceASC&" dataUsingEncoding:NSUTF8StringEncoding]];
    }else{
        //DESC
        [body appendData:[@"interface_code=searchProdByPriceDESC&" dataUsingEncoding:NSUTF8StringEncoding]];
    }

    
    [request setHTTPBody:body];
    
    [self clearOldData];
    [self showLoadingHud];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"reqProdListWithPrice: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleReqProdList:jsonDict];
            }else{
                [self hideLoadingHud];
            }
        }else{
            [self hideLoadingHud];
        }
    }];
}

- (void) reqProdListWithCity:(NSString*)strCity District:(NSString*)strDist
{
    NSMutableString *URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getProdUrl]];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSString *_tmpStr;
    NSMutableData *body = [NSMutableData data];
    [body appendData:[@"interface_code=searchProdByDistrct&" dataUsingEncoding:NSUTF8StringEncoding]];
    
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
        NSLog(@"reqProdListWithCity: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleReqProdList:jsonDict];
            }else{
                [self hideLoadingHud];
            }
        }else{
            [self hideLoadingHud];
        }
    }];
}

@end
