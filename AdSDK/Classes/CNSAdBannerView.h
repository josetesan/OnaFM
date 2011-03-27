//
//  CNSAdView.h
//  AdSDK
//
//  Created by Thomas Dohmke on 15.06.10.
//  Copyright 2010 Codenauts UG. All rights reserved.
//

@class CNSAdEngine;
@class CNSWebViewController;

@interface CNSAdBannerView : UIView <UIWebViewDelegate> {
@private
  CNSAdEngine *adEngine;
  NSMutableDictionary *adSpaceIDs;
  NSMutableDictionary *banners;
  UIButton *bannerButton;
  UIButton *closeButton;
  UIImageView *imageView;
  UIView *overlayView;
  UIView *innerView;
  UIWebView *webView;
  
@public  
  BOOL available;
  id delegate;
  NSString *currentType;
  UIView *containerView;
}

extern NSString *const CNSAdBannerTypeLandscape;
extern NSString *const CNSAdBannerTypePortrait;

@property (nonatomic, assign) IBOutlet id delegate;
@property (nonatomic, assign) IBOutlet UIView *containerView;

@property (nonatomic, assign) BOOL available;
@property (nonatomic, retain) NSString *currentType;

- (BOOL)runsOnPad;

- (void)click;
- (void)load;
- (void)setAdSpaceID:(NSString *)adSpaceID forType:(NSString *)type;

@end
