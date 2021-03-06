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

#define kBoundaryGapScale   0.75

@implementation SCGBoundaryView
{
    CGMutablePathRef hotSpotPath;
#if defined(SHOWROWANDCOL)
    UILabel *rcLabel;
#endif
}

- (instancetype) initWithLevel:(SCGLevel *)l andRow:(int)r andCol:(int)c andTopHalf:(BOOL)t andOrientation:(BoundaryOrientation)o
{
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
        self.canUndo = NO;
        self.showHighlight = NO;
        self.userInteractionEnabled = YES;
        self.thePlayer = nil;

//        CGFloat aspect = l.boundaryImage.size.height / l.boundaryImage.size.width;
        //this is based upon the dimensions of the original image file ... it looked good, so we are using it
        CGFloat aspect = 61.0 / 302.0;
        
		//resize
        CGFloat length;

        if (l.levelType == BoxesType)
        {
            if (l.levelShape == HexagonShape)
            {
                length = l.cellWidth * .5;
                aspect *= 1.8;
            }
            else
                length = l.cellWidth;
        }
        else
        {
            if (l.levelShape == HexagonShape)
                length = l.cellWidth * .8;
            else if (l.levelShape == TriangleShape)
                length = l.cellWidth * .4;
            else
                length = l.cellWidth * .6;
        }
 
        //make the self.frame bigger, the btn smaller and create the hotspot in self.frame
        CGFloat extraHeight;
        if (l.levelShape == TriangleShape)
        {
            if (l.levelType == BoxesType)
                extraHeight = ((l.cellHeight * 2.f) / 3.f) - (length * aspect);
            else
                extraHeight = l.cellHeight - (length * aspect);
        }
        else if (l.levelShape == SquareShape)
            extraHeight = l.cellHeight - (length * aspect);
        else    //hexagons
        {
            if (l.levelType == BoxesType)
                extraHeight = length * aspect * 3.2;
            else
                extraHeight = length * aspect * 2.6;
        }

        //extraHeight = 0;
        self.frame = CGRectMake(0, 0, length, length * aspect + extraHeight);
        CGRect r = self.frame;
        
//        self.layer.borderColor = [UIColor greenColor].CGColor;
//        self.layer.borderWidth = 3.f;

        //overlay a button -- makes presses easier? -- not using button for presses anymore
        //at this point I'm only using the button for its image and backroundimage
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGPoint ctr = self.center;
        self.btn.frame = CGRectMake(0, 0, r.size.width, length * aspect);
        self.btn.center = ctr;
        [self addSubview:self.btn];
        [self bringSubviewToFront:self.btn];
        self.btn.userInteractionEnabled = NO;

        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ActionTapped)];
        self.tapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:self.tapRecognizer];

        //make path
        CGPoint pts[4];
        
        pts[0] = CGPointMake(0, self.frame.size.height / 2);
        pts[1] = CGPointMake(self.frame.size.width / 2, 0);
        pts[2] = CGPointMake(self.frame.size.width, self.frame.size.height / 2);
        pts[3] = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
        
//        NSLog(@"%f %f", pts[0].x, pts[0].y);
//        NSLog(@"%f %f", pts[1].x, pts[1].y);
//        NSLog(@"%f %f", pts[2].x, pts[2].y);
//        NSLog(@"%f %f", pts[3].x, pts[3].y);
        
        hotSpotPath = CGPathCreateMutable();
        //make the path
        CGPathMoveToPoint(hotSpotPath, NULL, pts[0].x, pts[0].y);
        for (int i = 1; i < 4; i++)
            CGPathAddLineToPoint(hotSpotPath, NULL, pts[i].x, pts[i].y);
        //close the path
        CGPathCloseSubpath(hotSpotPath);
