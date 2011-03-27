//
//  CNSWebViewController.m
//  AdSDK
//
//  Created by Thomas Dohmke on 17.10.10.
//  Copyright 2010 Codenauts UG. All rights reserved.
//

#import "CNSWebViewController.h"

@implementation CNSWebViewController

@synthesize delegate;
@synthesize exitURL;
@synthesize webView;

static CNSWebViewController *sharedInstance = nil;

#pragma mark -
#pragma mark Initialization Methods

+ (id)sharedInstance {
  if (!sharedInstance) {
    sharedInstance = [[[self class] alloc] init];
  }
  return sharedInstance;
}

- (id)init {
 	if (self = [super init]) {
    self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;

    UIViewController *webViewController = [[UIViewController alloc] init];
    webViewController.view = self.webView;
    webViewController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeButtonTapped:)] autorelease];
    [self pushViewController:webViewController animated:NO];
    [webViewController release];
  }
  
  return self;
}

#pragma mark -
#pragma mark Button Delegate Methods

- (void)closeButtonTapped:(id)sender {
  if ([self.delegate respondsToSelector:@selector(webViewCloseButtonTapped:)]) {
    [self.delegate performSelector:@selector(webViewCloseButtonTapped:) withObject:self.webView];
  }
  
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark WebView Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSURL *url = [request URL];
  if (([[url host] hasPrefix:@"phobos.apple.com"]) || 
      ([[url host] hasPrefix:@"itunes.com"]) ||
      ([[url host] hasPrefix:@"itunes.apple.com"]) ||
      ((self.exitURL) && ([[url host] hasPrefix:self.exitURL]))) {
    [[UIApplication sharedApplication] openURL:url];
    return NO;
  }  
  else {
    return YES;
  }
}

#pragma mark -
#pragma mark Memory Management Methods

- (void)dealloc {
  self.delegate = nil;
  self.exitURL = nil;
  self.webView = nil;
  
  [super dealloc];
}

@end
