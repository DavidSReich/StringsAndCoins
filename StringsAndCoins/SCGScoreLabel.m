//
//  SCGScoreLabel.m
//  StringsAndCoins
//
//  Created by David S Reich on 19/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGScoreLabel.h"
#import "SCGGamePlayer.h"

@implementation SCGScoreLabel

- (instancetype) initWithFrame:(CGRect)frame andPlayer:(SCGGamePlayer *)p
{
    self = [super initWithFrame:frame];

    if (self)
    {
        // Initialization code
        self.player = p;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = p.color;
        self.opaque = YES;
        self.text = [NSString stringWithFormat:@"%d", 0];
        self.font = [UIFont fontWithName:@"Verdana-Bold" size:frame.size.height / 1.5];
        self.clipsToBounds = NO;
    }

    return self;
}

- (void) refreshScore
{
    self.text = [NSString stringWithFormat:@"%d", self.player.score];
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
