//
//  SCGSettingsViewController.m
//  StringsAndCoins
//
//  Created by David S Reich on 2/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGSettingsViewController.h"
#import "SCGAppDelegate.h"
#import "SCGButton.h"
#import "SCGNewGameViewController.h"
#import "SCGMainViewController.h"
#import "constants.h"

@interface SCGSettingsViewController ()

@end

@implementation SCGSettingsViewController
{
    SCGSettings *originalSettings;
}

@synthesize typeButton;
@synthesize sizeButton;
@synthesize numberOfPlayersButton;
@synthesize trianglesButton;
@synthesize squaresButton;
@synthesize hexagonsButton;
@synthesize paletteGridView;


- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.title = @"Settings";
//        self.view.layer.borderWidth = 3.f;
//        self.view.layer.borderColor = [UIColor redColor].CGColor;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.title = @"Settings";
//    self.view.layer.borderWidth = 3.f;
//    self.view.layer.borderColor = [UIColor redColor].CGColor;

    SCGAppDelegate *appDelegate = (SCGAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.settings = appDelegate.settings;
    self.paletteGridView.settings = self.settings;
    
    originalSettings = [[SCGSettings alloc] init];
    originalSettings.levelType = self.settings.levelType;
    originalSettings.levelShape = self.settings.levelShape;
    originalSettings.levelSize = self.settings.levelSize;
    originalSettings.numberOfPlayers = self.settings.numberOfPlayers;
    originalSettings.paletteNumber = self.settings.paletteNumber;

//    self.title = @"Settings";

    CGFloat fontSize = self.settings.isIphone ? 12.0f : 23.0f;
    UIFont *btnFont = [UIFont systemFontOfSize:fontSize];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:btnFont forKey:NSFontAttributeName];
    [self.typeButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.sizeButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.numberOfPlayersButton setTitleTextAttributes:attributes forState:UIControlStateNormal];

    for (SCGButton *button in self.view.subviews)
    {
        if ([button isKindOfClass:[SCGButton class]])
        {
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor blueColor].CGColor;
            button.layer.cornerRadius = 5;
            button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        }
    }

    for (UITextField *textField in self.layoutGridView.subviews)
    {
        if ([textField isKindOfClass:[UITextField class]])
        {
            textField.delegate = self;
        }
    }

    if (self.settings.isIphone4)
    {
        for (UIView *view in self.view.subviews)
        {
            CGRect r = view.frame;
            view.frame = CGRectMake(r.origin.x, r.origin.y - 40, r.size.width, r.size.height);
        }
    }

    [self resetButtons];
#if defined(ADJUSTNUMBERROWSCOLS)
    self.rowStepper.value = self.settings.numRows;
    self.colStepper.value = self.settings.numCols;
    [self rowStepperChanged:nil];
    [self colStepperChanged:nil];
#endif
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
    [self updateShapeControls];
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
        if (self.settings.levelType == BoxesType)
            typeButton.selectedSegmentIndex = 0;
        else    //coins
            typeButton.selectedSegmentIndex = 1;
    }

    if (sizeButton)
    {
        if (self.settings.levelSize == SmallSize)
            sizeButton.selectedSegmentIndex = 0;
        else if (self.settings.levelSize == MediumSize)
            sizeButton.selectedSegmentIndex = 1;
        else    //large
            sizeButton.selectedSegmentIndex = 2;
    }

    if (self.settings.levelShape == SquareShape)
    {
        squaresButton.selected = YES;
        trianglesButton.selected = NO;
        hexagonsButton.selected = NO;
    }
    else if (self.settings.levelShape == TriangleShape)
    {
        squaresButton.selected = NO;
        trianglesButton.selected = YES;
        hexagonsButton.selected = NO;
    }
    else    //hexagons
    {
        squaresButton.selected = NO;
        trianglesButton.selected = NO;
        hexagonsButton.selected = YES;
    }

    [self updateShapeControls];

    if (numberOfPlayersButton)
    {
        if (self.settings.numberOfPlayers == 2)
            numberOfPlayersButton.selectedSegmentIndex = 0;
        else if (self.settings.numberOfPlayers == 3)
            numberOfPlayersButton.selectedSegmentIndex = 1;
        else    //4 players
            numberOfPlayersButton.selectedSegmentIndex = 2;
    }

    [self.paletteGridView updatePaletteSelection];
}

- (IBAction) resetButtonTouched:(UIButton *)sender
{
    self.settings.levelType = originalSettings.levelType;
    self.settings.levelShape = originalSettings.levelShape;
    self.settings.levelSize = originalSettings.levelSize;
    self.settings.numberOfPlayers = originalSettings.numberOfPlayers;
    self.settings.paletteNumber = originalSettings.paletteNumber;
    
    [self resetButtons];
}

