//
//  SCGMainViewController.m
//  StringsAndCoins
//
//  Created by David S Reich on 1/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "constants.h"
#import "SCGMainViewController.h"
#import "SCGBoardController.h"
#import "SCGSettings.h"
#import "SCGAppDelegate.h"
#import "SCGNewGameViewController.h"
#import "SCGGameOverViewController.h"

@interface SCGMainViewController ()
@property (strong, nonatomic) SCGBoardController *controller;
@end

@implementation SCGMainViewController

- (instancetype) initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self != nil)
    {
        //create the game controller
        self.controller = [[SCGBoardController alloc] init];
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    SCGAppDelegate *appDelegate = (SCGAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.settings = appDelegate.settings;
}

- (void) viewWillAppear:(BOOL)animated
{
    if (self.settings.newGame)
        [self.controller clearGameBoard];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.tabBarController.delegate = self;

    if (self.settings.newGame)
        [self startNewGame:self.settings];

    //always enable this, so it is not grayed out
    UIBarItem *resumeButton = [self.tabBarController.tabBar.items objectAtIndex:kResumeGameIndex];
    [resumeButton setEnabled:YES];

    self.settings.newGame = NO;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.delegate = nil;
}

- (void) startNewGame:(SCGSettings *)settings
{    
	// Do any additional setup after loading the view, typically from a nib.
    self.controller.boardView = self.view;
    self.controller.mainViewController = self;

	SCGLevel *level = [SCGLevel levelWithType:settings.levelType andShape:settings.levelShape andSize:settings.levelSize
                           andNumberOfPlayers:settings.numberOfPlayers andNavigationController:self.navigationController
                           andView:self.view andPalette:settings.paletteNumber];
    
	[self.controller setupGameBoard:level];
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
        if (self.settings.gameInProgress && ([viewController isKindOfClass:[SCGNewGameViewController class]]))
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
    }

    return YES;
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        self.settings.gameInProgress = NO;
        self.settings.newGame = YES;
        //if there's any delays, just directly call clearGameBoard and startNewGame
        [self.tabBarController setSelectedIndex:alertView.tag];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GameOver"])
    {
        SCGGameOverViewController *gameOverController = segue.destinationViewController;
        gameOverController.players = [self.controller getPlayers];
    }
}

@end
