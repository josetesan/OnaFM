//
//  CNSWebViewController.h
//  AdSDK
//
//  Created by Thomas Dohmke on 17.10.10.
//  Copyright 2010 Codenauts UG. All rights reserved.
//

@interface CNSWebViewController : UINavigationController <UIWebViewDelegate> {
@private
  NSString *exitURL;
  UIWebView *webView;
}

@property (nonatomic, retain) NSString *exitURL;
@property (nonatomic, retain) UIWebView *webView;

@property (nonatomic, assign) id delegate;

+ (id)sharedInstance;

@end
