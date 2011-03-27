//
//  CNSInterstitialViewController.h
//  AdSDK
//
//  Created by Thomas Dohmke on 18.10.10.
//  Copyright 2010 Codenauts UG. All rights reserved.
//

@class CNSAdEngine;

@interface CNSInterstitialViewController : UIViewController <UIWebViewDelegate> {
@private
	BOOL flipInOut;
  BOOL showTargetInApp;
  BOOL skipped;
  BOOL statusBarHidden;
  BOOL waitForUser;
	CNSAdEngine *adEngine;
	float timeout;
	float duration;
	NSString *adSpaceID;
  NSString *exitURL;
  NSTimer *timer;
	NSURL *targetURL;
  UIButton *closeButton;
	UIButton *interstitialButton;
	UIProgressView *interstitialProgress;
	UIToolbar *toolbar;
	UIView *interstitialView;
}

@property (nonatomic, retain) IBOutlet UIProgressView *interstitialProgress;
@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIButton *interstitialButton;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIView *interstitialView;

@property (nonatomic, retain) CNSAdEngine *adEngine;
@property (nonatomic, retain) NSURL *targetURL;
@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, copy) NSString *adSpaceID;

@property (nonatomic, assign) BOOL clickable;
@property (nonatomic, assign) BOOL flipInOut;
@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, assign) BOOL showTargetInApp;
@property (nonatomic, assign) BOOL skipped;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) BOOL waitForUser;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) float timeout;
@property (nonatomic, assign) id delegate;

- (IBAction)adTapped:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;

- (void)adEngineDidReceiveBanner:(NSDictionary *)userInfo;
- (void)load;
- (BOOL)presentInWindow:(UIWindow *)window delegate:(id)aDelegate;
- (void)skipAd;
- (void)skipAdAnimated:(BOOL)animated;
- (void)viewWillChangeOrientation:(UIInterfaceOrientation)newInterfaceOrientation duration:(NSTimeInterval)animationDuration;

@end