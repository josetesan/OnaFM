/**
 * MyAdInsideViewController.m
 * AD-INSIDE-APP iPhone SDK.
 *
 * Interface Builder helper class implements AdInsideAppDelegate itself
 *
 */

#import "MyAdInsideViewController.h"

#import "AdInsideAppDelegateProtocol.h"
#import "AdInsideAppView.h"


@implementation MyAdInsideViewController

- (void)viewDidLoad {

	[super viewDidLoad];
	
		//Create new AdInsideView and assign self as adDelegate
	AdInsideAppView *adView = [[AdInsideAppView requestAdWithDelegate:self] retain];
	adView.frame = self.view.frame; //use self.view to get geometry and layout of the AdInside view
	[self setView:adView];
	
		//Retain the controller if its made outside of main NIB
		//In other case controller will be released by runloop
	[self retain];

	
}

- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark AdInsideAppDelegate protocol

/** 
 * Use this to provide a zone id for an ad request. 
 * Get a zone id from Ad Inside service provider http://www.ad-inside.com
 */
- (NSString *)zoneId {
        return @"1257432471546"; // ONA
}

/**
 * Use this to provide a domain url for an ad request.
 * Get a domain url from your Ad Inside service provider
 */
- (NSString *)adDomainUrl{
	return @"calais.ad-inside.com"; // ONA
	//	return @"demo-sdk.ad-inside.com";
}


-(BOOL)isAdLinkEmbedded:(AdInsideAppView *)aView {
	return YES;
}



-(BOOL)isAdAutoupdate:(AdInsideAppView *)aView {
	NSLog(@"isAdAutoupdate Entra por aqui");
	return NO;
}


-(BOOL)isAdAutoShow:(AdInsideAppView *)aView {
	NSLog(@"isAdAutoShow Entra por aqui");
	return NO;
}


-(BOOL)isAdAutohide:(AdInsideAppView *)aView {
	NSLog(@"isAdAutohide Entra por aqui");
	return YES;
}

-(NSTimeInterval)adAutoShowAfterTime:(AdInsideAppView *)aView {
	NSLog(@"adAutoShowAfterTime Entra por aqui");
	return 3.0F;
}

- (void)didReceiveAd:(AdInsideAppView *)adView {
	NSLog(@"Hemos recibido anuncio!");
}

- (void)didFailToReceiveAd:(AdInsideAppView *)adView {
	// your code to behave on new ad received
	NSLog(@"No se recibió anuncio !");
}

-(NSTimeInterval)adAutoupdateTime:(AdInsideAppView *)aView {
	NSLog(@"adAutoupdateTime Entra por aqui");
	return 10.0F;
}

/**
 * Implement to define time to hide an Ad banner. Max/Default = 5.0 seconds
 */
-(NSTimeInterval)adAutohideTime:(AdInsideAppView *)aView {
	NSLog(@"adAutohideTime Entra por aqui");
	return 3.0F;
}
@end
