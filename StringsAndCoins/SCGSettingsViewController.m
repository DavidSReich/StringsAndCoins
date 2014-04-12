//
//  SCGSettingsViewController.m
//  StringsAndCoins
//
//  Created by David S Reich on 2/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGSettingsViewController.h"
#import "SCGAppDelegate.h"

@interface SCGSettingsViewController ()

@end

@implementation SCGSettingsViewController
{
    SCGSettings *originalSettings;
}

@synthesize typeButton;
@synthesize shapeButton;
@synthesize sizeButton;
@synthesize numberOfPlayersButton;


- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Settings";
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    SCGAppDelegate *appDelegate = (SCGAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.settings = appDelegate.settings;
    
    originalSettings = [[SCGSettings alloc] init];
    originalSettings.levelType = self.settings.levelType;
    originalSettings.levelShape = self.settings.levelShape;
    originalSettings.levelSize = self.settings.levelSize;
    originalSettings.numberOfPlayers = self.settings.numberOfPlayers;

    self.title = @"Settings";

    [self resetButtons];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.delegate = self;
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

- (void) resetButtons
{
    if (typeButton)
    {
        if (originalSettings.levelType == BoxesType)
            typeButton.selectedSegmentIndex = 0;
        else    //coins
            typeButton.selectedSegmentIndex = 1;
    }

    if (sizeButton)
    {
        if (originalSettings.levelSize == SmallSize)
            sizeButton.selectedSegmentIndex = 0;
        else if (originalSettings.levelSize == MediumSize)
            sizeButton.selectedSegmentIndex = 1;
        else    //large
            sizeButton.selectedSegmentIndex = 2;
    }

    if (shapeButton)
    {
        if (originalSettings.levelShape == SquareShape)
            shapeButton.selectedSegmentIndex = 0;
        else if (originalSettings.levelShape == TriangleShape)
            shapeButton.selectedSegmentIndex = 1;
        else    //hexagon
            shapeButton.selectedSegmentIndex = 2;
    }

    if (numberOfPlayersButton)
    {
        if (self.settings.numberOfPlayers == 2)
            numberOfPlayersButton.selectedSegmentIndex = 0;
        else if (self.settings.numberOfPlayers == 3)
            numberOfPlayersButton.selectedSegmentIndex = 1;
        else    //4 players
            numberOfPlayersButton.selectedSegmentIndex = 2;
    }
}

- (IBAction) resetButtonTouched:(id)sender
{
    [self resetButtons];
}

- (IBAction) typeButtonChanged:(id)sender
{
    if (typeButton.selectedSegmentIndex == 0)
        self.settings.levelType = BoxesType;
    else
        self.settings.levelType = CoinsType;
}

- (IBAction) sizeButtonChanged:(id)sender
{
    if (sizeButton.selectedSegmentIndex == 0)
        self.settings.levelSize = SmallSize;
    else if (sizeButton.selectedSegmentIndex == 1)
        self.settings.levelSize = MediumSize;
    else
        self.settings.levelSize = LargeSize;
}

- (IBAction) shapeButtonChanged:(id)sender
{
    if (shapeButton.selectedSegmentIndex == 0)
        self.settings.levelShape = SquareShape;
    else if (shapeButton.selectedSegmentIndex == 1)
        self.settings.levelShape = TriangleShape;
    else
        self.settings.levelShape = HexagonShape;
}

- (IBAction) numberOfPlayersChanged:(id)sender
{
    if (numberOfPlayersButton.selectedSegmentIndex == 0)
        self.settings.numberOfPlayers = 2;
    else if (numberOfPlayersButton.selectedSegmentIndex == 1)
        self.settings.numberOfPlayers = 3;
    else
        self.settings.numberOfPlayers = 4;
}

- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController == self.tabBarController)
    {
        if (viewController != self)
        {
            self.settings.startNewGame = YES;
        }
    }
}

@end
