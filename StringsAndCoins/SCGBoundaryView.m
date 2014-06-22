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
//	self = [super initWithImage:nil];
	
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
        self.userInteractionEnabled = YES;

//        CGFloat aspect = l.boundaryImage.size.height / l.boundaryImage.size.width;
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
 
#if true
        //make the self.frame bigger, the btn smaller and the touchbtn as big as the self.frame
        CGFloat extraHeight;
        if (l.levelShape == TriangleShape)
            extraHeight = length * aspect * 2;
        else if (l.levelShape == SquareShape)
            extraHeight = length * aspect * 3;
        else
            extraHeight = length * aspect * 3;
        //extraHeight = 0;
        self.frame = CGRectMake(0, 0, length, length * aspect + extraHeight);
        CGRect r = self.frame;
        
        //overlay a button -- makes presses easier?
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(r.origin.x, r.origin.y + extraHeight / 2, r.size.width, r.size.height - extraHeight);
        [self addSubview: self.btn];
        
        self.touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.touchBtn.frame = self.frame;
        self.touchBtn.userInteractionEnabled = YES;
        [self.touchBtn addTarget:self action:@selector(ActionTapped) forControlEvents:UIControlEventTouchDown];
        self.touchBtn.showsTouchWhenHighlighted = YES;
        [self addSubview: self.touchBtn];
#if true
//testtesttest
        self.touchBtn.layer.borderColor = [UIColor greenColor].CGColor;
        self.touchBtn.layer.borderWidth = 3.f;
        self.touchBtn.imageView.hidden = YES;
#endif
#else
        self.frame = CGRectMake(0, 0, length, length * aspect);
        
        //overlay a button -- makes presses easier?
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = self.frame;
        [self addSubview: self.btn];

        CGRect r = self.frame;
        CGFloat extraHeight = r.size.height;
        self.touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.touchBtn.frame = CGRectMake(r.origin.x, r.origin.y - extraHeight / 2, r.size.width, r.size.height + extraHeight);
        self.touchBtn.userInteractionEnabled = YES;
        [self.touchBtn addTarget:self action:@selector(ActionTapped) forControlEvents:UIControlEventTouchDown];
        self.touchBtn.showsTouchWhenHighlighted = YES;
        [self addSubview: self.touchBtn];
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
    [self.touchBtn removeTarget:self action:@selector(ActionTapped) forControlEvents:UIControlEventTouchDown];
    [self.touchBtn addTarget:self action:@selector(ActionDoubleTapped) forControlEvents:UIControlEventTouchDownRepeat];
    self.canUndo = YES;
    [self.board boundaryClicked:self];  //boundary color set by boundaryClicked
    [self UpdateImage];
}

- (void) ActionDoubleTapped
{
    self.complete = NO;
    [self UpdateImage];
    [self.touchBtn addTarget:self action:@selector(ActionTapped) forControlEvents:UIControlEventTouchDown];
    [self.touchBtn removeTarget:self action:@selector(ActionDoubleTapped) forControlEvents:UIControlEventTouchDownRepeat];
    self.canUndo = NO;
    [self.board boundaryDoubleClicked];
    [self UpdateImage];
}

- (void) LockBoundary
{
    [self.touchBtn removeTarget:self action:@selector(ActionTapped) forControlEvents:UIControlEventTouchDown];
    [self.touchBtn removeTarget:self action:@selector(ActionDoubleTapped) forControlEvents:UIControlEventTouchDownRepeat];
    self.touchBtn.showsTouchWhenHighlighted = NO;
//    touchBtn = NO;
    self.canUndo = NO;
    [self UpdateImage];
}

- (void) UpdateImage
{
    if (self.level.levelType == CoinsType)
    {
//        if (self.complete)
//        {
//            [self.btn setBackgroundImage:nil forState:UIControlStateNormal];
//            //set the image context
//            UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, self.frame.size.height), NO, 0.0);
//            
//            //use the the image that is going to be drawn on as the receiver
//            UIImage *img = [self.btn backgroundImageForState:UIControlStateNormal];
//            
//            [img drawInRect:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
//            
//            CGContextRef ctx = UIGraphicsGetCurrentContext();
//            
//            UIGraphicsPushContext(ctx);
//            
//            CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
//            CGFloat w;
//            w = self.frame.size.height;
//            w = w * .8;
//            
//            CGContextFillRect(ctx, CGRectMake(0.0 - 2, (self.frame.size.height - w) / 2, self.frame.size.width + 4, w));
//            UIGraphicsPopContext();
//            
//            //get the new image
//            UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
//            
//            [self.btn setBackgroundImage:img2 forState:UIControlStateNormal];
//            
//            UIGraphicsEndImageContext();
//#if defined(SHOWROWANDCOL)
//            rcLabel.hidden = YES;
//#endif
//        }
//        else
//        {
#if true
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
                CGFloat truncateLength = drawRect.size.width / 3;
                CGContextClearRect(ctx, CGRectMake(drawRect.origin.x + truncateLength, drawRect.origin.y - 4, drawRect.size.width - (2 * truncateLength), drawRect.size.height + 8));
            }
        
            UIGraphicsPopContext();
            
            //get the new image
            UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
            
            [self.btn setBackgroundImage:img2 forState:UIControlStateNormal];
            
            UIGraphicsEndImageContext();
#else
            //set the image context
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.frame.size.width, self.frame.size.height), NO, 0.0);
            
            //use the the image that is going to be drawn on as the receiver
            UIImage *img = [self.btn backgroundImageForState:UIControlStateNormal];
            
            [img drawInRect:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
            
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(ctx, 0.5);
            
            UIGraphicsPushContext(ctx);
            
            CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
            CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
            CGContextAddEllipseInRect(ctx, CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height));
            CGContextFillPath(ctx);
            CGContextStrokePath(ctx);
            
            UIGraphicsPopContext();
            
            //get the new image
            UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [self.btn setBackgroundImage:img2 forState:UIControlStateNormal];
