//
//  SCGFlipsideViewController.h
//  StringsAndCoins
//
//  Created by David S Reich on 1/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCGFlipsideViewController;

@protocol SCGFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(SCGFlipsideViewController *)controller;
@end

@interface SCGFlipsideViewController : UIViewController

@property (weak, nonatomic) id <SCGFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
