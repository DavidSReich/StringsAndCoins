//
//  SCGScoreLabel.m
//  StringsAndCoins
//
//  Created by David S Reich on 19/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGScoreLabel.h"
#import "SCGGamePlayer.h"
#import "SCGLevel.h"

@implementation SCGScoreLabel

- (instancetype) initWithFrame:(CGRect)frame andPlayer:(SCGGamePlayer *)p andLevel:(SCGLevel *)l
{
    self = [super initWithFrame:frame];

    if (self)
    {
        // Initialization code
        self.level = l;
        self.player = p;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor lightGrayColor];
        self.backgroundColor = p.color;
        self.opaque = YES;
        self.text = [NSString stringWithFormat:@"%d", 0];
        self.font = [UIFont fontWithName:@"Verdana" size:frame.size.height / 2];
        self.shadowColor = [UIColor blackColor];
        if (l.isIphone)
            self.shadowOffset = CGSizeMake(1, 1);
        else
            self.shadowOffset = CGSizeMake(2, 2);
        self.clipsToBounds = NO;

        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
        [attributeString addAttribute:NSUnderlineStyleAttributeName
                                value:[NSNumber numberWithInt:1]
                                range:(NSRange){0,[attributeString length]}];
        self.attributedText = attributeString;
    }

    return self;
}

- (void) refreshScore:(BOOL)blank
{
    if (blank)
        self.text = @"";
    else
        self.text = [NSString stringWithFormat:@"%d", self.player.score];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    self.attributedText = attributeString;
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
