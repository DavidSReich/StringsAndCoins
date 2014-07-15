//
//  SCGAboutBoxViewController.m
//  StringsAndCoins
//
//  Created by David S Reich on 18/05/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "constants.h"
#import "SCGAboutBoxViewController.h"
#import "SCGAppDelegate.h"
#import "SCGNewGameViewController.h"
#import "SCGMainViewController.h"

@interface SCGAboutBoxViewController ()

@end

@implementation SCGAboutBoxViewController

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

    SCGAppDelegate *appDelegate = (SCGAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.settings = appDelegate.settings;
    if (self.settings.isIphone4)
    {
        CGRect r = self.iconLicenseLabel.frame;
        self.iconLicenseLabel.frame = CGRectMake(r.origin.x, r.origin.y - 88, r.size.width, r.size.height);
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.delegate = self;
    UIBarItem *resumeButton = [self.tabBarController.tabBar.items objectAtIndex:kResumeGameIndex];
    if (self.settings.gameInProgress || self.settings.gameOver)
        [resumeButton setEnabled:YES];
    else
        [resumeButton setEnabled:NO];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.delegate = nil;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (tabBarController == self.tabBarController)
    {
        //if New Game was pressed
        if (self.settings.gameInProgress)
        {
            if ([viewController isKindOfClass:[SCGNewGameViewController class]])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Stop the current game?", @"")
                                                                    message:NSLocalizedString(@"This will stop the current game.  Are you sure you want to start a new game?", @"")
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                          otherButtonTitles:NSLocalizedString(@"New Game", @""), nil];
                alertView.tag = [tabBarController.viewControllers indexOfObject:viewController];
                [alertView show];
                return NO;
            }
            else if ([viewController isKindOfClass:[SCGMainViewController class]])
            {
                //all done elsewhere
            }
        }
        else
        {
            if ([viewController isKindOfClass:[SCGNewGameViewController class]])
            {
                //all done elsewhere
            }
        }
    }

    return YES;
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        self.settings.gameInProgress = NO;
        self.settings.newGame = YES;
        [self.tabBarController setSelectedIndex:alertView.tag];
    }
}

@end
