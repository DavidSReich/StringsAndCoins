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

@interface SCGMainViewController ()
@property (strong, nonatomic) SCGBoardController *controller;
@end

@implementation SCGMainViewController

- (instancetype) initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
//    self = [super init];
    if (self != nil) {
        //create the game controller
        self.controller = [[SCGBoardController alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self startNewGame:BoxesType andShape:SquareShape andSize:MediumSize];
    [self startNewGame:self.settings];
}

- (void) startNewGame:(SCGSettings *)settings
{
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Strings & Coins";
    
    //	SCGLevel *level = [SCGLevel levelWithType:CoinsType andShape:SquareShape andSize:LargeSize];
    //	SCGLevel *level = [SCGLevel levelWithType:BoxesType andShape:SquareShape andSize:LargeSize];
    //	SCGLevel *level = [SCGLevel levelWithType:BoxesType andShape:TriangleShape andSize:MediumSize];
    //	SCGLevel *level = [SCGLevel levelWithType:BoxesType andShape:TriangleShape andSize:SmallSize];
    //	SCGLevel *level = [SCGLevel levelWithType:BoxesType andShape:HexagonShape andSize:MediumSize];
	//  SCGLevel *level = [SCGLevel levelWithType:CoinsType andShape:HexagonShape andSize:MediumSize];
	SCGLevel *level = [SCGLevel levelWithType:settings.levelType andShape:settings.levelShape andSize:settings.levelSize];
    
    //add game layer
    UIView *gameLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, level.screenHeight, level.screenWidth)];
    [self.view addSubview: gameLayer];
    //    gameLayer.backgroundColor = [UIColor yellowColor];
    
    self.controller.boardView = gameLayer;
    
	[self.controller setupGameBoard:level];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(SCGFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
