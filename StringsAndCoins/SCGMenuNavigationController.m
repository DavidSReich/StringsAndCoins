//
//  SCGMenuNavigationController.m
//  StringsAndCoins
//
//  Created by David S Reich on 2/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGMenuNavigationController.h"

@interface SCGMenuNavigationController ()

@end

@implementation SCGMenuNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIViewController *firstViewController = [[self viewControllers] objectAtIndex:0];
    if ([[self navigationBar] respondsToSelector:@selector(setBarTintColor:)])
        [[self navigationBar] setBarTintColor:firstViewController.view.backgroundColor];
    else
        [[self navigationBar] setTintColor:firstViewController.view.backgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
