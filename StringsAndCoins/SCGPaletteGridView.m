//
//  SCGPaletteGridView.m
//  StringsAndCoins
//
//  Created by David S Reich on 6/06/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "constants.h"
#import "SCGPaletteGridView.h"
#import "SCGAppDelegate.h"

@implementation SCGPaletteGridView

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        SCGAppDelegate *appDelegate = (SCGAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (appDelegate.settings.isIphone)
            [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"SCGPaletteGridView_iPhone" owner:self options:nil] objectAtIndex:0]];
        else
            [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"SCGPaletteGridView" owner:self options:nil] objectAtIndex:0]];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (IBAction) paletteTouch:(id)sender
{
    self.settings.paletteNumber = [(UIView *)sender superview].tag;
    [self updatePaletteSelection];
}

- (void) updatePaletteSelection
{
    for (UIView *view in self.paletteGridInnerView.subviews)
    {
        view.layer.borderWidth = 2.f;

        if (view.tag == self.settings.paletteNumber)
            view.layer.borderColor = [UIColor whiteColor].CGColor;
        else
            view.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (NSMutableArray *) getPaletteColors:(int)paletteNumber
{
    NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:kMaxNumberOfPlayers];

    for (UIView *view in self.paletteGridInnerView.subviews)
    {
        if (view.tag == paletteNumber)
        {
            for (UIView *colorView in view.subviews)
            {
                if (![colorView isKindOfClass:[UIButton class]])
                {
                    [colors addObject: colorView.backgroundColor];
//                    SCGGamePlayer *gamePlayer = [[SCGGamePlayer alloc] initWithPlayer:player andColor:(UIColor *)color];
//                    [players addObject:gamePlayer];
                }
            }
            break;
        }
    }

    return colors;
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
