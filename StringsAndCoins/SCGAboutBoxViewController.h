//
//  SCGAboutBoxViewController.h
//  StringsAndCoins
//
//  Created by David S Reich on 18/05/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGSettings.h"

@interface SCGAboutBoxViewController : UIViewController

@property (strong, nonatomic) IBOutlet SCGSettings *settings;
@property (strong, nonatomic) IBOutlet UILabel *iconLicenseLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end
