//
//  SCCellView.h
//  StringsAndCoins
//
//  Created by David S Reich on 8/02/2014.
//  Copyright (c) 2014 David S Reich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCGLevel;

@interface SCGCellView : UIImageView

@property (assign, nonatomic) int row;
@property (assign, nonatomic) int col;
@property (assign, nonatomic) BOOL complete;
@property (assign, nonatomic) int playerNumber;
@property (assign, nonatomic) UIColor *completeColor;
@property (assign, nonatomic) BOOL topHalf; //only useful for non-square
@property (assign, nonatomic) BOOL isUpTriangle;
@property (weak, nonatomic) SCGLevel *level;
@property (assign, nonatomic) CGPoint center0;

- (instancetype) initWithLevel:(SCGLevel *)l andRow:(int)r andCol:(int)c andTopHalf:(BOOL)t andCenter:(CGPoint)ctr;
- (void) setComplete:(BOOL)c withPlayer:(int)p andColor:(UIColor *)color;
- (void) updateImage;

@end
