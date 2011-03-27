//
//  ONA_FMAppDelegate.m
//  ONA FM
//
//  Created by jose luis sanchez on 02/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "ONA_FMAppDelegate.h"
#import "ONA_FMViewController.h"



<<<<<<< HEAD

=======
>>>>>>> 1799322c5bfe3bbcf9f4f89befb48fb16f528a87
@implementation ONA_FMAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
<<<<<<< HEAD
    splashViewController = [[CNSSplashViewController alloc] initWithNibName:@"CNSSplashView" bundle:nil];
    splashViewController.adSpaceID = @"7676"; 
    splashViewController.clickable = YES;
=======

>>>>>>> 1799322c5bfe3bbcf9f4f89befb48fb16f528a87
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

<<<<<<< HEAD
    [splashViewController release];
=======
>>>>>>> 1799322c5bfe3bbcf9f4f89befb48fb16f528a87
    [window release];
    [super dealloc];
}



@end
