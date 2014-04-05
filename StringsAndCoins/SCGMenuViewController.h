//
//  SCGMenuViewController.h
//  StringsAndCoins
//
//  Created by David S Reich on 2/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGSettings.h"

@interface SCGMenuViewController : UIViewController

@property (strong, nonatomic) SCGSettings *settings;
@property (strong, nonatomic) IBOutlet UISegmentedControl *numberPlayersButton;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;

@end
