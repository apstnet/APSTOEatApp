//
//  AccountManager.m
//  UrbanBingo
//
//  Created by apstnetmgr on 14-7-18.
//  Copyright (c) 2014年 APST. All rights reserved.
//

#import "AccountManager.h"
#import "sys/utsname.h"
#import <CommonCrypto/CommonDigest.h>


@interface AccountManager ()
{
    NSMutableString *cityStr;
    NSMutableString *districtStr;
}
@end

@implementation AccountManager

+ (NSMutableString*)getDeviceInfo
{
    static NSMutableString *_deviceInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_deviceInfo) {
            _deviceInfo = [NSMutableString string];
        }
        [_deviceInfo setString: [NSString stringWithFormat:@"%@,%@",[UIDevice currentDevice].model,[UIDevice currentDevice].systemVersion]];
    });
    return _deviceInfo;
}

+ (AccountManager*) theAccountManager
{
    static AccountManager* sAccountManager;
    
    if (!sAccountManager) {
        sAccountManager = [[AccountManager alloc] init];
        
    }
    
    return sAccountManager;
}

-(UIColor*)defaultFontColor
{
    return [UIColor colorWithHexString:@"#5a9752"];
}

-(UIColor*)backgroundLightColor
{
    return [UIColor colorWithHexString:@"#5a9752"];
}

- (void)modifyBtnStyle:(UIButton*)theBtn withRadius:(CGFloat)radius
{
    //    [theBtn setShowsTouchWhenHighlighted:NO];
    theBtn.layer.cornerRadius = radius;
    theBtn.alpha = 1;
    
    // And finally add a shadow
    theBtn.layer.shadowColor = [[UIColor greenColor] CGColor];
    theBtn.layer.shadowOffset = CGSizeMake(0.0f, 2.5f);
    theBtn.layer.shadowRadius = 1.0f;
//    theBtn.layer.shadowOpacity = 0.35f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:theBtn.bounds cornerRadius:radius];
    theBtn.layer.shadowPath = [path CGPath];
}

- (void) customizeAvatar:(UIImageView*)avatarImv
{
    avatarImv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    avatarImv.layer.masksToBounds = YES;
    //avatar size: 40 x 40
    avatarImv.layer.cornerRadius = 20.0;
    avatarImv.layer.borderColor = [UIColor greenColor].CGColor;
    avatarImv.layer.borderWidth = 0;
//    avatarImv.layer.rasterizationScale = [UIScreen mainScreen].scale;
    avatarImv.layer.shouldRasterize = YES;
    avatarImv.clipsToBounds = YES;
}

- (NSString*)getPublicUrl
{
    return  @"http://azknet.com/oeatapp/oeat_public_api.php";
}

- (NSString*)getRestUrl
{
    return  @"http://azknet.com/oeatapp/oeat_rest_api.php";
}

- (NSString*)getSupeUrl
{
    return  @"http://azknet.com/oeatapp/oeat_supe_api.php";
}

- (NSString*)getProdUrl
{
    return  @"http://azknet.com/oeatapp/oeat_prod_api.php";
}

- (NSString *)getAvatarPreUrl
{
    return  @"http://azknet.com/oeatapp/reviewer/";
}

//./logo/logo_apst_xxx.jpg, 210 x 210
- (NSString *)getLogoPreUrl
{
    return  @"http://azknet.com/oeatapp/logo/logo_";
}

//./photo/ip6p_apst_xxx.jpg, 1080 x 366
- (NSString *)getIp6PPreUrl
{
    return  @"http://azknet.com/oeatapp/photo/ip6p_";
}

- (void) saveCityStr:(NSString*)strCity
{
    if (!cityStr) {
        cityStr = [NSMutableString string];
    }
    [cityStr setString:strCity];
}

- (void) saveDistrictStr:(NSString*)strDistrict
{
    if (!districtStr) {
        cityStr = [NSMutableString string];
    }
    [districtStr setString:strDistrict];
}

- (NSString*)getCityStr
{
    return cityStr;
}

- (NSString*)getDistrictStr
{
    return districtStr;
}

- (void) saveLocInfo:(NSString*)newCity theDistrct:(NSString*)newDistrict
{
    if (!cityStr) {
        cityStr = [NSMutableString string];
    }
    [cityStr setString:newCity];
    
    if (!districtStr) {
        districtStr = [NSMutableString string];
    }
    [districtStr setString:newDistrict];
    
}
//device info
- (NSString*)deviceString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5S";
    
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 6";
    
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 6P";
    
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

-(NSString*)getDevIdentifyStr
{
    NSUUID *_uuid = [[UIDevice currentDevice] identifierForVendor];
    
    return [_uuid UUIDString];
}

- (NSString*)get24BitDevIdentifyStr
{
    NSString *dev_ider = [self getDevIdentifyStr];
    NSString *result = [dev_ider substringToIndex:24];
    
    return result;
}
//32 bit MD5
- (NSString *)getMd5_32Bit_String:(NSString *)srcString
{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

//16 bit MD5
- (NSString *)getMd5_16Bit_String:(NSString *)srcString
{
    //提取32位MD5散列的中间16位
    NSString *md5_32Bit_String=[self getMd5_32Bit_String:srcString];
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    
    return result;
}

@end
