//
//  SCGDotView.m
//  StringsAndCoins
//
//  Created by David S Reich on 16/02/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGDotView.h"
#import "SCGLevel.h"
#import "constants.h"

@implementation SCGDotView

- (instancetype) initWithLevel:(SCGLevel *)l
{
    return [self initWithLevel:l andRow:0 andCol:0];
}

- (instancetype) initWithLevel:(SCGLevel *)l andRow:(int)r andCol:(int)c
{
	if (l.levelType == BoxesType)
		self = [super initWithImage: l.dotImage];
	
    if (self != nil)
    {
//#if defined(SHOWROWANDCOL)
//        UILabel *rcLabel = [[UILabel alloc] initWithFrame:self.bounds];
//        rcLabel.textAlignment = NSTextAlignmentCenter;
//        rcLabel.textColor = [UIColor whiteColor];
//        rcLabel.backgroundColor = [UIColor clearColor];
//        rcLabel.text = [NSString stringWithFormat:@"%d %d", r, c];
//        rcLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:78.0*scale/16];
//        [self addSubview: rcLabel];
//#endif

        //resize
        self.frame = CGRectMake(0, 0, l.cellWidth / 8, l.cellWidth / 8);
    }
	
    return self;
}

@end
