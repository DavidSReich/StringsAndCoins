//
//  SCGMainViewController.h
//  StringsAndCoins
//
//  Created by David S Reich on 1/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGFlipsideViewController.h"
#import "SCGLevel.h"
#import "SCGSettings.h"

@interface SCGMainViewController : UIViewController <SCGFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet SCGSettings *settings;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

- (void) startNewGame:(SCGSettings *)settings;

@end
