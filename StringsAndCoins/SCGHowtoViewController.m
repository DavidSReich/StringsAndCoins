//
//  SCGHowtoViewController.m
//  StringsAndCoins
//
//  Created by David S Reich on 3/09/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGHowtoViewController.h"
#import "SCGAppDelegate.h"

@interface SCGHowtoViewController ()

@end

@implementation SCGHowtoViewController

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

    SCGAppDelegate *appDelegate = (SCGAppDelegate *)[[UIApplication sharedApplication] delegate];

    if (appDelegate.settings.isIphone && !appDelegate.settings.isIphone4)
    {
        CGFloat maxY = 0;

        for (UIView *view in self.view.subviews)
        {
            if (![view isKindOfClass:[UIImageView class]])
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
            if (![view isKindOfClass:[UIImageView class]])
            {
                CGRect r = view.frame;
                view.frame = CGRectMake(r.origin.x, r.origin.y + shiftYBy, r.size.width, r.size.height);
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
