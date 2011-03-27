//
//  SplashViewController.h
//  AdSDK
//
//  Created by Thomas Dohmke on 29.03.10.
//  Copyright Codenauts UG 2010. All rights reserved.
//

#import "CNSInterstitialViewController.h"

@interface CNSSplashViewController : CNSInterstitialViewController {
  UIButton *cancelButton;
  UIButton *continueButton;
	UIView *alertView;
}

@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *continueButton;
@property (nonatomic, retain) IBOutlet UIView *alertView;

- (IBAction)continueButtonTapped:(id)sender;

@end
