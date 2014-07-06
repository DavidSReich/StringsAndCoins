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
//    CGRect fullScreen = [[UIScreen mainScreen] bounds];

#if defined(LANDSCAPE_IPHONE)
    if (self.settings.isIphone)
    {
        CGRect fullScreen = [[UIScreen mainScreen] bounds];
        ((UITabBarController *)self.parentViewController).tabBar.hidden = YES;
        [[((UITabBarController *)self.parentViewController).view.subviews objectAtIndex:0] setFrame:fullScreen];
        [self.view setFrame:fullScreen];
        self.controller.boardView.userInteractionEnabled = YES; //make sure this is enabled
//        [self.view bringSubviewToFront:self.controller.boardView];
    }
#endif

    if (self.settings.newGame)
        [self.controller clearGameBoard];
    else if (self.settings.isIphone)
    {
        CGRect fullScreen = [[UIScreen mainScreen] bounds];
        [self.view.superview.superview.superview setFrame:fullScreen];
        [self.view.superview.superview setFrame:fullScreen];
        [self.view.superview setFrame:fullScreen];
        [self.view setFrame:fullScreen];
//        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Canvas1a_offwhite_1.png"]];
//        CGFloat rotation = -kPiOver2;
//        self.backgroundView.transform = CGAffineTransformMakeRotation(rotation);
//        self.backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
//        [self.view addSubview:self.backgroundView];
    }

//    [self.view setFrame:fullScreen];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.tabBarController.delegate = self;

    if (self.settings.newGame)
        [self startNewGame:self.settings];
#if defined(LANDSCAPE_IPHONE)
    else if (self.settings.isIphone)
    {
        self.controller.boardView.userInteractionEnabled = YES; //make sure this is enabled
        CGRect fullScreen = [[UIScreen mainScreen] bounds];
        CGRect fullScreenRotated = CGRectMake(0, 0, fullScreen.size.height, fullScreen.size.width);
        [self.view.superview setFrame:fullScreenRotated];
        [self.view setFrame:fullScreenRotated];
    }
#else
    else if (self.settings.isIphone)
    {
        [self.controller clearGameOver];
        CGRect fullScreen = [[UIScreen mainScreen] bounds];
//        fullScreen.origin.y += self.tabBarController.tabBar.bounds.size.height;
        [self.view.superview.superview.superview setFrame:fullScreen];
        [self.view.superview.superview setFrame:fullScreen];
        [self.view.superview setFrame:fullScreen];
        [self.view setFrame:fullScreen];
//        [self.backgroundView removeFromSuperview];
    }
#endif

    //always enable this, so it is not grayed out
    UIBarItem *resumeButton = [self.tabBarController.tabBar.items objectAtIndex:kResumeGameIndex];
    [resumeButton setEnabled:YES];

    self.settings.newGame = NO;
}

-(void) viewWillDisappear:(BOOL)animated
{
    ((UITabBarController *) self.parentViewController).tabBar.hidden = NO;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.tabBarController.delegate = nil;
}

- (void) startNewGame:(SCGSettings *)settings
{
	// Do any additional setup after loading the view, typically from a nib.
#if defined(LANDSCAPE_IPHONE)
    if (settings.isIphone)
    {
//        UIView *parent = self.view;
//        do {
//            NSLog(@"%@", parent);
//            parent = parent.superview;
//        } while (parent);

        CGRect fullScreen = [[UIScreen mainScreen] bounds];
        CGRect fullScreenRotated = CGRectMake(0, 0, fullScreen.size.height, fullScreen.size.width);
        [self.view.superview setFrame:fullScreenRotated];
        [self.view setFrame:fullScreenRotated];
        
//        NSLog(@"fullScreen: (%f %f; %f %f)", fullScreen.origin.x, fullScreen.origin.y, fullScreen.size.width, fullScreen.size.height);
//        parent = self.view;
//        do {
//            NSLog(@"%@", parent);
//            parent = parent.superview;
//        } while (parent);
    }
#else
    if (settings.isIphone)
    {
        CGFloat rotation = -kPiOver2;
        self.view.transform = CGAffineTransformMakeRotation(rotation);
        CGRect fullScreen = [[UIScreen mainScreen] bounds];
//        CGRect fullScreenRotated = CGRectMake(0, 0, fullScreen.size.height, fullScreen.size.width);
//        [self.view.superview setFrame:fullScreenRotated];
//        [self.view setFrame:fullScreenRotated];
        [self.view.superview setFrame:fullScreen];
        [self.view setFrame:fullScreen];
    }
#endif

    self.controller.boardView = self.view;
    self.controller.mainViewController = self;
    
#if defined(ADJUSTNUMBERROWSCOLS)
	SCGLevel *level = [SCGLevel levelWithType:settings.levelType andShape:settings.levelShape andSize:settings.levelSize
                           andNumberOfPlayers:settings.numberOfPlayers andNavigationController:self.navigationController
                                      andView:self.view andPalette:settings.paletteNumber andIphoneRunning:settings.isIphone
                             andToolbarHeight:self.tabBarController.tabBar.bounds.size.height andNumRows:settings.numRows andNumCols:settings.numCols];
#else
	SCGLevel *level = [SCGLevel levelWithType:settings.levelType andShape:settings.levelShape andSize:settings.levelSize
                andNumberOfPlayers:settings.numberOfPlayers andNavigationController:self.navigationController
                andView:self.view andPalette:settings.paletteNumber andIphoneRunning:settings.isIphone
                andToolbarHeight:self.tabBarController.tabBar.bounds.size.height];
#endif

    self.paletteGridView.settings = settings;
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
#if defined(LANDSCAPE_IPHONE)
        else if (self.settings.isIphone && [viewController isKindOfClass:[SCGMainViewController class]])
        {
            ((UITabBarController *)self.parentViewController).tabBar.hidden = YES;
            self.controller.boardView.userInteractionEnabled = YES;
        }
#endif
        if (self.settings.isIphone && self.settings.gameOver && ([viewController isKindOfClass:[SCGMainViewController class]]))
            [self.controller clearGameOver];
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
