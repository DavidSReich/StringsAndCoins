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
        self.settings.levelType = CoinsType;
        self.settings.levelShape = TriangleShape;
        self.settings.levelSize = MediumSize;
    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
