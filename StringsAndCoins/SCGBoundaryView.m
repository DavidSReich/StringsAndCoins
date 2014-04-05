//
//  SCGBoundaryView.m
//  StringsAndCoins
//
//  Created by David S Reich on 8/02/2014.
//  Copyright (c) 2014 David S Reich. All rights reserved.
//

#import "SCGBoundaryView.h"
#import "SCGLevel.h"
#import "SCGBoardController.h"
#import "constants.h"

@implementation SCGBoundaryView
#if defined(SHOWROWANDCOL)
{
    UILabel *rcLabel;
}
#endif

- (instancetype) initWithLevel:(SCGLevel *)l andRow:(int)r andCol:(int)c andTopHalf:(BOOL)t andOrientation:(BoundaryOrientation)o
{
//	self = [super initWithImage: l.boundaryImage];
	self = [super init];
	
    if (self != nil)
    {
        //initialization
        self.complete = NO;
		self.row = r;
		self.col = c;
		self.level = l;
		self.topHalf = t;
        self.orientation = o;
        self.userInteractionEnabled = YES;

		//resize
        CGFloat scale = l.cellWidth / l.boundaryImage.size.width;
        if (l.levelShape == HexagonShape)
            self.frame = CGRectMake(0, 0, (l.boundaryImage.size.width * scale) / 2, (l.boundaryImage.size.height * scale) / 2);
        else if ((l.levelShape == TriangleShape) && (l.levelType == CoinsType))
            self.frame = CGRectMake(0, 0, l.boundaryImage.size.width * scale / 2, (l.boundaryImage.size.height * scale) / 2);
        else
            self.frame = CGRectMake(0, 0, l.boundaryImage.size.width * scale, (l.boundaryImage.size.height * scale) / 2);

        //overlay a button -- makes presses easier?
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = self.frame;
        [self.btn setBackgroundImage:l.boundaryImage forState:UIControlStateNormal];
        self.btn.userInteractionEnabled = YES;
        [self.btn addTarget:self action:@selector(ActionTapped) forControlEvents:UIControlEventTouchDown];
        [self addSubview: self.btn];

#if defined(SHOWROWANDCOL)
        rcLabel = [[UILabel alloc] initWithFrame:self.bounds];
        rcLabel.textAlignment = NSTextAlignmentCenter;
        rcLabel.textColor = [UIColor whiteColor];
        rcLabel.backgroundColor = [UIColor clearColor];
        rcLabel.text = [NSString stringWithFormat:@"%d %d", r, c];
        rcLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:(78.0 * scale) / 4];
        [self.btn addSubview: rcLabel];
#endif

        [self updateImage];
        
        CGFloat rotation = 0;

        if (l.levelShape == SquareShape)
        {
            if (o == Vertical)
                rotation = kPiOver2;
        }
        else if (l.levelShape == TriangleShape)
        {
            if (o == VerticalLeft)
                rotation = kPiOver3;
            else if (o == VerticalRight)
                rotation = -kPiOver3;
        }
        else    //hexagon
        {
            if (o == Vertical)
                rotation = kPiOver2;
            else if (o == HorizontalLeft)
                rotation = kPiOver6;
            else    //HorizontalRight
                rotation = -kPiOver6;
        }

        [self bringSubviewToFront:self.btn];
        
        if (self.level.levelType == CoinsType)
        {
            if (ABS(rotation) == kPiOver2)
                rotation = 0;
            else
                rotation += kPiOver2;
        }

        if (rotation != 0)
            self.transform = CGAffineTransformMakeRotation(rotation);
    }
	
    return self;
}

// Action design:
// if boundary is NOT complete, single tap is enabled, double tap is disabled
// if boundary is complete, single tap is disabled, double tap is enabled until disabled by next tap

- (void) ActionTapped
{
//    self.btn.backgroundColor = [UIColor greenColor];
    self.complete = YES;
    [self updateImage];
    [self.btn removeTarget:self action:@selector(ActionTapped) forControlEvents:UIControlEventTouchDown];
    [self.btn addTarget:self action:@selector(ActionDoubleTapped) forControlEvents:UIControlEventTouchDownRepeat];
    [self.board boundaryClicked:self];
}

- (void) ActionDoubleTapped
{
//    self.btn.backgroundColor = [UIColor orangeColor];
    self.complete = NO;
    [self updateImage];
    [self.btn addTarget:self action:@selector(ActionTapped) forControlEvents:UIControlEventTouchDown];
    [self.btn removeTarget:self action:@selector(ActionDoubleTapped) forControlEvents:UIControlEventTouchDownRepeat];
    [self.board boundaryDoubleClicked];
}

- (void) LockBoundary
{
    [self.btn removeTarget:self action:@selector(ActionTapped) forControlEvents:UIControlEventTouchDown];
    [self.btn removeTarget:self action:@selector(ActionDoubleTapped) forControlEvents:UIControlEventTouchDownRepeat];
}

- (void) updateImage
{
    if (self.level.levelType == CoinsType)
    {
        if (self.complete)
        {
            [self.btn setBackgroundImage:nil forState:UIControlStateNormal];
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = YES;
#endif
        }
        else
        {
            [self.btn setBackgroundImage:self.level.boundaryImage forState:UIControlStateNormal];
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = YES;
#endif
        }
    }
    else
    {
        if (self.complete)
        {
            [self.btn setBackgroundImage:self.level.boundaryImage forState:UIControlStateNormal];
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = YES;
#endif
        }
        else
        {
            [self.btn setBackgroundImage:nil forState:UIControlStateNormal];
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = NO;
#endif
        }

//#if 1   //testing
//        [self.btn setBackgroundImage:self.level.boundaryImage forState:UIControlStateNormal];
//#if defined(SHOWROWANDCOL)
//        rcLabel.hidden = NO;
//#endif
//#endif
    }
}

- (void)CheckStatus
{
	//
}

@end
