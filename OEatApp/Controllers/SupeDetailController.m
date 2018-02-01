//
//  SupeDetailController.m
//  OEatApp
//
//  Created by apstnetmgr on 14/12/19.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import "SupeDetailController.h"
#import "SupeProfileObj.h"
#import "SupeReviewObj.h"
#import "AccountManager.h"
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SupplierObj.h"
#import "TrainObj.h"
#import "InspectObj.h"


@interface SupeDetailController ()<UITableViewDataSource,UITableViewDelegate>
{
    SupeProfileObj* supeProfileObj;
    
    BOOL bProfile;
    NSMutableString *imageKey;
    NSMutableData *SupplierData;
    NSMutableData *TrainingData;
    NSMutableData *SanitaryData;
    NSMutableArray *SupplierArray;
    NSMutableArray *SupplierLogoArray;
    NSMutableArray *TrainingArray;
    NSMutableArray *TrainingLogoArray;
    NSMutableArray *SanitaryArray;
    NSMutableArray *SanitaryLogoArray;
    
    NSMutableArray *ReviewArray;
    NSMutableArray *ReviewAvatarArray;
}


@property (weak, nonatomic) __block IBOutlet UIImageView *photoImv;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SupeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *_titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 28)];
    [_titleLbl setText:_smName];
    [_titleLbl setTextColor:[UIColor whiteColor]];
    _titleLbl.font = [UIFont fontWithName:@"HelveticaNeue Bold" size:20];
    _titleLbl.backgroundColor = [UIColor clearColor];
    [_titleLbl sizeToFit];
    self.navigationItem.titleView = _titleLbl;
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    self.navigationItem.backBarButtonItem = backBarButton;
    
    [self initDataObj];
}

- (void)initDataObj
{
    bProfile = NO;
    
    supeProfileObj = [[SupeProfileObj alloc] init];
    [supeProfileObj initObj];
    
    imageKey = [NSMutableString string];
    
    if (!SupplierArray) {
        SupplierArray = [NSMutableArray array];
    }
    if (!SupplierLogoArray) {
        SupplierLogoArray = [NSMutableArray array];
    }
    if (!TrainingArray) {
        TrainingArray = [NSMutableArray array];
    }
    if (!TrainingLogoArray) {
        TrainingLogoArray = [NSMutableArray array];
    }
    if (!SanitaryArray) {
        SanitaryArray = [NSMutableArray array];
    }
    if (!SanitaryLogoArray) {
        SanitaryLogoArray = [NSMutableArray array];
    }
    if (!ReviewArray) {
        ReviewArray = [NSMutableArray array];
    }
    if (!ReviewAvatarArray) {
        ReviewAvatarArray = [NSMutableArray array];
    }
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
    
    [self reqSupeProfile:_smId];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reqSupeReview:_smId];
    });
}

