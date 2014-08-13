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

- (instancetype) initWithLevel:(SCGLevel *)l andOrientation:(ScoreOrientation)o andPlayers:(NSMutableArray *)p andWidth:(CGFloat)w
{
    self = [super init];
    if (self)
    {
        // Initialization code
        self.level = l;
        self.players = p;
        self.orientation = o;

        self.frameHeight = l.scoreViewHeight;
        self.frameWidth = w;
        
        self.frame = CGRectMake(0, 0, self.frameWidth, self.frameHeight);
 
        self.scoreLabels = [[NSMutableArray alloc] initWithCapacity:l.numberOfPlayers];
        CGFloat labelHeight = self.frameHeight;
        
        CGRect labelRect = CGRectMake(0, 0, 0, labelHeight);
        
        for (SCGGamePlayer *player in p)
        {
            SCGScoreLabel *scoreLabel = [[SCGScoreLabel alloc] initWithFrame:labelRect andPlayer:player andLevel:l];
            [self.scoreLabels addObject:scoreLabel];
            [self addSubview: scoreLabel];
        }

        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = (int)(5.f * l.scaleGeometry);
        self.layer.borderColor = [UIColor blackColor].CGColor;
        
        CGFloat rotation = 0;

        switch (o)
        {
            case LeftScore:
                rotation = -kPiOver2;
                break;
            case BottomScore:
                rotation = kPi;
                break;
            case RightScore:
                rotation = kPiOver2;
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

- (void) updateScores:(int)currentPlayer andDone:(BOOL)done
{
    CGFloat width = self.bounds.size.width;
    CGFloat left = 0;

    for (SCGScoreLabel *scoreLabel in self.scoreLabels)
    {
        CGFloat blockWidth = (width * scoreLabel.player.score) / self.level.numberOfCells;
        scoreLabel.frame = CGRectMake(left, 0, blockWidth, self.frameHeight);
        if (scoreLabel.player.score * 10 >= self.level.numberOfCells)
            [scoreLabel refreshScore:NO];
        else
            [scoreLabel refreshScore:YES];
        
        left += blockWidth;
    }

    if (done)
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    else
        self.layer.borderColor = ((SCGGamePlayer *)([self.players objectAtIndex:currentPlayer])).color.CGColor;
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
