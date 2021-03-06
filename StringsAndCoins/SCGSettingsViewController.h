//
//  SCGSettingsViewController.h
//  StringsAndCoins
//
//  Created by David S Reich on 2/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGSettings.h"
#import "SCGButton.h"
#import "SCGPaletteGridView.h"

@interface SCGSettingsViewController : UIViewController <UITabBarControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet SCGSettings *settings;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *numberOfPlayersButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sizeButton;
@property (strong, nonatomic) IBOutlet UIView *layoutGridView;
@property (strong, nonatomic) IBOutlet SCGButton *trianglesButton;
@property (strong, nonatomic) IBOutlet SCGButton *squaresButton;
@property (strong, nonatomic) IBOutlet SCGButton *hexagonsButton;
@property (strong, nonatomic) IBOutlet SCGPaletteGridView *paletteGridView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *aiSpeedButton;

- (void) resetButtons;
- (void) updateShapeControls;
- (void) gridCellClicked:(UITextField *)textField;

@end
