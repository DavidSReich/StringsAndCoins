//
//  SCGMainViewController.h
//  StringsAndCoins
//
//  Created by David S Reich on 1/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGLevel.h"
#import "SCGSettings.h"
#import "SCGPaletteGridView.h"

@interface SCGMainViewController : UIViewController <UITabBarControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet SCGSettings *settings;
@property (strong, nonatomic) IBOutlet SCGPaletteGridView *paletteGridView;
//@property (strong, nonatomic) UIImageView *backgroundView;

- (void) startNewGame:(SCGSettings *)settings;

@end
