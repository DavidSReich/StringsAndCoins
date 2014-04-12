//
//  SCGMainViewController.h
//  StringsAndCoins
//
//  Created by David S Reich on 1/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGLevel.h"
#import "SCGSettings.h"

@interface SCGMainViewController : UIViewController <UITabBarControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet SCGSettings *settings;

- (void) startNewGame:(SCGSettings *)settings;

@end
