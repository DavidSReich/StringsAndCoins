//
//  SCGTabBarController.m
//  StringsAndCoins
//
//  Created by David S Reich on 10/04/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "constants.h"
#import "SCGTabBarController.h"
//#import "SCGSettingsViewController.h"
#import "SCGMainViewController.h"

@interface SCGTabBarController ()

@end

@implementation SCGTabBarController

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

    self.selectedIndex = kNewGameIndex;

//    int itemIdx = 0;
//    for (UITabBarItem *tabBarItem in [self.tabBar items])
//    {
//        if (itemIdx == kSettingsIndex)
//            tabBarItem.title = kSettingsName;
//        else if (itemIdx == kResumeGameIndex)
//            tabBarItem.title = kGameBoardName;
//        else if (itemIdx == kNewGameIndex)
//            tabBarItem.title = kNewGameName;
//        else if (itemIdx == kAboutBoxIndex)
//            tabBarItem.title = kAboutName;
//        itemIdx++;
//    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
