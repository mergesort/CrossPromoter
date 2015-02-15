CrossPromoter
========================

A drop-in library that helps you cross-promote your apps.

The purpose of CrossPromoter is simple. You have a few apps, and you want to let others know about them when they're using one of your apps. You don't need to sign up for an ad-network, and you don't want to run ads.

CrossPromoter is quite configurable, but also easy enough that with just an AppID and a message, you can construct a banner and/or interstitial.

How about a few examples to show how simple it is.

Whether you're displaying a banner or an interstitial, you're always going to have to configure an app to display, so something like this should work.

```
App *featuredApp = [[App alloc] init];
featuredApp.appName = @"We also make Picks";
featuredApp.appIdentifier = 899161866;
featuredApp.appIcon = [UIImage imageNamed:@"my-app-icon"];
```

```
AdvertisementViewController *bannerAdViewController = [self createAdViewControllerWithDisplayMode:DisplayModeBanner];
bannerAdViewController.adBackgroundColor = [UIColor colorWithRed:52.0f/255.0f green:73.0f/255.0f blue:94.0f/255.0f alpha:0.9f];
[self presentAdViewController:bannerAdViewController animated:YES completion:nil];
```

And your end result should look like this!

<img src="/images/Banner.png" width="300px" height="533px">

Now let's say you wanted to display an interstitial, maybe once every few times the user uses the app as to not overwhelm them. All you'd have to do is this instead.

```
AdvertisementViewController *interstitialAdViewController = [self createAdViewControllerWithDisplayMode:DisplayModeInterstitial];
interstitialAdViewController.adBackgroundColor = [UIColor colorWithRed:52.0f/255.0f green:73.0f/255.0f blue:94.0f/255.0f alpha:1.0f];
[self presentAdViewController: interstitialAdViewController animated:YES completion:nil];

// In this example we've changed the App object's name to "Picks: The Smarter To-do List";
```

And voila!

<img src="/images/Interstitial.png" width="300px" height="533px">

The interstitial gives the user the option to install the app without leaving the current app.

<img src="/images/App%20Store.png" width="300px" height="533px">

And alternatively to share it.

<img src="/images/Share.png" width="300px" height="533px">


You can style the ads however you like, but you don't need to do anything more than provide an App object as we did above.

Also provided is a randomizer, where you provide as many app store identifiers and percentage as you like, and it will pick one for you to present in your AdvertisementViewController.

```
NSArray* identifiers = @[ @(picksAppStoreIdentifier), @(metroptimizerAppStoreIdentifier) ];
NSArray* percentages = @[ @(0.5), @(0.5) ];
NSInteger identifier = [AdvertisementViewController chooseAppIDFrom:identifiers percentages:percentages];

```

Pull requests and features are welcome. 😎👻🎉🎊🎉