- (void)applyBarTintColorToTheNavigationBar
{
    UIColor *barTintColor = [UIColor colorWithHexString:@"#68bf60"];
    
    id navigationBarAppearance = self.navigationController.navigationBar;
    
    [navigationBarAppearance setBarTintColor:barTintColor];
    
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==4) {
        return [ReviewAvatarArray count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat _ret = 0;
    switch (indexPath.section) {
            //Intro
        case 0:
            if (bProfile) {
                _ret = 164;
            }else{
                _ret = 0;
            }
            break;
            //Supplier
        case 1:
        {
            if (bProfile) {
                if ([SupplierArray count] < 1) {
                    _ret = 0;
                }else{
                    _ret = 89;
                }
            }else{
                _ret = 0;
            }
        }
            break;
            //Training
        case 2:
        {
            if (bProfile) {
                if ([TrainingArray count] < 1) {
                    _ret = 0;
                }else{
                    _ret = 89;
                }
            }else{
                _ret = 0;
            }
        }
            break;
            //Inspect
        case 3:
        {
            if (bProfile) {
                if ([SanitaryArray count] < 1) {
                    _ret = 0;
                }else{
                    _ret = 89;
                }
                
            }else{
                _ret = 0;
            }
        }
            break;
        case 4:
        {
            if (bProfile) {
                if ([ReviewArray count] < 1) {
                    _ret = 0;
                }else{
                    _ret = 60;
                }
            }else{
                _ret = 0;
            }
        }
            break;
        default:
            break;
    }
    return _ret;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat _ret = 0;
    switch (section) {
            //Intro Cell
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
            _ret = 36;
            break;
        default:
            break;
    }
    
    return _ret;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    UIImageView *imageView;
    UILabel *label;
    
    if (!bProfile) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        return headerView;
    }
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 36)];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 0, 26, 26)];
    
    switch (section) {
            //Intro
        case 0:
            label = [[UILabel alloc] initWithFrame:CGRectMake(2, 5, 0, 28)];
            if (bProfile) {
                label.text = supeProfileObj.Name;
            }else{
                label.text = @"Loading...";
            }
            
            break;
            //Supplier
        case 1:
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(34, 5, 0, 28)];
            
            [imageView setImage:[UIImage imageNamed:@"Supplier-icon1.png"]];
            [headerView addSubview:imageView];
            
            label.text = NSLocalizedString(@"Verified Suppliers", @"供货商验证");
        }
            break;
            //Training
        case 2:
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(34, 5, 0, 28)];
            
            [imageView setImage:[UIImage imageNamed:@"Train-icon1.png"]];
            [headerView addSubview:imageView];
            
            label.text = NSLocalizedString(@"Employee Training", @"员工培训");
        }
            break;
            //Inspect
        case 3:
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(34, 5, 0, 28)];
            
            [imageView setImage:[UIImage imageNamed:@"Sanitary-icon1.png"]];
            [headerView addSubview:imageView];
            
            label.text = NSLocalizedString(@"Sanitary Controls", @"检疫控制");
        }
            
            break;
        case 4:
            label = [[UILabel alloc] initWithFrame:CGRectMake(2, 5, 0, 28)];
            label.text = NSLocalizedString(@"Customer's review", @"客户评价");
            break;
        default:
            break;
    }
    label.font = [UIFont fontWithName:@"HelveticaNeue Bold" size:20];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [[AccountManager theAccountManager] defaultFontColor];
    [label sizeToFit];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    [headerView addSubview:label];
    
    return headerView;
}

- (void)configImageSupplierCell:(UITableViewCell*)cell
{
    NSInteger _num = [SupplierArray count];
    if (_num < 1) {
        return;
    }
    __block UIImageView *_imv;
    NSString *_keyName;
    UILabel *_lbl;
    SupplierObj *_obj;
    
    UIScrollView *_scroll = (UIScrollView*)[cell viewWithTag:1];
    float _sw = _num*(THUMB_H_PADDING+50)+THUMB_H_PADDING;
    if (_sw < cell.frame.size.width) {
        _sw = cell.frame.size.width;
    }
    float _sh = _scroll.frame.size.height;
    [_scroll setContentSize:CGSizeMake(_sw, _sh)];
    
    for (int i = 0; i < _num; i++) {
        _imv = [[UIImageView alloc] initWithFrame:CGRectMake(THUMB_H_PADDING+i*(50+THUMB_H_PADDING), THUMB_V_PADDING, 50, 50)];
        [_scroll addSubview:_imv];
        
        _lbl = [[UILabel alloc] initWithFrame:CGRectMake(THUMB_H_PADDING+i*50, THUMB_V_PADDING+50+4, 50, 17)];
        _lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        _lbl.backgroundColor = [UIColor clearColor];
        _lbl.textColor = [[AccountManager theAccountManager] defaultFontColor];
        _lbl.textAlignment = NSTextAlignmentCenter;
        
        [_scroll addSubview:_lbl];
        [_lbl setCenter:CGPointMake(_imv.center.x, _lbl.center.y)];
        _obj = SupplierArray [i];
        [_lbl setText:_obj.Name];
        
        
        _keyName = SupplierLogoArray[i];
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:_keyName done:^(UIImage *image, SDImageCacheType cacheType)
         {
             if (image) {
                 [_imv setImage:image];
             }else{
                 
             }
         }];
    }
}

