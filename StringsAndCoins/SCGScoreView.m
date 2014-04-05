//
//  SCGScoreView.m
//  StringsAndCoins
//
//  Created by David S Reich on 19/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGScoreView.h"
#import "SCGGamePlayer.h"
#import "SCGLevel.h"
#import "SCGScoreLabel.h"
#import "constants.h"

@implementation SCGScoreView

- (instancetype) initWithLevel:(SCGLevel *)l andOrientation:(ScoreOrientation)o andPlayers:(NSMutableArray *)p
{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.level = l;
        self.players = p;
        self.orientation = o;

        self.frameHeight = l.navigationController.toolbar.bounds.size.height / 2;
        self.frameWidth = self.frameHeight * 40;
        
        self.frame = CGRectMake(0, 0, self.frameWidth, self.frameHeight);
 
        self.scoreLabels = [[NSMutableArray alloc] initWithCapacity:l.numberOfPlayers];

        for (SCGGamePlayer *player in p)
        {
            SCGScoreLabel *scoreLabel = [[SCGScoreLabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.frameHeight) andPlayer:player];
            [self.scoreLabels addObject:scoreLabel];
            [self addSubview: scoreLabel];

//            SCGScoreBlockView *scoreBlock = [[SCGScoreBlockView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andPlayer:player];
//            [self.scoreBlockViews addObject:scoreBlock];
//            [self addSubview:scoreBlock];
//            [self bringSubviewToFront:scoreBlock];
        }

        self.backgroundColor = [UIColor darkGrayColor];
//        self.opaque = NO;
//        self.clipsToBounds = NO;
        
        float rotation = 0;

        switch (o)
        {
            case LeftScore:
                rotation = kPiOver2;
                break;
            case BottomScore:
                rotation = kPi;
                break;
            case RightScore:
                rotation = -kPiOver2;
                break;
            case TopScore:
            default:
                break;
        }
        
        if (rotation != 0)
            self.transform = CGAffineTransformMakeRotation(rotation);
    }

    return self;
}

- (void) updateScores
{
    int width = self.bounds.size.width;
    int left = 0;

    for (SCGScoreLabel *scoreLabel in self.scoreLabels)
    {
        int blockWidth = (width * scoreLabel.player.score) / self.level.numberOfCells;
        scoreLabel.frame = CGRectMake(left, 0, blockWidth, self.frameHeight);
        [scoreLabel refreshScore];
        
        left += blockWidth;
    }
    
//    for (SCGScoreBlockView *scoreBlock in self.scoreBlockViews)
//    {
//        int blockWidth = (width * scoreBlock.player.score) / self.level.numberOfCells;
//        scoreBlock.frame = CGRectMake(0, 0, left + blockWidth, self.frameHeight);
//        scoreBlock.center = CGPointMake(left + blockWidth / 2, self.frameHeight / 2);
//        [scoreBlock refreshScore];
//
//        [self bringSubviewToFront:scoreBlock];
//
//        left += blockWidth;
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
