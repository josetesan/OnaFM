//
//  ONA_FMViewController.h
//  ONA FM
//
//  Created by jose luis sanchez on 02/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioStreamer.h"
#import "CNSAdKit.h"



@interface ONA_FMViewController : UIViewController <UIWebViewDelegate>{

	IBOutlet UIButton *playButton;
	IBOutlet UIToolbar *toolbar;
    CNSAdBannerView *adBannerView;
	AudioStreamer *streamer;
	IBOutlet UIWebView* webView;
	UIActivityIndicatorView *spinner;
	UIActivityIndicatorView *webSpinner;
	
}

@property (nonatomic,retain) IBOutlet UIButton *playButton;
@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic,retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet CNSAdBannerView *adBannerView;




-(IBAction) startTheAction:(id)sender;
-(void) queueTheWeb;
-(void) stopAudio;
-(void) runAudio;
#pragma mark -
#pragma mark AdBanners
-(void)hideBannerView;

@end

