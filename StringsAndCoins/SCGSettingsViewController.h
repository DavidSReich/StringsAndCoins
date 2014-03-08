//
//  SCGSettingsViewController.h
//  StringsAndCoins
//
//  Created by David S Reich on 2/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGSettings.h"

@interface SCGSettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet SCGSettings *settings;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *shapeButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sizeButton;

- (void) resetButtons;
@end
