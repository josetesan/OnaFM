//
//  CNSAdView.m
//  AdSDK
//
//  Created by Thomas Dohmke on 15.06.10.
//  Copyright 2010 Codenauts UG. All rights reserved.
//

#import "CNSAdBannerView.h"
#import <QuartzCore/QuartzCore.h>
#import "CNSAdConstants.h"
#import "CNSAdEngine.h"
#import "CNSAnimatedGIFLoader.h"
#import "CNSWebViewController.h"

@interface CNSAdBannerView ()

@property (nonatomic, retain) CNSAdEngine *adEngine;
@property (nonatomic, retain) NSMutableDictionary *adSpaceIDs;
@property (nonatomic, retain) NSMutableDictionary *banners;
@property (nonatomic, retain) UIButton *bannerButton;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIView *innerView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIWebView *webView;

- (NSString *)currentAutoType;

- (void)setImageViewFromBanner;

@end

@implementation CNSAdBannerView

@synthesize adEngine;
@synthesize adSpaceIDs;
@synthesize bannerButton;
@synthesize banners;
@synthesize closeButton;
@synthesize currentType;
@synthesize containerView;
@synthesize delegate;
@synthesize imageView;
@synthesize innerView;
@synthesize overlayView;
@synthesize available;
@synthesize webView;

#pragma mark -
#pragma mark Public Methods

- (void)click {
  if ((!self.overlayView) && (!self.webView)) {
    [self performSelector:@selector(bannerTapped:) withObject:nil afterDelay:0];
  }
}

- (void)load {
  if (!self.adEngine) {
    adEngine = [[CNSAdEngine alloc] initWithDelegate:self];
  }
  
  for (NSString *type in self.adSpaceIDs) {
    [adEngine requestAdForAdSpaceID:[self.adSpaceIDs valueForKey:type] login:kCNSAdEngineLogin password:kCNSAdEnginePassword];
  }
}

- (void)setAdSpaceID:(NSString *)adSpaceID forType:(NSString *)type {
  if ((adSpaceID) && ([[adSpaceID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0)) {
    [self.adSpaceIDs setValue:adSpaceID forKey:type];
  }
}

#pragma mark -
#pragma mark Helper Methods

- (NSData *)bannerImageData {
  if ([self.adSpaceIDs count] == 1) {
    return [[[banners allValues] lastObject] valueForKey:@"imageData"];
  }
  else {
    return [[banners valueForKey:[self currentAutoType]] valueForKey:@"imageData"];
  }
}

- (NSURL *)bannerImageURL {
  if ([self.adSpaceIDs count] == 1) {
    return [[[banners allValues] lastObject] valueForKey:@"imageURL"];
  }
  else {
    return [[banners valueForKey:[self currentAutoType]] valueForKey:@"imageURL"];
  }
}

- (NSString *)currentAutoType {
  if (currentType) {
    return currentType;
  }
  else {
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
      return CNSAdBannerTypeLandscape;
    }
    else {
      return CNSAdBannerTypePortrait;
    }
  }
}

- (CGFloat)containerViewWidth {
	float inset = ([self runsOnPad] ? 20.0 : 10.0);
  if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
    return self.containerView.frame.size.height - 2 * inset;
  }
  else {
    return self.containerView.frame.size.width - 2 * inset;
  }
}

- (CGFloat)containerViewHeight {
	float inset = ([self runsOnPad] ? 20.0 : 10.0);
  if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
    return self.containerView.frame.size.width - 2 * inset;
  }
  else {
    return self.containerView.frame.size.height - 2 * inset;
  }
}

- (NSString *)exitURL {
  if ([self.adSpaceIDs count] == 1) {
    return [[[banners allValues] lastObject] valueForKey:@"exitURL"];
  }
  else {
    return [[banners valueForKey:[self currentAutoType]] valueForKey:@"exitURL"];
  }
}

- (BOOL)runsOnPad {
  BOOL iPad = NO;
  
  CNS_IF_IOS32_OR_GREATER (
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
     iPad = YES;
    }
  )
  
  return iPad;
}

