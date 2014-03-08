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
        float scale = (l.cellWidth / self.image.size.width) / 2;
        
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
//        if (l.levelShape == HexagonShape)
            scale = scale / 4;
        self.frame = CGRectMake(0, 0, self.image.size.width * scale, self.image.size.height * scale);
    }
	
    return self;
}

@end
