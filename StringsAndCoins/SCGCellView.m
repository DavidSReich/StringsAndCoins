//
//  SCCellView.m
//  StringsAndCoins
//
//  Created by David S Reich on 8/02/2014.
//  Copyright (c) 2014 David S Reich. All rights reserved.
//

#import "SCGCellView.h"
#import "SCGLevel.h"
#import "constants.h"

//#define SHOWTRIANGLES

@implementation SCGCellView
#if defined(SHOWROWANDCOL)
{
    UILabel *rcLabel;
}
#endif

- (instancetype)initWithLevel:(SCGLevel *)l andRow:(int)r andCol:(int)c andTopHalf:(BOOL)t andCenter:(CGPoint)ctr
{
	if (l.levelType == BoxesType)
    {
#if defined(SHOWTRIANGLES)
        if (l.levelShape == TriangleShape)
        {
            if ((t && (c % 2 != 0)) || (!t && (c % 2 == 0)))
                self = [super initWithImage: [UIImage imageNamed:@"triangleDown-md.png"]];
            else
                self = [super initWithImage: [UIImage imageNamed:@"triangleUp-md.png"]];
        }
        else
            self = [super init];	//no image for boxes
#else
        self = [super init];	//no image for boxes
#endif
    }
	else
		self = [super initWithImage: l.cellImage];
	
    if (self != nil)
    {
        //initialization
        self.complete = NO;
        self.oldComplete = NO;
        self.playerNumber = -1;
		self.row = r;
		self.col = c;
		self.level = l;
		self.topHalf = t;
        self.center0 = ctr;
 
        if (l.levelShape == TriangleShape)
        {
            if ((t && (c % 2 != 0)) || (!t && (c % 2 == 0)))
                self.isUpTriangle = NO;
            else
                self.isUpTriangle = YES;
        }

        self.frame = CGRectMake(0, 0, l.cellWidth, l.cellHeight);
        self.center = self.center0;

#if defined(SHOWROWANDCOL)
        rcLabel = [[UILabel alloc] initWithFrame:self.bounds];
        rcLabel.textAlignment = NSTextAlignmentCenter;
        rcLabel.textColor = [UIColor whiteColor];
        rcLabel.backgroundColor = [UIColor clearColor];
        rcLabel.text = [NSString stringWithFormat:@"%d %d", r, c];
        rcLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:78.0/16];
        [self addSubview: rcLabel];
#endif
        
        [self updateImage];
    }
	
    return self;
}

- (void) setComplete:(BOOL)c withPlayer:(int)p andColor:(UIColor *)color
{
    self.oldComplete = self.complete;
    self.complete = c;
    self.playerNumber = p;
    self.completeColor = color;
    [self updateImage];
}

