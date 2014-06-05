//
//  SCGGameOverViewController.m
//  StringsAndCoins
//
//  Created by David S Reich on 16/05/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#include "constants.h"
#import "SCGGameOverViewController.h"
#import "SCGGamePlayer.h"
#import "SCGPlayer.h"

@interface SCGGameOverViewController ()

@end

@implementation SCGGameOverViewController

@synthesize okButton;
@synthesize scoreGrid;
//@synthesize scoreView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Canvas1a_offwhite_1.png"]];
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    [self.view addSubview:backgroundView];
    [self.view sendSubviewToBack:backgroundView];

    int numberOfPlayers = self.players.count;
    int maxScore = 0;

    for (SCGGamePlayer *player  in self.players)
    {
        if (maxScore < player.score)
            maxScore = player.score;
    }
    
    for (UILabel *playerScoreLabel in self.scoreGrid.subviews)
    {
        playerScoreLabel.text = @"";
        
        int playerIdx = playerScoreLabel.tag % 4;

        if (playerIdx % 4 >= numberOfPlayers)
        {
            playerScoreLabel.hidden = YES;
            continue;
        }

        SCGGamePlayer *player = [self.players objectAtIndex:playerIdx];
        
        if (playerScoreLabel.tag >= kMaxNumberOfPlayers)
        {
            //score
            CGFloat width = playerScoreLabel.bounds.size.width;
            CGFloat blockWidth = (width * player.score) / maxScore;
            
            playerScoreLabel.frame = CGRectMake(playerScoreLabel.frame.origin.x, playerScoreLabel.frame.origin.y, blockWidth, playerScoreLabel.frame.size.height);
            playerScoreLabel.text = [NSString stringWithFormat:@" %d", player.score];
            playerScoreLabel.textColor = [UIColor whiteColor];
            playerScoreLabel.backgroundColor = player.color;
            playerScoreLabel.opaque = YES;
            playerScoreLabel.font = [UIFont fontWithName:@"Verdana" size:playerScoreLabel.frame.size.height / 2];
            playerScoreLabel.shadowColor = [UIColor blackColor];
            playerScoreLabel.shadowOffset = CGSizeMake(2, 2);
            playerScoreLabel.clipsToBounds = NO;
        }
        else if ([playerScoreLabel isKindOfClass:[UILabel class]])
        {
            //name
//            SCGPlayer *pPlayer = player.player;
//            NSMutableString *t = pPlayer.playerName;
//            NSLog(@"name: %@", t);
//            playerScoreLabel.text = t;//player.player.playerName;
            playerScoreLabel.text = [NSString stringWithFormat:@"Player %d ", playerIdx + 1];
        }

    }
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) okButtonTouched:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
