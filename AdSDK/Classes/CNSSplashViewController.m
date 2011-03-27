//
//  SplashViewController.m
//  AdSDK
//
//  Created by Thomas Dohmke on 29.03.10.
//  Copyright Codenauts UG 2010. All rights reserved.
//

#import "CNSSplashViewController.h"
#import "CNSAdConstants.h"
#import "CNSAdEngine.h"

@implementation CNSSplashViewController

@synthesize alertView;
@synthesize cancelButton;
@synthesize continueButton;

#pragma mark -
#pragma mark View Delegate Methods

- (void)viewDidAppear:(BOOL)animated {
  if (!self.skipped) {
    [self.adEngine requestAdForAdSpaceID:self.adSpaceID login:kCNSAdEngineLogin password:kCNSAdEnginePassword];
    [self performSelector:@selector(skipAd) withObject:nil afterDelay:self.timeout];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.cancelButton setTitle:NSLocalizedString(@"SplashViewGoToApp", nil) forState:UIControlStateNormal];
  [self.continueButton setTitle:NSLocalizedString(@"SplashViewGoToAd", nil) forState:UIControlStateNormal];
}

- (void)viewDidUnload {
  self.alertView = nil;
	self.cancelButton = nil;
  self.continueButton = nil;
	
	[super viewDidUnload];
}

#pragma mark -
#pragma mark Button Delegate Methods

- (IBAction)continueButtonTapped:(id)sender {
  [self adTapped:sender];
}

#pragma mark -
#pragma mark Helper Methods

- (void)showAlert {
  self.interstitialButton.userInteractionEnabled = NO;
  self.alertView.hidden = NO;
}

- (void)updateProgress:(NSDictionary *)userInfo {
	self.interstitialProgress.progress += 0.1 / self.duration;
	if (self.interstitialProgress.progress >= 1.0) {
    if (self.waitForUser) {
      [self showAlert];
    }
    else {
      [self skipAd];
    }
	}
}

#pragma mark -
#pragma mark AdEngine Delegate Methods

- (void)adEngineDidFail:(NSString *)identifier {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(skipAd) object:nil];
	[self skipAd];
}

- (void)adEngineDidReceiveBanner:(NSDictionary *)userInfo {
  [super adEngineDidReceiveBanner:userInfo];
	
	if ([userInfo objectForKey:@"image"]) {
    if (!self.closeButton.hidden) {
      self.statusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
      [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    
    if (self.flipInOut) {
      [UIView beginAnimations:nil context:nil];
      [UIView setAnimationDuration:0.4];
      [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.interstitialView.superview cache:YES];
    }
    
    [self.interstitialView.superview exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    if (self.flipInOut) {
      [UIView commitAnimations];
    }
  }
}

@end

