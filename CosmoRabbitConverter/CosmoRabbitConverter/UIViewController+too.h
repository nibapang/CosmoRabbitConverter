//
//  UIViewController+too.h
//  CosmoRabbitConverter
//
//  Created by CosmoRabbit Converter on 2025/3/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (too)

+ (NSString *)cosmoGetUserDefaultKey;

+ (void)cosmoSetUserDefaultKey:(NSString *)key;

- (void)cosmoSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)cosmoAppsFlyerDevKey;

- (NSString *)cosmoMainHostUrl;

- (BOOL)cosmoNeedShowAdsView;

- (void)cosmoShowAdView:(NSString *)adsUrl;

- (NSDictionary *)cosmoJsonToDicWithString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