#if false
        //draw the hotspot
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(r.size.width, r.size.height), NO, 0.0);
        
        //use the the image that is going to be drawn on as the receiver
        UIImage *img = self.image;
        
        [img drawInRect:CGRectMake(0.0, 0.0, r.size.width, r.size.height)];
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(ctx);
        CGFloat lineWidth = 3.f;
        CGContextSetLineWidth(ctx, lineWidth);
        CGContextSetStrokeColorWithColor(ctx, [UIColor yellowColor].CGColor);
        //draw
        CGContextMoveToPoint(ctx, pts[0].x, pts[0].y);
        for (int i = 1; i < 4; i++)
            CGContextAddLineToPoint(ctx, pts[i].x, pts[i].y);
        //close the path
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
        UIGraphicsPopContext();
        //get the new image
        UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
        self.image = img2;
        UIGraphicsEndImageContext();
#endif
        
#if defined(SHOWROWANDCOL)
        rcLabel = [[UILabel alloc] initWithFrame:self.bounds];
        rcLabel.textAlignment = NSTextAlignmentCenter;
        rcLabel.textColor = [UIColor whiteColor];
        rcLabel.backgroundColor = [UIColor clearColor];
        rcLabel.text = [NSString stringWithFormat:@"%d %d", r, c];
        rcLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:(78.0 * scale) / 4];
        [self.btn addSubview: rcLabel];
#endif

        [self UpdateImage];

        //rotate AFTER setting dimensions
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

        //do we still need this?
        if (!(l.levelShape == SquareShape) && !(l.levelShape == TriangleShape))
            [self bringSubviewToFront:self.touchBtn];

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
    self.complete = YES;
    [self UpdateImage];
    [self.tapRecognizer removeTarget:self action:@selector(ActionTapped)];
    [self.tapRecognizer addTarget:self action:@selector(ActionDoubleTapped)];
    self.tapRecognizer.numberOfTapsRequired = 2;
    self.canUndo = YES;
    self.showHighlight = YES;
    [self.board boundaryClicked:self];  //boundary color set by boundaryClicked
    [self UpdateImage];
}

- (void) UnlockBoundary
{
    self.complete = NO;
    [self UpdateImage]; //??need this
    [self.tapRecognizer removeTarget:self action:@selector(ActionDoubleTapped)];
    [self.tapRecognizer addTarget:self action:@selector(ActionTapped)];
    self.tapRecognizer.numberOfTapsRequired = 1;
    self.tapRecognizer.enabled = YES;
    self.canUndo = NO;
    self.showHighlight = NO;
    [self UpdateImage];
}

- (void) ActionDoubleTapped
{
    [self UnlockBoundary];
    [self.board boundaryDoubleClicked];
}

- (void) LockBoundary
{
    [self.tapRecognizer removeTarget:self action:@selector(ActionDoubleTapped)];
    [self.tapRecognizer removeTarget:self action:@selector(ActionTapped)];
    self.tapRecognizer.numberOfTapsRequired = 1;
    self.tapRecognizer.enabled = NO;
    self.canUndo = NO;
    [self UpdateImage];
}

