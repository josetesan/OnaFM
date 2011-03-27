//
//  ONA_FMAppDelegate.m
//  ONA FM
//
//  Created by jose luis sanchez on 02/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "ONA_FMAppDelegate.h"
#import "ONA_FMViewController.h"



@implementation ONA_FMAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[window addSubview:[viewController view]];
	[window makeKeyAndVisible];
	return TRUE;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"Entering did become active");
	[viewController runAudio];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	NSLog(@"Entering will resign active");
		//[viewController stopAudio];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	NSLog(@"Did enter background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	NSLog(@"Will enter foreground");
	[viewController runAudio];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"Entering will terminate");
	[viewController stopAudio];
}

- (void)dealloc {

    [window release];
    [super dealloc];
}



@end
