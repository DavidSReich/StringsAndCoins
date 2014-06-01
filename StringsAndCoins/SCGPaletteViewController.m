//
//  SCGPaletteViewController.m
//  StringsAndCoins
//
//  Created by David S Reich on 31/05/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGPaletteViewController.h"

@interface SCGPaletteViewController ()

@property (strong, nonatomic) IBOutlet UIView *palette0;
@property (strong, nonatomic) IBOutlet UIView *color0;
@property (strong, nonatomic) IBOutlet UIView *color1;
@property (strong, nonatomic) IBOutlet UIView *color2;
@property (strong, nonatomic) IBOutlet UIView *color3;

@end

@implementation SCGPaletteViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
