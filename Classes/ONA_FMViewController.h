//
//  ONA_FMViewController.h
//  ONA FM
//
//  Created by jose luis sanchez on 02/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioStreamer.h"



@interface ONA_FMViewController : UIViewController <UIWebViewDelegate>{

	IBOutlet UIButton *playButton;
	IBOutlet UIToolbar *toolbar;

	AudioStreamer *streamer;
	IBOutlet UIWebView* webView;
	UIActivityIndicatorView *spinner;
	UIActivityIndicatorView *webSpinner;
	
}

@property (nonatomic,retain) IBOutlet UIButton *playButton;
@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic,retain) IBOutlet UIToolbar *toolbar;




-(IBAction) startTheAction:(id)sender;
-(void) queueTheWeb;
-(void) stopAudio;
-(void) runAudio;

@end

