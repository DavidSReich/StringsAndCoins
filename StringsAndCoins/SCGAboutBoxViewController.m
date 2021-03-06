//
//  SCGAboutBoxViewController.m
//  StringsAndCoins
//
//  Created by David S Reich on 18/05/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "constants.h"
#import "SCGAboutBoxViewController.h"
#import "SCGAppDelegate.h"

@interface SCGAboutBoxViewController ()

@end

@implementation SCGAboutBoxViewController

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

    SCGAppDelegate *appDelegate = (SCGAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.settings.isIphone && !appDelegate.settings.isIphone4)
    {
        CGFloat maxY = 0;
        
        for (UIView *view in self.view.subviews)
        {
            if (view.tag != -1)
            {
                CGRect r = view.frame;
                if (maxY < r.origin.y + r.size.height)
                    maxY = r.origin.y + r.size.height;
            }
        }
        
        CGRect r = self.view.frame;
        CGFloat shiftYBy = (r.size.height - maxY) / 4;
        
        for (UIView *view in self.view.subviews)
        {
            if (view.tag != -1)
            {
                CGRect r = view.frame;
                view.frame = CGRectMake(r.origin.x, r.origin.y + shiftYBy, r.size.width, r.size.height);
            }
        }
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okButtonTouched:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