- (void) updateImage
{
    if (self.level.levelType == CoinsType)
    {
        if (self.complete)
        {
            [self setImage:nil];
            self.frame = CGRectMake(0, 0, self.level.cellWidth, self.level.cellHeight);
            self.center = self.center0;
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = NO;
#endif
        }
        else
        {
            [self setImage:self.level.cellImage];
            self.frame = CGRectMake(0, 0, self.level.cellWidth * 0.8, self.level.cellHeight * 0.8);
            self.center = self.center0;
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = YES;
#endif
        }
    }
    else
    {
        if (self.complete)
        {
//            [self setImage:self.level.dotImage];
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = NO;
#endif
        }
        else
        {
//            [self setImage:nil];
//            [self setImage:self.level.dotImage];
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = YES;
//            rcLabel.hidden = NO;
#endif
        }
    }

    if (self.level.levelShape == SquareShape)
    {
        if (self.complete)
            self.backgroundColor = self.completeColor;
        else
            self.backgroundColor = [UIColor clearColor];
    }
    else if (self.level.levelShape == TriangleShape)
    {
        if (!self.complete)
        {
            [self setImage:self.level.cellImage];
            if (self.level.levelType == CoinsType)
            {
                CGPoint offCenter;
                if (self.isUpTriangle)
                    offCenter = CGPointMake(self.center0.x, self.center0.y + self.level.cellHeight / 6);
                else
                    offCenter = CGPointMake(self.center0.x, self.center0.y - self.level.cellHeight / 6);
                self.center = offCenter;
                self.bounds = CGRectMake(0.0, 0.0, self.level.cellWidth / 2, self.level.cellHeight / 2);
            }
        }
        else
        {
            CGPoint firstPt;
            CGPoint secondPt;
            CGPoint thirdPt;

            if (self.isUpTriangle)
            {
                firstPt = CGPointMake(0, self.level.cellHeight);
                secondPt = CGPointMake(self.level.cellWidth, self.level.cellHeight);
                thirdPt = CGPointMake(((float)self.level.cellWidth) / 2, 0);
            }
            else
            {
                firstPt = CGPointMake(0, 0);
                secondPt = CGPointMake(self.level.cellWidth, 0);
                thirdPt = CGPointMake(((float)self.level.cellWidth) / 2, self.level.cellHeight);
            }

            //get the image context with options(recommended funct to use)
            //get the size of the imageView
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.level.cellWidth, self.level.cellHeight), NO, 0.0);
            
            //use the the image that is going to be drawn on as the receiver
            UIImage *img = self.image;
            
            [img drawInRect:CGRectMake(0.0, 0.0, self.level.cellWidth, self.level.cellHeight)];

            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(ctx, 0.5);
            
            UIGraphicsPushContext(ctx);
            
            //uses path ref
            CGMutablePathRef path = CGPathCreateMutable();
            //draw the triangle
            CGPathMoveToPoint(path, NULL, firstPt.x, firstPt.y);
            CGPathAddLineToPoint(path, NULL, secondPt.x, secondPt.y);
            CGPathAddLineToPoint(path, NULL, thirdPt.x, thirdPt.y);
            CGPathAddLineToPoint(path, NULL, firstPt.x, firstPt.y);
            //close the path
            CGPathCloseSubpath(path);
            //add the path to the context
            CGContextAddPath(ctx, path);
            CGContextSetFillColorWithColor(ctx, self.completeColor.CGColor);
            CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
            CGContextFillPath(ctx);
            CGContextAddPath(ctx, path);
            CGContextStrokePath(ctx);
            CGPathRelease(path);
            
            UIGraphicsPopContext();
            
            //get the new image with the triangle
            UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            [self setImage:img2];
            if (self.level.levelType == CoinsType)
            {
                self.bounds = CGRectMake(0.0, 0.0, self.level.cellWidth, self.level.cellHeight);
                self.center = self.center0;
            }
        }
    }
    else //if (0)
    {
        if (!self.complete)
        {
            [self setImage:self.level.cellImage];
        }
        else
        {
            //hexagons
            CGPoint pts[6];
            
            pts[0] = CGPointMake(self.level.cellWidth / 2, 0);
            pts[1] = CGPointMake(self.level.cellWidth, self.level.cellHeight / 4);
            pts[2] = CGPointMake(self.level.cellWidth, (3 * self.level.cellHeight) / 4);
            pts[3] = CGPointMake(self.level.cellWidth / 2, self.level.cellHeight);
            pts[4] = CGPointMake(0, (3 * self.level.cellHeight) / 4);
            pts[5] = CGPointMake(0, self.level.cellHeight / 4);

            //get the image context with options(recommended funct to use)
            //get the size of the imageView
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.level.cellWidth, self.level.cellHeight), NO, 0.0);
            
            //use the the image that is going to be drawn on as the receiver
            UIImage *img = self.image;
            
            [img drawInRect:CGRectMake(0.0, 0.0, self.level.cellWidth, self.level.cellHeight)];
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, 0.5);
            
            UIGraphicsPushContext(context);
            
            //uses path ref
            CGMutablePathRef path = CGPathCreateMutable();
            //draw the hexagon
            CGPathMoveToPoint(path, NULL, pts[0].x, pts[0].y);
            for (int i = 1; i < 6; i++)
                CGPathAddLineToPoint(path, NULL, pts[i].x, pts[i].y);
            CGPathAddLineToPoint(path, NULL, pts[0].x, pts[0].y);
            //close the path
            CGPathCloseSubpath(path);
            //add the path to the context
            CGContextAddPath(context, path);
            CGContextSetFillColorWithColor(context, self.completeColor.CGColor);
            CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
            CGContextFillPath(context);
            CGContextAddPath(context, path);
            CGContextStrokePath(context);
            CGPathRelease(path);
            
            UIGraphicsPopContext();
            
            //get the new image with the triangle
            UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [self setImage:img2];
        }
    }

    self.oldComplete = self.complete;
}

- (void)checkStatus
{
}

@end