- (void)configImageTrainingCell:(UITableViewCell*)cell
{
    NSInteger _num = [TrainingArray count];
    if (_num < 1) {
        return;
    }
    __block UIImageView *_imv;
    NSString *_keyName;
    UILabel *_lbl;
    TrainObj *_obj;
    
    UIScrollView *_scroll = (UIScrollView*)[cell viewWithTag:1];
    float _sw = _num*(THUMB_H_PADDING+50)+THUMB_H_PADDING;
    if (_sw < cell.frame.size.width) {
        _sw = cell.frame.size.width;
    }
    float _sh = _scroll.frame.size.height;
    [_scroll setContentSize:CGSizeMake(_sw, _sh)];
    
    for (int i = 0; i < _num; i++) {
        _imv = [[UIImageView alloc] initWithFrame:CGRectMake(THUMB_H_PADDING+i*(50+THUMB_H_PADDING), THUMB_V_PADDING, 50, 50)];
        [_scroll addSubview:_imv];
        
        _lbl = [[UILabel alloc] initWithFrame:CGRectMake(THUMB_H_PADDING+i*50, THUMB_V_PADDING+50+4, 50, 17)];
        _lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        _lbl.backgroundColor = [UIColor clearColor];
        _lbl.textColor = [[AccountManager theAccountManager] defaultFontColor];
        _lbl.textAlignment = NSTextAlignmentCenter;
        
        [_scroll addSubview:_lbl];
        [_lbl setCenter:CGPointMake(_imv.center.x, _lbl.center.y)];
        _obj = TrainingArray [i];
        [_lbl setText:_obj.Name];
        
        
        _keyName = TrainingLogoArray[i];
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:_keyName done:^(UIImage *image, SDImageCacheType cacheType)
         {
             if (image) {
                 [_imv setImage:image];
             }else{
                 
             }
         }];
    }
}

- (void)configImageSanitaryCell:(UITableViewCell*)cell
{
    NSInteger _num = [SanitaryArray count];
    if (_num < 1) {
        return;
    }
    __block UIImageView *_imv;
    NSString *_keyName;
    UILabel *_lbl;
    InspectObj *_obj;
    
    UIScrollView *_scroll = (UIScrollView*)[cell viewWithTag:1];
    float _sw = _num*(THUMB_H_PADDING+50)+THUMB_H_PADDING;
    if (_sw < cell.frame.size.width) {
        _sw = cell.frame.size.width;
    }
    float _sh = _scroll.frame.size.height;
    [_scroll setContentSize:CGSizeMake(_sw, _sh)];
    
    for (int i = 0; i < _num; i++) {
        _imv = [[UIImageView alloc] initWithFrame:CGRectMake(THUMB_H_PADDING+i*(50+THUMB_H_PADDING), THUMB_V_PADDING, 50, 50)];
        [_scroll addSubview:_imv];
        
        _lbl = [[UILabel alloc] initWithFrame:CGRectMake(THUMB_H_PADDING+i*50, THUMB_V_PADDING+50+4, 50, 17)];
        _lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        _lbl.backgroundColor = [UIColor clearColor];
        _lbl.textColor = [[AccountManager theAccountManager] defaultFontColor];
        _lbl.textAlignment = NSTextAlignmentCenter;
        
        [_scroll addSubview:_lbl];
        [_lbl setCenter:CGPointMake(_imv.center.x, _lbl.center.y)];
        _obj = SanitaryArray[i];
        [_lbl setText:_obj.Name];
        
        
        _keyName = SanitaryLogoArray[i];
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:_keyName done:^(UIImage *image, SDImageCacheType cacheType)
         {
             if (image) {
                 [_imv setImage:image];
             }else{
                 
             }
         }];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SupeProfileInfoCell = @"SupeProfileInfoCell";
    static NSString *SupeProfileSupplyCell = @"SupeProfileSupplyCell";
    static NSString *SupeProfileTrainingCell = @"SupeProfileTrainingCell";
    static NSString *SupeProfileInspectCell = @"SupeProfileInspectCell";
    static NSString *SupeProfileReviewCell = @"SupeProfileReviewCell";
    
    UITableViewCell *cell;
    UILabel *_lbl;
    NSString *_strTmp;
    SupeReviewObj *_reviewObj;
    NSString *keyName;
    __block UIImageView *_imv;
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:SupeProfileInfoCell];
            if (!cell)
            {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"SupeProfileInfoCell" owner:nil options:nil] lastObject];
            }
            _lbl = (UILabel*)[cell viewWithTag:1];
            [_lbl setText:supeProfileObj.OpenTime];
            
            _lbl = (UILabel*)[cell viewWithTag:2];
            [_lbl setText:supeProfileObj.Address];
            
            _lbl = (UILabel*)[cell viewWithTag:3];
            [_lbl setText:supeProfileObj.Intro];
            
            _lbl = (UILabel*)[cell viewWithTag:4];
            [_lbl setTextColor:[UIColor colorWithHexString:@"#68bf60"]];
            _strTmp = [NSString stringWithFormat:@"%@",supeProfileObj.SupeLike];
            [_lbl setText:_strTmp];
        }
            break;
            
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:SupeProfileSupplyCell];
            if (!cell)
            {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"SupeProfileSupplyCell" owner:nil options:nil] lastObject];
            }
            
            [self configImageSupplierCell:cell];
            
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:SupeProfileTrainingCell];
            if (!cell)
            {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"SupeProfileTrainingCell" owner:nil options:nil] lastObject];
            }
            [self configImageTrainingCell:cell];
        }
            break;
            
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:SupeProfileInspectCell];
            if (!cell)
            {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"SupeProfileInspectCell" owner:nil options:nil] lastObject];
            }
            [self configImageSanitaryCell:cell];
        }
            break;
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:SupeProfileReviewCell];
            if (!cell)
            {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"SupeProfileReviewCell" owner:nil options:nil] lastObject];
            }
            
            //avatar: 40X40, cell height: 60
            if ([ReviewArray count] < 1) {
                return cell;
            }
            _reviewObj = ReviewArray[indexPath.row];
            
            _imv = (UIImageView*)[cell viewWithTag:1];
            if ([ReviewAvatarArray count] < indexPath.row)
                return cell;
            
            [[AccountManager theAccountManager] customizeAvatar:_imv];
            
            keyName = ReviewAvatarArray[indexPath.row];
            [[SDImageCache sharedImageCache] queryDiskCacheForKey:keyName done:^(UIImage *image, SDImageCacheType cacheType)
             {
                 if (image) {
                     [_imv setImage:image];
                 }else{
                     //                     [_imv setImage:[UIImage imageNamed:@"card.jpg"]];
                 }
             }];
            
            _lbl = (UILabel*)[cell viewWithTag:2];
            [_lbl setText:_reviewObj.Review];
            
            _lbl = (UILabel*)[cell viewWithTag:3];
            [_lbl setText:_reviewObj.Name];
        }
            break;
            
            
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

