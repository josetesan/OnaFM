//
//  CNSInterstitialViewController.m
//  AdSDK
//
//  Created by Thomas Dohmke on 18.10.10.
//  Copyright 2010 Codenauts UG. All rights reserved.
//

#import "CNSInterstitialViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CNSAdConstants.h"
#import "CNSAdEngine.h"
#import "CNSWebViewController.h"

@interface CNSInterstitialViewController ()

@property (nonatomic, retain) NSString *exitURL;

- (void)presentWebView;

@end

@implementation CNSInterstitialViewController

@synthesize adEngine;
@synthesize adSpaceID;
@synthesize clickable;
@synthesize closeButton;
@synthesize delegate;
@synthesize duration;
@synthesize exitURL;
@synthesize flipInOut;
@synthesize interstitialButton;
@synthesize interstitialProgress;
@synthesize interstitialView;
@synthesize loaded;
@synthesize showTargetInApp;
@synthesize skipped;
@synthesize statusBarHidden;
@synthesize targetURL;
@synthesize timer;
@synthesize timeout;
@synthesize toolbar;
@synthesize waitForUser;
@synthesize visible;

#pragma mark -
#pragma mark View Delegate Methods

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
  if (self = [super initWithNibName:nibName bundle:nibBundle]) {
    clickable = NO;
    duration = 5.0;
		flipInOut = NO;
    loaded = NO;
    skipped = NO;
    showTargetInApp = NO;
    timeout = 5.0;
  }
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	adEngine = [[CNSAdEngine alloc] initWithDelegate:self];
  
  self.interstitialButton.userInteractionEnabled = self.clickable;
}

- (void)viewDidUnload {
  [timer invalidate];
  timer = nil;
  
	[adEngine release];
	adEngine = nil;
  
	self.closeButton = nil;
  self.delegate = nil;
  self.exitURL = nil;
	self.interstitialButton = nil;
	self.interstitialProgress = nil;
	self.interstitialView = nil;
  self.targetURL = nil;
  self.toolbar = nil;
	
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
  if (!skipped) {
    [super viewWillAppear:animated];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.visible = YES;
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  // Landscape is only supported in iOS > 3.2
  CNS_IF_IOS32_OR_GREATER (
                           return YES;
                           )
  
  return NO;
}

- (void)viewWillChangeOrientation:(UIInterfaceOrientation)newInterfaceOrientation duration:(NSTimeInterval)animationDuration {
  // Landscape is only supported in iOS > 3.2
  CNS_IF_IOS32_OR_GREATER (
                           [UIView beginAnimations:nil context:nil];
                           [UIView setAnimationDuration:animationDuration];
                           
                           if (newInterfaceOrientation == UIDeviceOrientationLandscapeLeft) {
                             self.view.transform = CGAffineTransformMakeRotation(90.0 / 180.0 * M_PI);
                           }
                           else if (newInterfaceOrientation == UIDeviceOrientationLandscapeRight) {
                             self.view.transform = CGAffineTransformMakeRotation(-90.0 / 180.0 * M_PI);
                           }
                           else if (newInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
                             self.view.transform = CGAffineTransformMakeRotation(M_PI);
                           }
                           else {
                             self.view.transform = CGAffineTransformIdentity;
                           }
                           
                           self.view.frame = [[UIScreen mainScreen] bounds];
                           
                           [UIView commitAnimations];
                           )
}

#pragma mark -
#pragma mark WebView Delegate Methods

- (void)webViewCloseButtonTapped:(UIWebView *)aWebView {
  if ([self.delegate respondsToSelector:@selector(interstitialViewFinished:)]) {
    [self.delegate performSelector:@selector(interstitialViewFinished:) withObject:self.view];
  }
  
  [self skipAdAnimated:NO];
}

#pragma mark -
#pragma mark Button Delegate Methods

- (IBAction)adTapped:(id)sender {
  if (showTargetInApp) {
    [self presentWebView];
    skipped = YES;
  }
  else {
    [[UIApplication sharedApplication] openURL:self.targetURL];
  }
}

- (IBAction)cancelButtonTapped:(id)sender {
  if ([self.delegate respondsToSelector:@selector(interstitialViewFinished:)]) {
    [self.delegate performSelector:@selector(interstitialViewFinished:) withObject:self.view];
  }
  
  [self skipAd];
}

#pragma mark -
#pragma mark Helper Methods

- (void)load {
  [self.view setNeedsDisplay];
  [self.adEngine requestAdForAdSpaceID:self.adSpaceID login:kCNSAdEngineLogin password:kCNSAdEnginePassword];
}

- (BOOL)presentInWindow:(UIWindow *)window delegate:(id)aDelegate {
  if (!self.loaded) {
    return NO;
  }
  
  [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
  [window insertSubview:self.view atIndex:0];
  self.view.alpha = 1;
  
  if (self.flipInOut) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
  }

  [window bringSubviewToFront:self.view];
  
  if (self.flipInOut) {
    [UIView commitAnimations];
  }

  self.delegate = aDelegate;
  self.interstitialProgress.progress = 0;
  self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
  
  return YES;
}

- (void)presentWebView {
  [[UIApplication sharedApplication] setStatusBarHidden:statusBarHidden animated:NO];
  
  CNSWebViewController *controller = [CNSWebViewController sharedInstance];
  controller.delegate = self;
  controller.exitURL = exitURL;
  [controller.webView loadRequest:[NSURLRequest requestWithURL:[self targetURL]]];
  [self presentModalViewController:controller animated:YES];
}

- (void)setClickable:(BOOL)allowClicks {
  clickable = allowClicks;
  
  if (clickable) {
    self.interstitialButton.userInteractionEnabled = YES;
  }
  else {
    self.interstitialButton.userInteractionEnabled = NO;
  }
}

- (void)skipAdAnimated:(BOOL)animated {
  [[UIApplication sharedApplication] setStatusBarHidden:statusBarHidden animated:NO];
  
  if ((self.flipInOut) && (animated)) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.superview cache:YES];
  }
  
  self.view.alpha = 0;
	[self.view removeFromSuperview];
  self.visible = NO;
  
  if ((self.flipInOut) && (animated)) {
    [UIView commitAnimations];
  }
	
  [timer invalidate];
  timer = nil;
}

