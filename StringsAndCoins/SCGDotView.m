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
//	if (l.levelType == BoxesType)
//		self = [super initWithImage: l.dotImage];
    self = [super init];
	
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
        if (l.levelShape == HexagonShape)
            self.frame = CGRectMake(0, 0, l.cellWidth * .18, l.cellWidth * .18);
        else if (l.levelShape == TriangleShape)
            self.frame = CGRectMake(0, 0, l.cellWidth * .3, l.cellWidth * .3);
        else
            self.frame = CGRectMake(0, 0, l.cellWidth / 4, l.cellWidth / 4);

    
        self.image = nil;
        
        //set the image context
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, self.frame.size.height), NO, 0.0);
        
        //use the the image that is going to be drawn on as the receiver
        UIImage *img = self.image;
        
        [img drawInRect:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        UIGraphicsPushContext(ctx);
        
        CGContextSetLineWidth(ctx, 1.0);
        CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        UIGraphicsPopContext();
        
        //get the new image
        UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
        
        [self setImage:img2];
        
        UIGraphicsEndImageContext();
    }
	
    return self;
}

@end
