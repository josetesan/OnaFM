/**
 * AdInsideAppDelegateProtocol.h
 * AD-INSIDE-APP iPhone SDK.
 *
 * Defines the AdInsideAppDelegate protocol.
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class AdInsideAppView;

@protocol AdInsideAppDelegate <NSObject>

@required
/** 
 * Use this to provide a zone id for an ad request. 
 * Get a zone id from Ad Inside service provider http://www.ad-inside.com
 */
- (NSString *)zoneId;

/**
 * Use this to provide a domain url for an ad request.
 * Get a domain url from your Ad Inside service provider
 */
- (NSString *)adDomainUrl;


@optional

/**
 * Implement and return YES in case you want to perform test requests. Default is NO;
 */
-(BOOL)isAdTestRequest;

/**
 * Implement and return YES in case you want to perform test requests. Default is NO
 */
-(BOOL)isAdFullscreen:(AdInsideAppView *)aView;

/**
 * Implement and return NO in case don't you want to perform auto requests. Default = YES
 */
-(BOOL)isAdAutoupdate:(AdInsideAppView *)aView;

/**
 * Implement and return NO in case you don't want the ad to auto hide. Default = NO
 */
-(BOOL)isAdAutohide:(AdInsideAppView *)aView;


/**
 * Implement and return YES in case you want to open banner links inside the app.  Default NO
 */
-(BOOL)isAdLinkEmbedded:(AdInsideAppView *)aView;

/**
 * Implement and return false in case don't you want to perfom banner links inside the app.  Default NO
 */
-(BOOL)isAdAutoShow:(AdInsideAppView *)aView;

/**
  * Implement to define time to refresh an Ad. Default = 30.0 seconds
  */
-(NSTimeInterval)adAutoupdateTime:(AdInsideAppView *)aView;

/**
 * Implement to define time to refresh an Ad. Max/Default = 5.0 seconds
 */
-(NSTimeInterval)adFullscreenTime:(AdInsideAppView *)aView;

/**
 * Implement to define time to hide an Ad banner. Max/Default = 5.0 seconds
 */
-(NSTimeInterval)adAutohideTime:(AdInsideAppView *)aView;

/**
 * Implement to define time after which the baner is shown automatically.
 */
-(NSTimeInterval)adAutoShowAfterTime:(AdInsideAppView *)aView;

/**
 * Implement and return UIColor to use when draw text. Default = [UIColor whiteColor]
 */
-(UIColor *)adTextColor:(AdInsideAppView *)aView;

/**
 * Implement and return UIFont to use when draw text.
 */
-(UIFont *)adTextFont:(AdInsideAppView *)aView;

/**
 * Implement and return UIColor to use for background on the toolbar web view in embedded links. Default = [UIColor lightGrayColor]
 */
-(UIColor *)adWebViewToolbarTintColor;


/**
 * Implement and return UIImage to use for background when draw text.
 * Image format is : 320 x 29
 */
-(UIImage *)adTextBackgroundImage:(AdInsideAppView *)aView;

/**
 * Sent when an ad request loaded an ad; this is a good opportunity to add
 * this view to the hierachy, if it has not yet been added.
 * Note that this will only ever be sent once per AdInsideAppView, regardless of whether
 * new ads are subsequently requested in the same AdInsideAppView.
 */
- (void)didReceiveAd:(AdInsideAppView *)adView;

/** Sent when an ad request failed to load an ad.
 * Note that this will only ever be sent once per AdInsideAppView, regardless of whether
 * new ads are subsequently requested in the same AdInsideAppView.
 */
- (void)didFailToReceiveAd:(AdInsideAppView *)adView;

/** Sent when an interstitial is dismissed
 * Note that this will only ever be sent once per AdInsideAppView, regardless of whether
 * new ads are subsequently requested in the same AdInsideAppView.
 */
- (void)didDismissFullscreenAd:(AdInsideAppView *)adView;

@end
