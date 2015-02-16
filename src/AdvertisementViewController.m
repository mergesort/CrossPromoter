//
//  AdvertisementViewController.m
//  Metroptimizer
//
//  Created by Joe Fabisevich on 9/6/14.
//
//

#import "AdvertisementViewController.h"

#import <PureLayout/PureLayout.h>
#import <UIViewController+StoreKit/UIViewController+StoreKit.h>

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants

CGFloat const AdvertisementViewControllerBannerHeight = 50.0f;

////////////////////////////////////////////////////////////////////////////////
#pragma mark - AdvertisementViewController

@interface AdvertisementViewController () <UIGestureRecognizerDelegate>

@property DisplayMode displayMode;

@property UIView* interstitialView;
@property UIView* bannerView;

@property (nonatomic) NSInteger storeIdentifier;
@property (nonatomic) NSString* appName;
@property (nonatomic) UIImage* appIcon;

@property (readwrite) UILabel* titleLabel;
@property UIButton* appButton;
@property (readwrite) UIButton* downloadButton;
@property (readwrite) UIButton *shareButton;

@property BOOL viewHasAppeared;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - AdvertisementViewController

@implementation AdvertisementViewController

- (instancetype)initWithFeaturedApp:(App*)featuredApp displayMode:(DisplayMode)mode
{
    self = [super init];

    if (self) {
        _storeIdentifier = featuredApp.appIdentifier;
        _appName = featuredApp.appName;
        _appIcon = featuredApp.appIcon;
        _displayMode = mode;

        PassthroughView* view = [[PassthroughView alloc] initWithFrame:self.view.frame];
        self.view = view;

        [self commonInit];
    }

    return self;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Setup

- (void)commonInit
{
    if (self.displayMode == DisplayModeInterstitial) {
        _interstitialView = [[UIView alloc] init];
        [self.view addSubview:_interstitialView];

        _adBackgroundColor = [UIColor whiteColor];
        _interstitialView.backgroundColor = self.adBackgroundColor;
    } else if (self.displayMode == DisplayModeBanner) {

        _bannerView = [[UIView alloc] init];
        [self.view addSubview:_bannerView];
        _adBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9f];
        _bannerView.backgroundColor = _adBackgroundColor;

        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBanner)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.numberOfTouchesRequired = 1;
        [_bannerView addGestureRecognizer:tapRecognizer];
    }

    UIView* adView = (self.displayMode == DisplayModeInterstitial) ? _interstitialView : (self.displayMode == DisplayModeBanner) ? _bannerView : nil;

    NSString* text = (self.displayMode == DisplayModeInterstitial) ? [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"Brought to you by", nil), self.appName] : [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"We also make", nil), self.appName];

    _titleLabel = [[UILabel alloc] init];
    [adView addSubview:_titleLabel];
    _titleLabel.numberOfLines = (self.displayMode == DisplayModeInterstitial) ? 0 : (self.displayMode == DisplayModeBanner) ? 1 : 0;
    _titleLabel.textAlignment = (self.displayMode == DisplayModeInterstitial) ? NSTextAlignmentCenter : (self.displayMode == DisplayModeBanner) ? NSTextAlignmentLeft : NSTextAlignmentLeft;
    _titleLabel.text = text;
    CGFloat fontSize = (self.displayMode == DisplayModeInterstitial) ? 36.0f : (self.displayMode == DisplayModeBanner) ? 18.0f : 0.0f;
    _titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:fontSize];
    _titleLabel.textColor = (self.displayMode == DisplayModeInterstitial) ? [UIColor darkTextColor] : (self.displayMode == DisplayModeBanner) ? [UIColor whiteColor] : nil;

    _appButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [adView addSubview:_appButton];
    _appButton.layer.cornerRadius = (self.displayMode == DisplayModeInterstitial) ? 27.0f : (self.displayMode == DisplayModeBanner) ? 10.0f : 0.0f;
    _appButton.clipsToBounds = YES;
    [_appButton addTarget:self action:@selector(tappedAppButton) forControlEvents:UIControlEventTouchUpInside];
    _appButton.userInteractionEnabled = YES;
    [_appButton setBackgroundImage:self.appIcon forState:UIControlStateNormal];

    _downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [adView addSubview:_downloadButton];
    [_downloadButton setTitle:NSLocalizedString(@"Free", nil) forState:UIControlStateNormal];
    _downloadButton.backgroundColor = [UIColor colorWithRed:(39.0f/255.0f) green:(174.0f/255.0f) blue:(96.0f/255.0f) alpha:1.0f];
    _downloadButton.layer.cornerRadius = 4.0f;
    _downloadButton.clipsToBounds = YES;
    [_downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _downloadButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18.0f];
    [_downloadButton addTarget:self action:@selector(tappedDownloadButton) forControlEvents:UIControlEventTouchUpInside];

    _shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [adView addSubview:_shareButton];
    [_shareButton setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
    _shareButton.backgroundColor = [UIColor colorWithRed:(52.0f/255.0f) green:(152.0f/255.0f) blue:(219.0f/255.0f) alpha:1.0f];
    _shareButton.layer.cornerRadius = 4.0f;
    _shareButton.clipsToBounds = YES;
    [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shareButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18.0f];
    [_shareButton addTarget:self action:@selector(tappedShareButton) forControlEvents:UIControlEventTouchUpInside];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [adView addSubview:_cancelButton];
    [_cancelButton setTitle:NSLocalizedString(@"Later", nil) forState:UIControlStateNormal];
    _cancelButton.backgroundColor = [UIColor darkGrayColor];
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelButton.layer.cornerRadius = 4.0f;
    _cancelButton.clipsToBounds = YES;
    _cancelButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Book" size:18.0f];
    [_cancelButton addTarget:self action:@selector(tappedCancelButton) forControlEvents:UIControlEventTouchUpInside];

    [self setupConstraints];
}

