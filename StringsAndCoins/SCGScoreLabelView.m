//
//  SCGScoreBlockView.m
//  StringsAndCoins
//
//  Created by David S Reich on 19/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGScoreLabelView.h"
#import "SCGGamePlayer.h"

@implementation SCGScoreLabelView

- (instancetype) initWithFrame:(CGRect)frame andPlayer:(SCGGamePlayer *)p
{
    self = [super initWithFrame:frame];

    if (self)
    {
        // Initialization code
        self.player = p;
        self.scoreLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.scoreLabel.textAlignment = NSTextAlignmentCenter;
        self.scoreLabel.textColor = [UIColor whiteColor];
        self.scoreLabel.backgroundColor = p.color;
        self.scoreLabel.opaque = YES;
        self.scoreLabel.text = [NSString stringWithFormat:@"%d", 0];
        self.scoreLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:frame.size.height];
        [self addSubview: self.scoreLabel];
        self.clipsToBounds = NO;
    }

    return self;
}

- (void) refreshScore
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.player.score];
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
