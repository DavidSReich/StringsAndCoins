//
//  SCGNavigationController.m
//  StringsAndCoins
//
//  Created by David S Reich on 1/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGNavigationController.h"
#import "SCGMainViewController.h"

@interface SCGNavigationController () <UIActionSheetDelegate>

@end

@implementation SCGNavigationController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
//        self.levelType = CoinsType;
//        self.levelShape = TriangleShape;
//        self.levelSize = MediumSize;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////show tha game menu on app start
//-(void) viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
////    [self showMainMenu];
//}
//
//- (void) showMainMenu
//{
//    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do?"
//            delegate:self
//            cancelButtonTitle:@"Cancel"
//            destructiveButtonTitle:nil
//            otherButtonTitles:@"New game", @"Settings", nil];
//
//    [actionSheet showInView:self.view];
//}
//
//-(void) actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    //outside the menu
//    if (buttonIndex == -1)
//    {
//        [self showMainMenu];
//        return;
//    }
//
//    if (buttonIndex == actionSheet.firstOtherButtonIndex)
//    {
//        if (self.mainViewController == nil)
//            self.mainViewController = [[SCGMainViewController alloc] initWithCoder:nil];
//        [self.mainViewController startNewGame:self.levelType andShape:self.levelShape andSize:self.levelSize];
//
//        [self pushViewController:self.mainViewController animated:YES];
////        if (self.navigationController)
////            [self.navigationController pushViewController:self.mainViewController animated:YES];
//
////        [self performSegueWithIdentifier:@"SCGMenuToMainView" sender:self];
//    }
//    else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1)
//    {
//        //settings
//        [self showMainMenu];
//        return;
//    }
//}

@end
