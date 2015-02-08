//
//  AdvertisementViewController+ChooseAd.m
//  Metroptimizer
//
//  Created by Joe Fabisevich on 9/8/14.
//
//

#import "AdvertisementViewController+ChooseAd.h"

@implementation AdvertisementViewController (ChooseAd)

+ (NSInteger)chooseAppIDFrom:(NSArray*)appIDs percentages:(NSArray*)percentages
{
    NSAssert(appIDs.count == percentages.count, @"The amount of IDs must be as many as the odds for each app");
    CGFloat totalPercentage = 0.0f;
    for (NSNumber* number in percentages) {
        totalPercentage += [number floatValue];
    }
    
    NSAssert(abs(1.0-totalPercentage) < 0.00001, @"Your total odds must be equivalent to 100%%");
    
    NSMutableArray* mutableAppIDs = [NSMutableArray array];
    
    for (int i = 0; i < percentages.count; i++) {
        CGFloat currentPercentage = [percentages[i] floatValue];
        
        for (int j = 0; j < 100 * currentPercentage; j++) {
            [mutableAppIDs addObject:appIDs[i]];
        }
    }
    
    NSInteger randomInteger = arc4random() % 100;
    
    return [mutableAppIDs[randomInteger] integerValue];
}
@end
