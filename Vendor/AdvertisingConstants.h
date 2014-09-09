//
//  AdvertisingConstants.h
//  Metroptimizer
//
//  Created by Joe Fabisevich on 9/7/14.
//
//

extern NSInteger const sweaterWeatherAppStoreIdentifier;
extern NSInteger const metroptimizerAppStoreIdentifier;
extern NSInteger const picksAppStoreIdentifier;

extern NSString* const appIcon_key;
extern NSString* const appName_key;
extern NSString* const appIdentifier_key;

#define sweaterWeatherDictionary @{ appName_key : NSLocalizedString(@"Sweater Weather", nil), appIcon_key : [UIImage imageNamed:@"sweater-weather-app-icon"], appIdentifier_key : @(sweaterWeatherAppStoreIdentifier) }
#define metroptimizerDictionary @{ appName_key : NSLocalizedString(@"Metroptimizer", nil), appIcon_key : [UIImage imageNamed:@"metroptimizer-app-icon"], appIdentifier_key : @(metroptimizerAppStoreIdentifier) }
#define picksDictionary @{ appName_key : NSLocalizedString(@"Picks", nil), appIcon_key : [UIImage imageNamed:@"picks-app-icon"], appIdentifier_key : @(picksAppStoreIdentifier) }
