//
//  SCGNewGameViewController.m
//  StringsAndCoins
//
//  Created by David S Reich on 15/05/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "constants.h"
#import "SCGNewGameViewController.h"
#import "SCGAppDelegate.h"

@interface SCGNewGameViewController ()

@end

@implementation SCGNewGameViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    SCGAppDelegate *appDelegate = (SCGAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.settings.gameInProgress = NO;
    appDelegate.settings.newGame = YES;


//    CGRect fullScreen = [[UIScreen mainScreen] bounds];
//    ((UITabBarController *)self.parentViewController).tabBar.hidden = YES;
//    [[((UITabBarController *)self.parentViewController).view.subviews objectAtIndex:0] setFrame:fullScreen];
//    [self.view setFrame:fullScreen];
    
    
    [self.tabBarController setSelectedIndex:kResumeGameIndex];
}

@end
