//
//  SCGGameOverViewController.h
//  StringsAndCoins
//
//  Created by David S Reich on 16/05/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCGGameOverViewController : UIViewController

@property (weak, nonatomic) NSMutableArray *players;

@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UIView *scoreGrid;

@end