- (void) UpdateImage
{
    if (self.level.levelType == CoinsType)
    {
        //set the image context
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, self.frame.size.height), NO, 0.0);
        
        //use the the image that is going to be drawn on as the receiver
        UIImage *img = [self.btn backgroundImageForState:UIControlStateNormal];
        
        [img drawInRect:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        UIGraphicsPushContext(ctx);
            
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGFloat w;
        w = self.frame.size.height;
        w = w * .8;

        CGRect drawRect = CGRectMake(0.0 - 2, (self.frame.size.height - w) / 2, self.frame.size.width + 4, w);
        CGContextFillRect(ctx, drawRect);

        if (self.complete)
        {
//            CGFloat truncateLength = drawRect.size.width / 3;
            CGFloat truncateLength = drawRect.size.width * kBoundaryGapScale;
            CGContextClearRect(ctx, CGRectMake(drawRect.origin.x + truncateLength, drawRect.origin.y - 4, drawRect.size.width - (2 * truncateLength), drawRect.size.height + 8));
        }
    
        UIGraphicsPopContext();
        
        //get the new image
        UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
        
        [self.btn setBackgroundImage:[img2 imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        UIGraphicsEndImageContext();
    
#if defined(SHOWROWANDCOL)
        rcLabel.hidden = YES;
#endif
    }
    else
    {
        if (self.complete)
        {
            //set the image context
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, self.frame.size.height), NO, 0.0);
            
            //use the the image that is going to be drawn on as the receiver
            UIImage *img = [self.btn backgroundImageForState:UIControlStateNormal];
            
            [img drawInRect:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
            
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            UIGraphicsPushContext(ctx);

            CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
            CGFloat w;
            w = self.frame.size.height;
            w = w * .8;
            
            CGContextFillRect(ctx, CGRectMake(0.0 - 2, (self.frame.size.height - w) / 2, self.frame.size.width + 4, w));
            UIGraphicsPopContext();
            
            //get the new image
            UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();

            [self.btn setBackgroundImage:[img2 imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

            UIGraphicsEndImageContext();

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
    }

    [self UpdateDetails];
}

- (void) UpdateDetails
{
    [self.btn setImage:nil forState:UIControlStateNormal];

    if (!self.canUndo && !self.complete)
        return;

    CGFloat fullWidth, fullLength;

    //set the image context
    fullWidth = self.btn.frame.size.height;
    fullLength = self.btn.frame.size.width;

    CGFloat undoWidth, completeWidth, length;
    undoWidth = fullWidth * .29;
    length = fullLength;
    completeWidth = fullWidth * .54;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(fullLength, fullWidth), NO, 0.0);

    //use the the image that is going to be drawn on as the receiver
    UIImage *img = [self.btn imageForState:UIControlStateNormal];
    
    [img drawInRect:CGRectMake(0.0, 0, length, fullWidth)];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(ctx);

    CGRect drawRect = CGRectMake(0.0, (fullWidth - completeWidth) / 2, length, completeWidth);

    if (self.complete)
    {
        CGContextSetStrokeColorWithColor(ctx, self.boundaryColor.CGColor);
        CGFloat lineWidth = 2;
        CGContextSetLineWidth(ctx, lineWidth * self.level.scaleGeometry);
        CGContextStrokeRect(ctx, drawRect);
    }

    if (self.showHighlight)
    {
        if (self.canUndo)
            CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        else
            CGContextSetFillColorWithColor(ctx, self.boundaryColor.CGColor);
        CGContextSetLineWidth(ctx, 0.5);
        CGContextFillRect(ctx, CGRectMake(0.0, (fullWidth - undoWidth) / 2, length, undoWidth));
    }

//    if (self.canUndo)
//    {
//        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
//        CGContextSetLineWidth(ctx, 0.5);
//        CGContextFillRect(ctx, CGRectMake(0.0, (fullWidth - undoWidth) / 2, length, undoWidth));
//    }

    if ((self.level.levelType == CoinsType) && (self.complete))
    {
//        CGFloat truncateLength = drawRect.size.width / 3;
        CGFloat truncateLength = drawRect.size.width * kBoundaryGapScale;
        CGFloat clearWider = 8;
        CGContextClearRect(ctx, CGRectMake(drawRect.origin.x + truncateLength, drawRect.origin.y - (clearWider / 2), drawRect.size.width - (2 * truncateLength), drawRect.size.height + clearWider));
    }

    UIGraphicsPopContext();
    
    //get the new image
    UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.btn setImage:[img2 imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL superResult = [super pointInside:point withEvent:event];
    if (!superResult) {
        return superResult;
    }
    
    if (CGPointEqualToPoint(point, self.previousPointInsidePoint))
        return self.previousPointInsideResponse;
    else
        self.previousPointInsidePoint = point;
    
    BOOL response = YES;
    
    if ((self.level.levelShape == SquareShape) || (self.level.levelShape == TriangleShape) || true)
    {
        response = CGPathContainsPoint(hotSpotPath, NULL, point, true);

//        UIEventType et = event.type;
//        UIEventSubtype est = event.subtype;//
//        NSLog(@"%hhd  %f %f event:%ld %ld", response, point.x, point.y, et, est);
    }

    self.previousPointInsidePoint = point;
    self.previousPointInsideResponse = response;
    return response;
}

- (void) dealloc
{
    //release path if we calculate it during init and save it
    CGPathRelease(hotSpotPath);
}
@end