- (void)setCurrentType:(NSString *)newType {
  if (currentType != newType) {
    [newType retain];
    [currentType release];
    currentType = newType;
    
    [UIView beginAnimations:@"changeBannerType" context:nil];
    [self setImageViewFromBanner];
    [UIView commitAnimations];
  }
}

- (void)setImageViewFromBanner {
  [self.imageView stopAnimating];
  
  if ([[[self bannerImageURL] path] hasSuffix:@"gif"]) {
    CNSAnimatedGIFLoader *GIFLoader = [CNSAnimatedGIFLoader sharedInstance];
    [GIFLoader decodeGIF:[self bannerImageData]];
    UIImageView *tempImageView = [GIFLoader getAnimation];
    [self.imageView setImage:[tempImageView image]];
    [self.imageView setAnimationImages:[tempImageView animationImages]];
    [self.imageView setAnimationDuration:[tempImageView animationDuration]];
    [self.imageView startAnimating];
  }
  else {
    [self.imageView setImage:[UIImage imageWithData:[self bannerImageData]]];
  }
}

- (BOOL)showTargetInOverlay {
	for (NSDictionary *banner in [self.banners allValues]) {
		if (([banner valueForKey:@"targetHeight"]) ||
				([banner valueForKey:@"targetWidth"])) {
			return YES;
		}
	}
	
	return NO;
}

- (CGFloat)targetWidth {
  float width = 0;
  if ([self.adSpaceIDs count] == 1) {
    width = [[[[banners allValues] lastObject] valueForKey:@"targetWidth"] floatValue];
  }
  else {
    width = [[[banners valueForKey:[self currentAutoType]] valueForKey:@"targetWidth"] floatValue];
  }
  
  width = (width == 0 ? 500 : width);
  width = MIN(width, [self containerViewWidth]);
  
  return width;
}

- (CGFloat)targetHeight {
  float height = 0;
  if ([self.adSpaceIDs count] == 1) {
    height = [[[[banners allValues] lastObject] valueForKey:@"targetHeight"] floatValue];
  }
  else {
    height = [[[banners valueForKey:[self currentAutoType]] valueForKey:@"targetHeight"] floatValue];
  }

  height = (height == 0 ? 500 : height);
  height = MIN(height, [self containerViewHeight]);
  
  return height;
}

- (NSURL *)targetURL {
  if ([self.adSpaceIDs count] == 1) {
    return [[[banners allValues] lastObject] valueForKey:@"targetURL"];
  }
  else {
    return [[banners valueForKey:[self currentAutoType]] valueForKey:@"targetURL"];
  }
}

#pragma mark -
#pragma mark View Management Methods

- (void)awakeFromNib {
  self.adSpaceIDs = [[[NSMutableDictionary alloc] init] autorelease];
  self.banners = [[[NSMutableDictionary alloc] init] autorelease];
  
  self.bannerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.bannerButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  self.bannerButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.bannerButton addTarget:self action:@selector(bannerTapped:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:self.bannerButton];

  self.imageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
  self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.imageView.contentMode = UIViewContentModeScaleAspectFit;
  self.imageView.frame = CGRectMake(0, 0, self.bannerButton.frame.size.width, self.bannerButton.frame.size.height);
  [self addSubview:self.imageView];
}