#endif
            
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = YES;
#endif
//        }
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

            [self.btn setBackgroundImage:img2 forState:UIControlStateNormal];

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

//#if 1   //testing
//        [self.btn setBackgroundImage:self.level.boundaryImage forState:UIControlStateNormal];
//#if defined(SHOWROWANDCOL)
//        rcLabel.hidden = NO;
//#endif
//#endif
    }

    [self UpdateDetails];
}

- (void) CheckStatus
{
	//
}

- (void) UpdateDetails
{
    [self.btn setImage:nil forState:UIControlStateNormal];

    if (!self.canUndo && !self.complete)
        return;

    CGFloat fullWidth, fullLength;

    //set the image context
    if (self.orientation == Horizontal)
    {
        fullWidth = self.frame.size.height;
        fullLength = self.frame.size.width;
    }
    else if ((self.level.levelShape == HexagonShape) && (self.orientation != Vertical))
    {
        fullWidth = self.frame.size.height;
        fullLength = self.frame.size.width;
    }
    else
    {
        fullWidth = self.frame.size.width;
        fullLength = self.frame.size.height;
    }

    if (self.level.levelType == CoinsType)
    {
        CGFloat temp = fullWidth;
        fullWidth = fullLength;
        fullLength = temp;
    }

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
        if ((self.level.levelShape == TriangleShape) && (self.orientation != Horizontal))
            lineWidth = 4;
        else if ((self.level.levelShape == HexagonShape) && (self.orientation != Vertical))
            lineWidth = 4;

        CGContextSetLineWidth(ctx, lineWidth * self.level.scaleGeometry);
        CGContextStrokeRect(ctx, drawRect);
    }
    
    if (self.canUndo)
    {
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(ctx, 0.5);
        CGContextFillRect(ctx, CGRectMake(0.0, (fullWidth - undoWidth) / 2, length, undoWidth));
    }

    if ((self.level.levelType == CoinsType) && (self.complete))
    {
        CGFloat truncateLength = drawRect.size.width / 3;
        CGFloat clearWider = 8;
        CGContextClearRect(ctx, CGRectMake(drawRect.origin.x + truncateLength, drawRect.origin.y - (clearWider / 2), drawRect.size.width - (2 * truncateLength), drawRect.size.height + clearWider));
    }

    UIGraphicsPopContext();
    
    //get the new image
    UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.btn setImage:img2 forState:UIControlStateNormal];
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL superResult = [super pointInside:point withEvent:event];
    if (!superResult) {
        return superResult;
    }
    
//    // Don't check again if we just queried the same point
//    // (because pointInside:withEvent: gets often called multiple times)
//    if (CGPointEqualToPoint(point, self.previousTouchPoint)) {
//        return self.previousTouchHitTestResponse;
//    } else {
//        self.previousTouchPoint = point;
//    }
    
    BOOL response = YES;
    
//    if (self.buttonImage == nil && self.buttonBackground == nil) {
//        response = YES;
//    }
//    else if (self.buttonImage != nil && self.buttonBackground == nil) {
//        response = [self isAlphaVisibleAtPoint:point forImage:self.buttonImage];
//    }
//    else if (self.buttonImage == nil && self.buttonBackground != nil) {
//        response = [self isAlphaVisibleAtPoint:point forImage:self.buttonBackground];
//    }
//    else {
//        if ([self isAlphaVisibleAtPoint:point forImage:self.buttonImage]) {
//            response = YES;
//        } else {
//            response = [self isAlphaVisibleAtPoint:point forImage:self.buttonBackground];
//        }
//    }
    
//    self.previousTouchHitTestResponse = response;
    return response;
}

@end
