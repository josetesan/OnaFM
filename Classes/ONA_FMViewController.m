//
//  ONA_FMViewController.m
//  ONA FM
//
//  Created by jose luis sanchez on 02/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "ONA_FMViewController.h"
#import "ONA_FMAppDelegate.h"
#import <MediaPlayer/MPVolumeView.h>

@implementation ONA_FMViewController


@synthesize webView;
@synthesize playButton;
@synthesize toolbar;



-(void) stopAudio {
	[streamer stop];
	
}

-(void) runAudio {
	[streamer start];
}
//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//

#pragma mark -
#pragma mark AudioStreamer delegates
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
		 removeObserver:self
		 name:ASStatusChangedNotification
		 object:streamer];
		
		
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
	if (streamer)
	{
		return;
	}
	
	[self destroyStreamer];
	
	NSString *escapedValue =
	[(NSString *)CFURLCreateStringByAddingPercentEscapes(nil,
														 (CFStringRef)@"http://ona.nsservidor.com:8000/stream",
														 nil,
														 nil,
														 kCFStringEncodingUTF8)
	 autorelease];

	
	 NSURL *url = [NSURL URLWithString:escapedValue];
	 streamer = [[AudioStreamer alloc] initWithURL:url];
	
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(playbackStateChanged:)
	 name:ASStatusChangedNotification
	 object:streamer];
}

// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		[spinner startAnimating];
		[playButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:0];
	}
	else if ([streamer isPlaying])
	{
		[spinner stopAnimating];
		[playButton setImage:[UIImage imageNamed:@"pausebutton.png"] forState:0];
	}
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
		[playButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:0];
	}
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


#pragma mark -
#pragma mark Main methods

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	
	[playButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:0];
	
	
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[spinner setCenter:CGPointMake(160, 380)]; 
	// spinner is not visible until started
	[self.view addSubview:spinner];
	[spinner release];
	
	webSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[webSpinner setCenter:CGPointMake(160, 200)];
	// spinner is not visible until started
	[self.view addSubview:webSpinner];
	[webSpinner release];
	
	// let's play the sound
	[self startTheAction:nil];
	// once we got the music, show the screen
	//Load the request in the UIWebView.

	[self queueTheWeb];
	[self.toolbar setFrame:CGRectMake(0, 0	, 320, 30)];
	[self.toolbar setHidden:YES];
    
    [super viewDidLoad];

 }



- (void)adEngineDidReceiveBanner:(NSDictionary *)userInfo {
    NSLog(@"Data means %@",userInfo);
}

- (void)adEngineDidFail:(NSString *)identifier {
    NSLog(@"Error is %@",identifier);
}

- (void) queueTheWeb {

		
		/* Operation Queue init (autorelease) */
		NSOperationQueue *queue = [NSOperationQueue new];
		
		/* Create our NSInvocationOperation to call loadDataWithOperation, passing in nil */
		NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
																		  selector:@selector(loadTheWeb)
																		  object:nil];
		
		/* Add the operation to the queue */
		[queue addOperation:operation];
		[operation release];
	
}


- (void) loadTheWeb {
	
	NSString *urlAddress = @"http://www.ona-fm.cat/streaming-iphone/streaming.php";
	
	
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:urlAddress]
											 cachePolicy:NSURLRequestReturnCacheDataElseLoad
											 timeoutInterval: 10.0]; 
	


	[self.webView loadRequest:requestObj];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction) startTheAction:(id) sender {
	if ([playButton.currentImage isEqual:[UIImage imageNamed:@"playbutton.png"]]) {

		[self createStreamer];
		[streamer start];
		MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:
									 CGRectMake(0, 378, 320, 49)] autorelease];
	//	volumeView.center = CGPointMake(160,445);
		[volumeView sizeToFit];
		[self.view addSubview:volumeView];

		[playButton setImage:[UIImage imageNamed:@"pausebutton.png"] forState:0];

	}
	else {
		[streamer stop];
		[playButton setImage:[UIImage imageNamed:@"playbutton.png"] forState:0];

	}

}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_3_0 
	[spinner release];
	[playButton release];
#endif
	// Release any cached data, images, etc that aren't in use.
}

 #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_0 
- (void)viewDidUnload {
	
	[spinner release];
	[playButton release];

	[super viewDidUnload];
}
#endif


- (void)dealloc {
	
	[playButton dealloc];
    [super dealloc];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[webSpinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)thisWebView
{
	NSString * urlString = [[thisWebView.request URL] absoluteString];
	if ([urlString isEqualToString:@"http://www.ona-fm.cat/streaming-iphone/streaming.php"]) {
		[self.toolbar setHidden:YES];
	} else [self.toolbar setHidden:NO];

	
	[webSpinner stopAnimating];
}

#pragma mark -
#pragma mark AdView


@end