- (void)createOverlayView {
  self.overlayView = [[[UIView alloc] init] autorelease];
  if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
    self.overlayView.frame = CGRectMake(0, 0, self.containerView.frame.size.height, self.containerView.frame.size.width);
    self.currentType = CNSAdBannerTypeLandscape;
  }
  else {
    self.overlayView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    self.currentType = CNSAdBannerTypePortrait;
  }
  self.overlayView.backgroundColor = [UIColor blackColor];
  self.overlayView.alpha = 0.0;
  self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  [self.containerView addSubview:self.overlayView];

  self.innerView = [[UIView alloc] init];
  self.innerView.frame = [self.superview convertRect:self.frame toView:self.containerView];
  self.innerView.clipsToBounds = NO;
  self.innerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
  [self.containerView addSubview:self.innerView];

	float inset = ([self runsOnPad] ? 20.0 : 10.0);
  self.webView = [[UIWebView alloc] init];
  self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.webView.backgroundColor = [UIColor whiteColor];
  self.webView.delegate = self;
	self.webView.frame = CGRectMake(inset, inset, self.innerView.frame.size.width - 2 * inset, self.innerView.frame.size.height - 2 * inset);
  [self.innerView addSubview:self.webView];
  
  CNS_IF_IOS32_OR_GREATER(
    self.webView.layer.shadowOpacity = 1.0;
    self.webView.layer.shadowRadius = 20.0;
    self.webView.layer.shadowOffset = CGSizeMake(-20.0, -10.0);
    self.webView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.webView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.webView.frame].CGPath;
  )
  
  self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.closeButton.frame = CGRectMake(self.innerView.frame.size.width - 40.0, 0.0, 40.0, 40.0);
  self.closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
  self.closeButton.alpha = 0.0;
  [self.closeButton setImage:[UIImage imageNamed:@"CNSButtonClose.png"] forState:UIControlStateNormal];
  [self.closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  [self.innerView addSubview:self.closeButton];
}

- (void)hideOverlayWindowStopped:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
  [self.overlayView removeFromSuperview];
  [self.innerView removeFromSuperview];
  self.overlayView = nil;
  self.innerView = nil;
  self.closeButton = nil;
  self.webView = nil;
}

- (void)hideOverlayWindow {
  [UIView beginAnimations:@"showOverlayView" context:nil];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(hideOverlayWindowStopped:finished:context:)];
  
  self.overlayView.alpha = 0.0;
  self.closeButton.alpha = 0.0;
  self.innerView.frame = [self.superview convertRect:self.frame toView:self.containerView];
  CNS_IF_IOS32_OR_GREATER(
    self.webView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.innerView.frame].CGPath;
  )
  [self.webView loadHTMLString:@"" baseURL:nil];
  
  [UIView commitAnimations];
}

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self awakeFromNib];
	}
	
	return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [UIView beginAnimations:@"layoutInnerView" context:nil];
  [UIView setAnimationDuration:0.4];
  
	float inset = ([self runsOnPad] ? 20.0 : 10.0);
  CGFloat width = [self targetWidth] + 2 * inset;
  CGFloat height = [self targetHeight] + 2 * inset;
	
	float heightOffset = ([UIApplication sharedApplication].statusBarHidden ? 0 : 10);

  self.innerView.frame = CGRectMake(self.overlayView.frame.size.width / 2.0 - width / 2.0,
                                    self.overlayView.frame.size.height / 2.0 - height / 2.0 + heightOffset, 
                                    width, 
                                    height);
  CNS_IF_IOS32_OR_GREATER(
    self.webView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.webView.frame].CGPath;
  )
                          
  [UIView commitAnimations];
}

- (void)showModalView {
  CNSWebViewController *controller = [CNSWebViewController sharedInstance];
  controller.delegate = self;
  controller.exitURL = [self exitURL];
  [controller.webView loadRequest:[NSURLRequest requestWithURL:[self targetURL]]];

	if ([self.delegate isKindOfClass:[UIViewController class]]) {
		[(UIViewController *)self.delegate presentModalViewController:controller animated:YES];
	}
}

- (void)showOverlayView {
  [UIView beginAnimations:@"showOverlayView" context:nil];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(showOverlayViewStopped:finished:context:)];

	float inset = ([self runsOnPad] ? 20.0 : 10.0);
  CGFloat width = [self targetWidth] + 2 * inset;
  CGFloat height = [self targetHeight] + 2 * inset;
	
	float heightOffset = ([UIApplication sharedApplication].statusBarHidden ? 0 : 10);
  
  self.overlayView.alpha = 0.75;
  self.closeButton.alpha = 1.0;
  self.innerView.frame = CGRectMake(self.overlayView.frame.size.width / 2.0 - width / 2.0,
                                    self.overlayView.frame.size.height / 2.0 - height / 2.0 + heightOffset, 
                                    width, 
                                    height);
  CNS_IF_IOS32_OR_GREATER(
    self.webView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.webView.frame].CGPath;
  )
  [self.webView loadRequest:[NSURLRequest requestWithURL:[self targetURL]]];
  
  [UIView commitAnimations];
}