- (void) configSupeData
{
    if (!SupplierData) {
        SupplierData = [NSMutableData data];
    }
    const char *quota = "\"";
    NSString *_replaceStr = [NSString stringWithFormat:@"%s",quota];
    
    id res;
    NSDictionary *_dataItem;
    NSMutableString *keyName = [NSMutableString string];
    NSArray *_items;
    NSInteger _num;
    SupplierObj *_supplyObj;
    TrainObj *_trainObj;
    InspectObj *_inspectObj;
    NSString *_jsonstr;
    NSDictionary *jsonDict;
    if ([supeProfileObj.SupplierStr length] > 10) {
        _jsonstr = [supeProfileObj.SupplierStr stringByReplacingOccurrencesOfString:@"#" withString:_replaceStr];
        [SupplierData setData:[NSMutableData dataWithData:[_jsonstr dataUsingEncoding:NSUTF8StringEncoding]]];
        
        res = [NSJSONSerialization JSONObjectWithData:SupplierData options:NSJSONReadingMutableContainers error:nil];
        if (res && [res isKindOfClass:[NSDictionary class]]) {
            jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
            
            _items = [jsonDict objectForKey:@"item"];
            _num = [_items count];
            [SupplierArray removeAllObjects];
            if (_num > 0) {
                for (int i = 0; i < _num; i++) {
                    _supplyObj = [[SupplierObj alloc] init];
                    [_supplyObj initObj];
                    
                    _dataItem = [_items objectAtIndex:i];
                    _supplyObj.SuppId = [_dataItem objectForKey:@"SuppId"];
                    _supplyObj.Logo = [_dataItem objectForKey:@"Logo"];
                    _supplyObj.Name = [_dataItem objectForKey:@"Name"];
                    _supplyObj.SuppDesc = [_dataItem objectForKey:@"SuppDesc"];
                    
                    [SupplierArray addObject:_supplyObj];
                    [keyName setString: [[AccountManager theAccountManager] getLogoPreUrl]];
                    [keyName appendString:_supplyObj.Logo];
                    [SupplierLogoArray addObject:keyName];
                }
            }
        }
    }
    
    if (!TrainingData) {
        TrainingData = [NSMutableData data];
    }
    if ([supeProfileObj.TrainingStr length] > 10) {
        _jsonstr = [supeProfileObj.TrainingStr stringByReplacingOccurrencesOfString:@"#" withString:_replaceStr];
        [TrainingData setData:[NSMutableData dataWithData:[_jsonstr dataUsingEncoding:NSUTF8StringEncoding]]];
        
        res = [NSJSONSerialization JSONObjectWithData:TrainingData options:NSJSONReadingMutableContainers error:nil];
        if (res && [res isKindOfClass:[NSDictionary class]]) {
            jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
            
            _items = [jsonDict objectForKey:@"item"];
            _num = [_items count];
            [TrainingArray removeAllObjects];
            if (_num > 0) {
                for (int i = 0; i < _num; i++) {
                    _trainObj = [[TrainObj alloc] init];
                    [_trainObj initObj];
                    
                    _dataItem = [_items objectAtIndex:i];
                    _trainObj.TrainId = [_dataItem objectForKey:@"TrainId"];
                    _trainObj.Logo = [_dataItem objectForKey:@"Logo"];
                    _trainObj.Name = [_dataItem objectForKey:@"Name"];
                    _trainObj.TrainDesc = [_dataItem objectForKey:@"TrainDesc"];
                    
                    [TrainingArray addObject:_trainObj];
                    [keyName setString: [[AccountManager theAccountManager] getLogoPreUrl]];
                    [keyName appendString:_trainObj.Logo];
                    [TrainingLogoArray addObject:keyName];
                }
            }
        }
    }
    
    if (!SanitaryData) {
        SanitaryData = [NSMutableData data];
    }
    if ([supeProfileObj.SanitaryStr length] > 10) {
        _jsonstr = [supeProfileObj.SanitaryStr stringByReplacingOccurrencesOfString:@"#" withString:_replaceStr];
        [SanitaryData setData:[NSMutableData dataWithData:[_jsonstr dataUsingEncoding:NSUTF8StringEncoding]]];
        
        res = [NSJSONSerialization JSONObjectWithData:SanitaryData options:NSJSONReadingMutableContainers error:nil];
        if (res && [res isKindOfClass:[NSDictionary class]]) {
            jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
            
            _items = [jsonDict objectForKey:@"item"];
            _num = [_items count];
            [SanitaryArray removeAllObjects];
            if (_num > 0) {
                for (int i = 0; i < _num; i++) {
                    _inspectObj = [[InspectObj alloc] init];
                    [_trainObj initObj];
                    
                    _dataItem = [_items objectAtIndex:i];
                    _inspectObj.InspId = [_dataItem objectForKey:@"InspId"];
                    _inspectObj.Logo = [_dataItem objectForKey:@"Logo"];
                    _inspectObj.Name = [_dataItem objectForKey:@"Name"];
                    _inspectObj.InspDesc = [_dataItem objectForKey:@"InspDesc"];
                    
                    [SanitaryArray addObject:_inspectObj];
                    [keyName setString: [[AccountManager theAccountManager] getLogoPreUrl]];
                    [keyName appendString:_inspectObj.Logo];
                    [SanitaryLogoArray addObject:keyName];
                }
            }
        }
    }
}

