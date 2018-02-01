//
//  AccountManager.h
//  UrbanBingo
//
//  Created by apstnetmgr on 14-7-18.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIColor+HexString.h"
#import "CustomBackButtonNavController.h"

#define THUMB_V_PADDING 10
#define THUMB_H_PADDING 20

@interface AccountManager : NSObject

+ (AccountManager*) theAccountManager;

//ios deveice info
+ (NSMutableString*)getDeviceInfo;

- (UIColor*)defaultFontColor;
- (UIColor*)backgroundLightColor;

- (NSString*)getCityStr;
- (NSString*)getDistrictStr;
- (void) saveCityStr:(NSString*)strCity;
- (void) saveDistrictStr:(NSString*)strDistrict;
- (void) saveLocInfo:(NSString*)newCity theDistrct:(NSString*)newDistrict;

- (void)modifyBtnStyle:(UIButton*)theBtn withRadius:(CGFloat)radius;
- (void) customizeAvatar:(UIImageView*)avatarImv;

- (NSString *)getAvatarPreUrl;
- (NSString *)getPublicUrl;
- (NSString*)getRestUrl;
- (NSString*)getSupeUrl;
- (NSString*)getProdUrl;

- (NSString *)getLogoPreUrl;
- (NSString *)getIp6PPreUrl;

//device info
- (NSString*)deviceString;
//device identifier
- (NSString*)getDevIdentifyStr;
- (NSString*)get24BitDevIdentifyStr;
- (NSString *)getMd5_32Bit_String:(NSString *)srcString;
- (NSString *)getMd5_16Bit_String:(NSString *)srcString;


@end