- (void)showOverlayViewStopped:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
}

#pragma mark -
#pragma mark Button Delegate Methods

- (void)bannerTapped:(id)sender {
	if ([self showTargetInOverlay]) {
    if ([delegate respondsToSelector:@selector(adBannerWillShowOverlay:)]) {
      [delegate performSelector:@selector(adBannerWillShowOverlay:) withObject:self];
    }
    
		[self createOverlayView];
		[self showOverlayView];
	}
	else {
    if ([delegate respondsToSelector:@selector(adBannerWillShowModalView:)]) {
      [delegate performSelector:@selector(adBannerWillShowModalView:) withObject:self];
    }
    
		[self showModalView];
	}
}

- (void)closeButtonTapped:(id)sender {
  if ([delegate respondsToSelector:@selector(adBannerWillHideOverlay:)]) {
    [delegate performSelector:@selector(adBannerWillHideOverlay:) withObject:self];
  }
  
  [self hideOverlayWindow];
}


#pragma mark -
#pragma mark WebView Delegate Methods

- (void)webViewCloseButtonTapped:(UIWebView *)aWebView {
  if ([delegate respondsToSelector:@selector(adBannerWillHideModalView:)]) {
    [delegate performSelector:@selector(adBannerWillHideModalView:) withObject:self];
  }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSURL *url = [request URL];
  NSString *exitURL = [self exitURL];
  if (([[url host] hasPrefix:@"phobos.apple.com"]) || 
      ([[url host] hasPrefix:@"itunes.com"]) ||
      ([[url host] hasPrefix:@"itunes.apple.com"]) ||
      ((exitURL) && ([[url host] hasPrefix:exitURL]))) {
    [[UIApplication sharedApplication] openURL:url];
    return NO;
  }  
  else {
    return YES;
  }
}

#pragma mark -
#pragma mark AdEngine Delegate Methods

- (void)adEngineDidFail:(NSString *)identifier {
}

- (void)adEngineDidReceiveBanner:(NSDictionary *)userInfo {
  NSString *type = nil;
  for (type in self.adSpaceIDs) {
    if ([[self.adSpaceIDs valueForKey:type] isEqualToString:[userInfo valueForKey:@"identifier"]]) {
      break;
    }
  }
  if (!type) {
    return;
  }
  
  if ([userInfo objectForKey:@"imageData"]) {
    [self.banners setValue:userInfo forKey:type];

    [self setImageViewFromBanner];
    
    if ([self.banners count] == [self.adSpaceIDs count]) {
      if ([delegate respondsToSelector:@selector(adBannerViewDidLoad:)]) {
        [delegate performSelector:@selector(adBannerViewDidLoad:) withObject:self];
      }
      self.available = YES;
    }
  }
  else {
    [self.banners removeObjectForKey:type];
    
    if ([delegate respondsToSelector:@selector(adBannerViewDidFail:)]) {
      [delegate performSelector:@selector(adBannerViewDidFail:) withObject:self];
    }
    self.available = NO;
  }
}

#pragma mark -
#pragma mark Memory Management Methods

- (void)dealloc {
  [self.adEngine stop];
  self.adEngine = nil;
  self.adSpaceIDs = nil;
  self.banners = nil;
  self.bannerButton = nil;
  self.closeButton = nil;
  self.containerView = nil;
  self.currentType = nil;
  self.delegate = nil;
  self.innerView = nil;
  self.overlayView = nil;
  self.webView = nil;
  
  [super dealloc];
}

@end
