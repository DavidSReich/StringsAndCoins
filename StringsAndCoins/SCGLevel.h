//
//  SCLevel.h
//  StringsAndCoins
//
//  Created by David S Reich on 7/02/2014.
//  Copyright (c) 2014 David S Reich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constants.h"

@interface SCGLevel : NSObject

typedef NS_ENUM(NSInteger, LevelType)
{
	BoxesType,
	CoinsType
};

typedef NS_ENUM(NSInteger, LevelShape)
{
	SquareShape,
	TriangleShape,
	HexagonShape
};

typedef NS_ENUM(NSInteger, LevelSize)
{
	SmallSize,
	MediumSize,
	LargeSize
};

@property (assign, nonatomic) BOOL isIphone;

@property (assign, nonatomic) LevelType levelType;
@property (assign, nonatomic) LevelShape levelShape;
@property (assign, nonatomic) LevelSize levelSize;
//@property (assign, nonatomic) CGFloat screenWidth;
//@property (assign, nonatomic) CGFloat screenHeight;
@property (assign, nonatomic) CGFloat boardWidth;
@property (assign, nonatomic) CGFloat boardHeight;
@property (assign, nonatomic) CGFloat statusBarOffset;

@property (assign, nonatomic) CGFloat statusBarHeight;
@property (assign, nonatomic) CGFloat topMarginHeight;
@property (assign, nonatomic) CGFloat bottomMarginHeight;
@property (assign, nonatomic) CGFloat leftMarginWidth;
@property (assign, nonatomic) CGFloat rightMarginWidth;
@property (assign, nonatomic) CGFloat scoreViewHeight;
@property (assign, nonatomic) CGFloat scaleGeometry;
@property (assign, nonatomic) CGFloat toolbarHeight;

@property (assign, nonatomic) int numRows;
@property (assign, nonatomic) int numCols;
@property (assign, nonatomic) CGFloat cellWidth;
@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) CGFloat rowHeight;
//@property (strong, nonatomic) UIImage *cellImage;
//@property (strong, nonatomic) UIImage *dotImage;
//@property (strong, nonatomic) UIImage *boundaryImage;
@property (assign, nonatomic) int numberOfPlayers;
@property (assign, nonatomic) int numberOfCells;
@property (assign, nonatomic) int paletteNumber;
@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) UIView *boardView;

//CGFloat;

//factory
#if defined(ADJUSTNUMBERROWSCOLS)
+ (instancetype)levelWithType:(LevelType)type andShape:(LevelShape)shape andSize:(LevelSize)size andNumberOfPlayers:(int)numPlayers
      andNavigationController:(UINavigationController *)navController andView:(UIView *)view andPalette:(int)paletteNum andIphoneRunning:(BOOL)isIphoneRunning
             andToolbarHeight:(CGFloat)tbHeight andNumRows:(int)numRows andNumCols:(int)numCols;
#else
+ (instancetype)levelWithType:(LevelType)type andShape:(LevelShape)shape andSize:(LevelSize)size andNumberOfPlayers:(int)numPlayers
        andNavigationController:(UINavigationController *)navController andView:(UIView *)view andPalette:(int)paletteNum andIphoneRunning:(BOOL)isIphoneRunning
             andToolbarHeight:(CGFloat)tbHeight;
#endif

//how many cols in this row?
- (int) numberOfCols:(int) row;

@end
