//
//  ViewController.m
//  AdvertisementTest
//
//  Created by Joe Fabisevich on 9/8/14.
//  Copyright (c) 2014 Snarkbots Inc. All rights reserved.
//

#import "ViewController.h"
#import "AdvertisementViewController.h"
#import "AdvertisementViewController+ChooseAd.h"

#import "AdvertisingConstants.h"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface ViewController ()

@property BOOL showingBanner;
@property App* featuredApp;
@property AdvertisementViewController* advertisementController;

@property IBOutlet UIButton* bannerButton;

- (IBAction)tappedInterstitial:(id)sender;
- (IBAction)tappedBanner:(id)sender;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray* identifiers = @[ @(sweaterWeatherAppStoreIdentifier), @(picksAppStoreIdentifier) ];
    NSArray* percentages = @[ @(0.3), @(0.7) ];
    NSInteger identifier = [AdvertisementViewController chooseAppIDFrom:identifiers percentages:percentages];

    NSDictionary* appDictionary = (identifier == sweaterWeatherAppStoreIdentifier) ? sweaterWeatherDictionary : (identifier == picksAppStoreIdentifier) ? picksDictionary : nil;

    _featuredApp = [[App alloc] init];
    _featuredApp.appName = appDictionary[appName_key];
    _featuredApp.appIdentifier = [appDictionary[appIdentifier_key] integerValue];
    _featuredApp.appIcon = appDictionary[appIcon_key];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button handlers

- (IBAction)tappedInterstitial:(id)sender
{
    _advertisementController = [[AdvertisementViewController alloc] initWithFeaturedApp:self.featuredApp displayMode:DisplayModeInterstitial];
    [self presentAdViewController:_advertisementController animated:YES completion:nil];
}

- (IBAction)tappedBanner:(id)sender
{
    if (self.showingBanner) {
        if (_advertisementController) {
            [_advertisementController dismissAdViewControllerAnimated:YES completion:nil];
        }
        [_bannerButton setTitle:NSLocalizedString(@"Show banner", nil) forState:UIControlStateNormal];
        [_advertisementController dismissAdViewControllerAnimated:YES completion:nil];
    } else {
        [_bannerButton setTitle:NSLocalizedString(@"Hide banner", nil) forState:UIControlStateNormal];
        _advertisementController = [[AdvertisementViewController alloc] initWithFeaturedApp:self.featuredApp displayMode:DisplayModeBanner];
        [self presentAdViewController:_advertisementController animated:YES completion:nil];
    }

    self.showingBanner = !self.showingBanner;
}

@end