- (IBAction) defaultButtonTouched:(id)sender
{
    BOOL gameInProgress = self.settings.gameInProgress;
    [self.settings setDefaultSettings];
    self.settings.gameInProgress = gameInProgress;
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

    [self updateShapeControls];
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

- (IBAction) shapeButtonTouched:(id)sender
{
    if (sender == squaresButton)
        self.settings.levelShape = SquareShape;
    else if (sender == trianglesButton)
        self.settings.levelShape = TriangleShape;
    else
        self.settings.levelShape = HexagonShape;

    for (SCGButton *button in self.view.subviews)
    {
        if ([button isKindOfClass:[SCGButton class]])
        {
            if (button == sender)
                button.selected = YES;
            else
                button.selected = NO;
        }
    }

    [self updateShapeControls];
}

- (void) updateShapeControls
{
    for (SCGButton *button in self.view.subviews)
    {
        if ([button isKindOfClass:[SCGButton class]])
        {
            if (button.selected)
            {
                button.titleLabel.textColor = [UIColor lightGrayColor];
                button.backgroundColor = [UIColor blueColor];
            }
            else
            {
                button.titleLabel.textColor = [UIColor blueColor];
                button.backgroundColor = [UIColor clearColor];
            }
        }
    }

    for (UITextField *textField in self.layoutGridView.subviews)
    {
        if ([textField isKindOfClass:[UITextField class]])
        {
            LevelShape levelShape = SquareShape;
            if (textField.tag < 3)
                levelShape = TriangleShape;
            else if (textField.tag < 6)
                levelShape = SquareShape;
            else
                levelShape = HexagonShape;

            int sizeIndex = 0;
            if (textField.tag % 3 == 0)
                sizeIndex = 0;
            else if (textField.tag % 3 == 1)
                sizeIndex = 1;
            else
                sizeIndex = 2;

            if ((levelShape == self.settings.levelShape) && (sizeIndex == sizeButton.selectedSegmentIndex))
            {
                textField.textColor = [UIColor lightGrayColor];
                textField.backgroundColor = [UIColor blueColor];
            }
            else
            {
                textField.textColor = [UIColor blueColor];
                textField.backgroundColor = [UIColor clearColor];
            }
        }
    }
}

- (void) gridCellClicked:(UITextField *)textField
{
    if (textField.tag % 3 == 0)
        sizeButton.selectedSegmentIndex = 0;
    else if (textField.tag % 3 == 1)
        sizeButton.selectedSegmentIndex = 1;
    else
        sizeButton.selectedSegmentIndex = 2;

    [self sizeButtonChanged:textField];
    
    if (textField.tag < 3)
        [self shapeButtonTouched:trianglesButton];
    else if (textField.tag < 6)
        [self shapeButtonTouched:squaresButton];
    else
        [self shapeButtonTouched:hexagonsButton];
    
//    [self updateShapeControls];
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    [self gridCellClicked:textField];
    return NO;
}

- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (tabBarController == self.tabBarController)
    {
        if (self.settings.gameInProgress)
        {
            //if New Game was pressed
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
                //resume
            }
        }
        else
        {
            if ([viewController isKindOfClass:[SCGNewGameViewController class]])
            {
                //we're starting a new game ... make the settings the new original
                originalSettings.levelType = self.settings.levelType;
                originalSettings.levelShape = self.settings.levelShape;
                originalSettings.levelSize = self.settings.levelSize;
                originalSettings.numberOfPlayers = self.settings.numberOfPlayers;
                originalSettings.paletteNumber = self.settings.paletteNumber;
                return YES;
            }
        }

        //we're not going to current game or new game, so throw away any setting changes
        //if we have clicked on the settings button don't do anything, we're already here
        if (![viewController isKindOfClass:[SCGSettingsViewController class]])
            [self resetButtonTouched:nil];
        
    }

    return YES;
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
//        [self resetButtonTouched:nil];
        //we're starting a new game ... make the settings the new original
        originalSettings.levelType = self.settings.levelType;
        originalSettings.levelShape = self.settings.levelShape;
        originalSettings.levelSize = self.settings.levelSize;
        originalSettings.numberOfPlayers = self.settings.numberOfPlayers;
        originalSettings.paletteNumber = self.settings.paletteNumber;

        self.settings.gameInProgress = NO;
        self.settings.newGame = YES;
        [self.tabBarController setSelectedIndex:alertView.tag];
    }
}

- (IBAction)rowStepperChanged:(id)sender
{
#if defined(ADJUSTNUMBERROWSCOLS)
    self.settings.numRows = self.rowStepper.value;
    self.rowCountLabel.text = [NSString stringWithFormat:@"%d", self.settings.numRows];
#endif
}

- (IBAction)colStepperChanged:(id)sender
{
#if defined(ADJUSTNUMBERROWSCOLS)
    self.settings.numCols = self.colStepper.value;
    self.colCountLabel.text = [NSString stringWithFormat:@"%d", self.settings.numCols];
#endif
}

@end