- (void) reqSupeProfile:(NSString*)supeId
{
    NSMutableString *URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getSupeUrl]];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[@"interface_code=supermarketProfile&" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *_tmpStr = [NSString stringWithFormat:@"SMId=%@&",supeId];
    [body  appendData: [_tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"reqSupeProfile: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleReqSupeProfile:jsonDict];
            }
        }
    }];
    
}

- (void) handleReqSupeProfile:(NSDictionary*)dictData
{
    NSString *_ret = dictData[@"ret"];
    NSString *_imgStr;
    if ([_ret isEqualToString:@"0"]) {
        bProfile = YES;
        
        supeProfileObj.Logo = [dictData objectForKey:@"Logo"];
        supeProfileObj.Name = [dictData objectForKey:@"Name"];
        supeProfileObj.City = [dictData objectForKey:@"City"];
        supeProfileObj.District = [dictData objectForKey:@"District"];
        supeProfileObj.Address = [dictData objectForKey:@"Address"];
        supeProfileObj.OpenTime = [dictData objectForKey:@"OpenTime"];
        supeProfileObj.Intro = [dictData objectForKey:@"Intro"];
        supeProfileObj.Type = [dictData objectForKey:@"Type"];
        
        supeProfileObj.SupeBadgeOne = [dictData objectForKey:@"SupeBadgeOne"];
        supeProfileObj.SupeBadgeTwo = [dictData objectForKey:@"SupeBadgeTwo"];
        supeProfileObj.SupeBadgeThree = [dictData objectForKey:@"SupeBadgeThree"];
        supeProfileObj.SupeBadgeFour = [dictData objectForKey:@"SupeBadgeFour"];
        supeProfileObj.SupePrice = [dictData objectForKey:@"SupePrice"];
        //SupplierStr,TrainingStr,SanitaryStr
        supeProfileObj.SupplierStr = [dictData objectForKey:@"SupplierStr"];
        supeProfileObj.TrainingStr = [dictData objectForKey:@"TrainingStr"];
        supeProfileObj.SanitaryStr = [dictData objectForKey:@"SanitaryStr"];
        
        _imgStr = [dictData objectForKey:@"PhotoUrl"];
        if (_imgStr && [_imgStr length] > 4) {
            imageKey = [NSMutableString stringWithString:[[AccountManager theAccountManager] getIp6PPreUrl]];
            [imageKey appendString:_imgStr];
            
            [[SDImageCache sharedImageCache] queryDiskCacheForKey:imageKey done:^(UIImage *image, SDImageCacheType cacheType)
             {
                 
                 if (image) {
                     [_photoImv setImage:image];
                 }else{
                     [_photoImv sd_setImageWithURL:[NSURL URLWithString:imageKey] placeholderImage:[UIImage imageNamed:@"no_image"]];
                 }
                 
             }];
            
            
        }
        
        [self configSupeData];
        
    }else{
        bProfile = NO;
    }
    
    [self.tableView reloadData];
}