- (void)skipAd {
  [self skipAdAnimated:YES];
}

- (void)updateProgress:(NSDictionary *)userInfo {
	interstitialProgress.progress += 0.1 / self.duration;
	if (interstitialProgress.progress >= 1.0) {
    [self skipAd];
	}
}

#pragma mark -
#pragma mark AdEngine Delegate Methods

- (void)adEngineDidFail:(NSString *)identifier {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(skipAd) object:nil];
	[self skipAd];
}

- (void)adEngineDidReceiveBanner:(NSDictionary *)userInfo {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(skipAd) object:nil];
	
	if (![userInfo objectForKey:@"image"]) {
		[self skipAd];
	}
	else {
    self.loaded = YES;
    self.waitForUser = [[userInfo valueForKey:@"waitForUser"] boolValue];
    self.exitURL = [[userInfo valueForKey:@"exitURL"] retain];
    self.targetURL = [[userInfo valueForKey:@"targetURL"] retain];
    
    UIImage *banner = [userInfo valueForKey:@"image"];
    if (banner.size.height == 480) {
      self.toolbar.hidden = NO;
      self.closeButton.hidden = NO;
      self.interstitialButton.frame = CGRectMake(0, 0, 320, 480);
    }
		[self.interstitialButton setBackgroundImage:banner forState:UIControlStateNormal];
		self.interstitialProgress.progress = 0.01;
		self.interstitialView.hidden = NO;
	}
}

#pragma mark -
#pragma mark Memory Management Methods

- (void)dealloc {
  [self viewDidUnload];
  
  self.adSpaceID = nil;
  self.delegate = nil;
  
	[super dealloc];
}

@end
