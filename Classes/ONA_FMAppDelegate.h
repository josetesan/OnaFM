//
//  ONA_FMAppDelegate.h
//  ONA FM
//
//  Created by jose luis sanchez on 02/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
<<<<<<< HEAD
#import "CNSAdKit.h"
=======

>>>>>>> 1799322c5bfe3bbcf9f4f89befb48fb16f528a87



@class ONA_FMViewController;

@interface ONA_FMAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
    ONA_FMViewController *viewController;
<<<<<<< HEAD
    CNSSplashViewController *splashViewController;
=======
>>>>>>> 1799322c5bfe3bbcf9f4f89befb48fb16f528a87


}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ONA_FMViewController *viewController;

@end

