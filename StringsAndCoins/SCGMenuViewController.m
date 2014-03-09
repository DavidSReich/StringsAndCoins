//
//  SCGMenuViewController.m
//  StringsAndCoins
//
//  Created by David S Reich on 2/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGMenuViewController.h"
#import "SCGSettingsViewController.h"
#import "SCGMainViewController.h"

@interface SCGMenuViewController ()

@end

@implementation SCGMenuViewController

@synthesize numberPlayersButton;

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
    if (!self.settings)
    {
        self.settings = [[SCGSettings alloc] init];
        self.settings.levelType = BoxesType;
        self.settings.levelShape = SquareShape;
        self.settings.levelSize = SmallSize;
        self.settings.numberOfPlayers = 2;
        self.numberPlayersButton.selectedSegmentIndex = 0;  //start with 2 player
    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)numberOfPlayersButtonChanged:(id)sender {
    if (numberPlayersButton.selectedSegmentIndex == 0)
        self.settings.numberOfPlayers = 2;
    else if (numberPlayersButton.selectedSegmentIndex == 1)
        self.settings.numberOfPlayers = 3;
    else
        self.settings.numberOfPlayers = 4;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSLog(@"prepareForSegue: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"SCGSettingsSegue"])
    {
        SCGSettingsViewController *settingsViewController = segue.destinationViewController;
        settingsViewController.settings = self.settings;
    }
    else if([segue.identifier isEqualToString:@"SCGNewGameSegue"])
    {
        SCGMainViewController *mainViewController = segue.destinationViewController;
        mainViewController.settings = self.settings;
    }
}

@end
