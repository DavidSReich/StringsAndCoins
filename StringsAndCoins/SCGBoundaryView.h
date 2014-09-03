//
//  SCGBoundaryView.h
//  StringsAndCoins
//
//  Created by David S Reich on 8/02/2014.
//  Copyright (c) 2014 David S Reich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCGLevel;
@class SCGBoardController;
@class SCGBoundaryView;

@interface SCGBoundaryView : UIImageView

typedef NS_ENUM(NSInteger, BoundaryOrientation)
{
	Horizontal,
    HorizontalLeft,
    HorizontalRight,
    Vertical,
	VerticalLeft,
	VerticalRight
};

@property (assign, nonatomic) int row;
@property (assign, nonatomic) int col;
@property (assign, nonatomic) BOOL complete;
@property (assign, nonatomic) BOOL topHalf; //only useful for non-square
@property (assign, nonatomic) BoundaryOrientation orientation;
@property (strong, nonatomic) UIButton *btn;  //for display items
@property (strong, nonatomic) UIButton *touchBtn;  //touch me
@property (weak, nonatomic) SCGLevel *level;
@property (weak, nonatomic) SCGBoardController *board;
@property (assign, nonatomic) UIColor *boundaryColor;
@property (assign, nonatomic) BOOL canUndo;
@property (assign, nonatomic) CGPoint previousPointInsidePoint;
@property (assign, nonatomic) BOOL previousPointInsideResponse;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

- (instancetype) initWithLevel:(SCGLevel *)l andRow:(int)r andCol:(int)c andTopHalf:(BOOL)t andOrientation:(BoundaryOrientation)o;
- (void) ActionTapped;
- (void) ActionDoubleTapped;
- (void) UpdateImage;
- (void) LockBoundary;
- (void) UnlockBoundary;
- (void) UpdateDetails;

@end