- (void) refreshPhotoImg
{
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:imageKey done:^(UIImage *image, SDImageCacheType cacheType)
     {
         
         if (image) {
             [_photoImv setImage:image];
         }else{
             // [_imv setImage:[UIImage imageNamed:@"card.jpg"]];
         }
         
     }];
    
}

- (void) reqSupeReview:(NSString*)supeId
{
    NSMutableString *URLPath = [NSMutableString stringWithString:[[AccountManager theAccountManager] getSupeUrl]];
    
    NSURL *URL = [NSURL URLWithString:URLPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[@"interface_code=supermarketReview&" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *_tmpStr = [NSString stringWithFormat:@"SMId=%@&",supeId];
    [body  appendData: [_tmpStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *indata, NSError *error) {
        NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *responseText = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
        NSLog(@"reqSupeReview: %@",responseText);
        
        if (!error && responseCode == 200) {
            id res = [NSJSONSerialization JSONObjectWithData:indata options:NSJSONReadingMutableContainers error:nil];
            if (res && [res isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithDictionary:(NSDictionary *)res];
                [self handleReqProdReview:jsonDict];
            }
        }
    }];
    
}

- (void) handleReqProdReview:(NSDictionary*)dictData
{
    NSDictionary *_dataItem;
    NSArray *_items = [dictData objectForKey:@"item"];
    
    SupeReviewObj *_obj;
    NSMutableString *keyName;
    NSUInteger _num = [_items count];
    if (_num < 1) {
        [self.tableView reloadData];
        return;
    }
    
    for (int i = 0; i < _num; i++) {
        _obj = [[SupeReviewObj alloc] init];
        [_obj initObj];
        
        _dataItem = [_items objectAtIndex:i];
        _obj.SMId = [_dataItem objectForKey:@"SMId"];
        _obj.Review = [_dataItem objectForKey:@"Review"];
        _obj.Avatar = [_dataItem objectForKey:@"Avatar"];
        _obj.Name = [_dataItem objectForKey:@"Name"];
        
        [ReviewArray addObject:_obj];
        keyName = [NSMutableString stringWithString:[[AccountManager theAccountManager] getAvatarPreUrl]];
        [keyName appendString:_obj.Avatar];
        [ReviewAvatarArray addObject:keyName];
        
    }
    
    if ([ReviewAvatarArray count] > 0) {
        [self updateReviewAvatar];
    }else{
        [self.tableView reloadData];
    }
}

- (void)updateReviewAvatar
{
    NSString *cacheKey;
    NSUInteger keyNum;
    __block UIImageView *tmpImv;
    
    keyNum = [ReviewAvatarArray count];
    for (int i = 0; i < keyNum; i++) {
        cacheKey = ReviewAvatarArray[i];
        
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:cacheKey done:^(UIImage *image, SDImageCacheType cacheType)
         {
             
             if (image) {
                 
             }else{
                 tmpImv = [[UIImageView alloc] initWithFrame:CGRectZero];
                 [tmpImv sd_setImageWithURL:[NSURL URLWithString:cacheKey] placeholderImage:[UIImage imageNamed:@"no_image"]];
             }
             
         }];
    }
    [self.tableView reloadData];
}

@end
