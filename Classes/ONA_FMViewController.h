//
//  ONA_FMViewController.h
//  ONA FM
//
//  Created by jose luis sanchez on 02/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioStreamer.h"
<<<<<<< HEAD
#import "CNSAdKit.h"
=======
>>>>>>> 1799322c5bfe3bbcf9f4f89befb48fb16f528a87


@interface ONA_FMViewController : UIViewController <UIWebViewDelegate>{

	IBOutlet UIButton *playButton;
	IBOutlet UIToolbar *toolbar;
	AudioStreamer *streamer;
	IBOutlet UIWebView* webView;
	UIActivityIndicatorView *spinner;
	UIActivityIndicatorView *webSpinner;
<<<<<<< HEAD
    CNSAdBannerView *adBannerView;
=======
>>>>>>> 1799322c5bfe3bbcf9f4f89befb48fb16f528a87
	
}

@property (nonatomic,retain) IBOutlet UIButton *playButton;
@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic,retain) IBOutlet UIToolbar *toolbar;
<<<<<<< HEAD
@property (nonatomic,retain) IBOutlet CNSAdBannerView *adBannerView;
=======
>>>>>>> 1799322c5bfe3bbcf9f4f89befb48fb16f528a87



-(IBAction) startTheAction:(id)sender;
-(void) queueTheWeb;
-(void) stopAudio;
-(void) runAudio;
<<<<<<< HEAD
- (void)hideBannerView;
=======
>>>>>>> 1799322c5bfe3bbcf9f4f89befb48fb16f528a87
@end