- (void)setupConstraints
{
    if (!self.viewHasAppeared) {
        self.viewHasAppeared = YES;

        if (self.displayMode == DisplayModeInterstitial) {
            [self.interstitialView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

            [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
            [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [self.titleLabel autoSetDimension:ALDimensionHeight toSize:150.0f];

            CGFloat const buttonSide = 95.0f;
            [self.appButton autoSetDimensionsToSize:CGSizeMake(buttonSide, buttonSide)];
            [self.appButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.appButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

            CGFloat const actionButtonHeight = 44.0f;
            CGFloat const bottomButtonInset = 5.0f;

            NSDictionary* views = @{
                                    @"downloadButton" : self.downloadButton,
                                    @"shareButton" : self.shareButton,
                                    @"cancelButton" : self.cancelButton,
                                    };

            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[downloadButton]-padding-[shareButton(==downloadButton)]-padding-[cancelButton(==downloadButton)]-padding-|" options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom metrics:@{@"padding" : @(5.0f)} views:views]];

            [self.downloadButton autoSetDimension:ALDimensionHeight toSize:actionButtonHeight];
            [self.downloadButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:bottomButtonInset];

            [self.shareButton autoSetDimension:ALDimensionHeight toSize:actionButtonHeight];
            [self.shareButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:bottomButtonInset];

            [self.cancelButton autoSetDimension:ALDimensionHeight toSize:actionButtonHeight];
            [self.cancelButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:bottomButtonInset];
        } else if (self.displayMode == DisplayModeBanner) {
            [self.bannerView autoSetDimension:ALDimensionHeight toSize:AdvertisementViewControllerBannerHeight];
            [self.bannerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];

            CGFloat const horizontalInset = 4.0f;
            CGFloat const verticalInset = 4.0f;
            [self.appButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, 0) excludingEdge:ALEdgeRight];
            [self.appButton autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:self.appButton];

            [self.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(verticalInset, 0, verticalInset, horizontalInset) excludingEdge:ALEdgeLeft];
            [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.appButton withOffset:3 * horizontalInset];
        }
    }

    [self.view layoutIfNeeded];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle methods

- (void)didMoveToParentViewController:(UIViewController*)parent
{
    CGAffineTransform startTransform = (parent) ? CGAffineTransformMakeTranslation(0, AdvertisementViewControllerBannerHeight) : CGAffineTransformIdentity;
    CGAffineTransform endTransform = (parent) ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(0, AdvertisementViewControllerBannerHeight);

    //This is a silly alias so we don't have to store a variable of whether it animates
    CGFloat animationDuration = (self.view.tag == YES) ? 0.4f : 0.0f;
    self.bannerView.layer.affineTransform = startTransform;
    [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bannerView.layer.affineTransform = endTransform;
    } completion:^(BOOL finished) {
        if (finished && parent == nil) {
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
        }
    }];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Mutators

- (void)setAdBackgroundColor:(UIColor*)adBackgroundColor
{
    if (self.displayMode == DisplayModeInterstitial) {
        _interstitialView.backgroundColor = adBackgroundColor;
    } else if (self.displayMode == DisplayModeBanner) {
        _bannerView.backgroundColor = adBackgroundColor;
    }
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button taps

- (void)tappedAppButton
{
    [self openApp];
}

- (void)tappedDownloadButton
{
    [self openApp];
}

- (void)tappedShareButton
{
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[ [AdvertisementViewController appURLForIdentifier:self.storeIdentifier] ] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)tappedBanner
{
    [self openApp];
}

- (void)tappedCancelButton
{
    [self dismissAdViewControllerAnimated:YES completion:nil];
}

- (void)openApp
{
    NSString * const originalTitle = (self.displayMode == DisplayModeInterstitial) ? [self.downloadButton titleForState:UIControlStateNormal] : self.titleLabel.text;

    void (^setTitle) (NSString *) = ^(NSString *title) {
        if (self.displayMode == DisplayModeInterstitial)
        {
            [self.downloadButton setTitle:title forState:UIControlStateNormal];
        }
        else
        {
            self.titleLabel.text = title;
        }
    };

    self.loadingStoreKitItemBlock = ^{
        setTitle(NSLocalizedString(@"Opening...", nil));
    };

    self.loadedStoreKitItemBlock = ^{
        setTitle(originalTitle);
    };

    [self presentStoreKitItemWithIdentifier:self.storeIdentifier];
}

- (void)dismissAdViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (self.displayMode == DisplayModeInterstitial) {
        [self dismissViewControllerAnimated:flag completion:completion];
    } else {
        [self didMoveToParentViewController:nil];
    }
}

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - App

@implementation App
@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController+PresentAd

@implementation UIViewController (PresentAd)

- (void)presentAdViewController:(AdvertisementViewController*)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if (viewControllerToPresent.displayMode == DisplayModeInterstitial) {
        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        [self addChildViewController:viewControllerToPresent];
        [self.view addSubview:viewControllerToPresent.view];
        //We use this in didMoveToParentViewController to determine whether it animates or not
        //It's really a hack so we don't have to store an iVar
        viewControllerToPresent.view.tag = flag;
        [viewControllerToPresent didMoveToParentViewController:self];
    }
}

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - PassThroughView

@implementation PassthroughView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* view = [super hitTest:point withEvent:event];
    return view == self ? nil : view;
}

@end
