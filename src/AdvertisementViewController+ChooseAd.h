//
//  AdvertisementViewController+ChooseAd.h
//  Metroptimizer
//
//  Created by Joe Fabisevich on 9/8/14.
//
//

#import "AdvertisementViewController.h"

@interface AdvertisementViewController (ChooseAd)

+ (NSInteger)chooseAppIDFrom:(NSArray*)appIDs percentages:(NSArray*)percentages;

@end
