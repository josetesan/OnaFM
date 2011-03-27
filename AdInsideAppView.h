/**
 * AdInsideAppView.h
 * AD-INSIDE-APP iPhone SDK.
 *
 * The entry point for requesting an ad to display.
 *
 */

#import <UIKit/UIKit.h>

@protocol AdInsideAppDelegate;


@interface AdInsideAppView : UIView

/**
 * Create new AdInsideAppView with request to load an ad.
 * The delegate, if provided, is alerted on internal events (ad loaded or failed)
 * and allows you to configure appearance and bevahior. 
 * By default, an instance of AdInsideAppView automatically loads new ads
 * every 30 seconds.
 * If you decided to load ads manually, simply disable autoupdate in the delegate
 */
+(AdInsideAppView *)requestAdWithDelegate:(id<AdInsideAppDelegate>)delegate;

/**
 * Refresh new ad to display in existing AdInsideAppView. 
 * Fresh ad automatically displayed once loaded. In case of connection error
 * the old ad remains visible
 */
-(void)requestFreshAd;

@end
