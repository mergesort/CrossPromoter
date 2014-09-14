//
//  AdvertisementViewController.h
//  Metroptimizer
//
//  Created by Joe Fabisevich on 9/6/14.
//
//

#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////
#pragma mark - App

@interface App : NSObject

@property NSInteger appIdentifier;
@property UIImage* appIcon;
@property NSString* appName;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Enums

typedef NS_ENUM(NSInteger, DisplayMode) {
    DisplayModeBanner,
    DisplayModeInterstitial,
};

////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController+PresentAd

@interface UIViewController (PresentAd)

- (void)presentAdViewController:(UIViewController*)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - PassThroughView

@interface PassthroughView : UIView
@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - AdvertisementViewController

@interface AdvertisementViewController : UIViewController

@property (readonly) UIButton* downloadButton;
@property (readonly) UIButton* shareButton;
@property (readonly) UIButton* cancelButton;
@property (nonatomic) UIColor* adBackgroundColor;

- (instancetype)initWithFeaturedApp:(App*)featuredApp displayMode:(DisplayMode)mode;

- (void)dismissAdViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end
