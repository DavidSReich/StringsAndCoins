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

    for (UIButton *button in self.view.subviews)
    {
        if ([button isKindOfClass:[SCGButton class]])
        {
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor blueColor].CGColor;
            button.layer.cornerRadius = 5;
            button.titleLabel.font = [UIFont systemFontOfSize:13];
        }
    }

    for (UITextField *textField in self.layoutGridView.subviews)
    {
        if ([textField isKindOfClass:[UITextField class]])
        {
            textField.delegate = self;
        }
    }

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

    for (UIButton *button in self.view.subviews)
    {
        if ([button isKindOfClass:[SCGButton class]])
            button.selected = NO;
    }
    
    if (originalSettings.levelShape == SquareShape)
        squaresButton.selected = YES;
    else if (originalSettings.levelShape == TriangleShape)
        trianglesButton.selected = YES;
    else    //hexagons
        hexagonsButton.selected = YES;

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

    for (UIButton *button in self.view.subviews)
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
    for (UIButton *button in self.view.subviews)
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
