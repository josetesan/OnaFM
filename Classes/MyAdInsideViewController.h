/**
 * MyAdInsideViewController.h
 * AD-INSIDE-APP iPhone SDK.
 *
 * Interface Builder helper class implements AdInsideAppDelegate itself
 *
 * To integrate an ad using Interface Builder follow this steps:
 * 1. Drag an UIView from the IB Library into place where you want to display ads.
 * 3. Set view dimensions to 320x48 for regular ads or 320x480 for fullscreen ads.
 * 4. Drag an NSObject from the IB Library into your nib/xib and set its type to MyAdInsideViewController
 * 5. Set the AdInsideAppViewController's view outlet to that UIView.
 * 7. Set correct -zoneId and -adDomainUrl in the implementation of AdInsideAppDelegate
 * Done!
 * 8. Optionally uncomment and implement delegate methods to redefine appearance and behavior
 * If you got a question, look at the AdInsideView IB Sample project.
 */

#import <UIKit/UIKit.h>

#import "AdInsideAppDelegateProtocol.h"

@interface MyAdInsideViewController : UIViewController <AdInsideAppDelegate>

@end


