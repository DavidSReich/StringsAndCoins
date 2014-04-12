//
//  SCGMainViewController.m
//  StringsAndCoins
//
//  Created by David S Reich on 1/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGMainViewController.h"
#import "SCGBoardController.h"
#import "SCGSettings.h"
#import "SCGAppDelegate.h"

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
        self.title = @"Start Game";
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    SCGAppDelegate *appDelegate = (SCGAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.settings = appDelegate.settings;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.settings.startNewGame)
        [self.controller clearGameBoard];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.delegate = self;

    if (self.settings.startNewGame)
    {
        self.settings.startNewGame = NO;
        [self startNewGame:self.settings];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.delegate = nil;
}

- (void) startNewGame:(SCGSettings *)settings
{    
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Strings & Coins";

    self.controller.boardView = self.view;
    
    //	SCGLevel *level = [SCGLevel levelWithType:CoinsType andShape:SquareShape andSize:LargeSize];
    //	SCGLevel *level = [SCGLevel levelWithType:BoxesType andShape:SquareShape andSize:LargeSize];
    //	SCGLevel *level = [SCGLevel levelWithType:BoxesType andShape:TriangleShape andSize:MediumSize];
    //	SCGLevel *level = [SCGLevel levelWithType:BoxesType andShape:TriangleShape andSize:SmallSize];
    //	SCGLevel *level = [SCGLevel levelWithType:BoxesType andShape:HexagonShape andSize:MediumSize];
	//  SCGLevel *level = [SCGLevel levelWithType:CoinsType andShape:HexagonShape andSize:MediumSize];
	SCGLevel *level = [SCGLevel levelWithType:settings.levelType andShape:settings.levelShape andSize:settings.levelSize
                           andNumberOfPlayers:settings.numberOfPlayers andNavigationController:self.navigationController andView:self.view];
    
    //add game layer
//    UIView *gameLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, level.screenHeight, level.screenWidth)];
//    [self.view addSubview: gameLayer];
//
//    self.controller.boardView = gameLayer;

//    self.controller.boardView = self.view;
    
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
        if (viewController != self)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Leave the game?", @"")
                        message:NSLocalizedString(@"Are you sure you want to leave the game?", @"")
                        delegate:self
                        cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                        otherButtonTitles:NSLocalizedString(@"Leave", @""), nil];
            
            alertView.tag = [tabBarController.viewControllers indexOfObject:viewController];
            [alertView show];
        }
    }

    return NO;
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [self.tabBarController setSelectedIndex:alertView.tag];
    }
}

@end
