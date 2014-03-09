//
//  SCLevel.h
//  StringsAndCoins
//
//  Created by David S Reich on 7/02/2014.
//  Copyright (c) 2014 David S Reich. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@property (assign, nonatomic) LevelType levelType;
@property (assign, nonatomic) LevelShape levelShape;
@property (assign, nonatomic) LevelSize levelSize;
@property (assign, nonatomic) int screenWidth;
@property (assign, nonatomic) int screenHeight;
@property (assign, nonatomic) int boardWidth;
@property (assign, nonatomic) int boardHeight;
@property (assign, nonatomic) int numRows;
@property (assign, nonatomic) int numCols;
@property (assign, nonatomic) int cellWidth;
@property (assign, nonatomic) int cellHeight;
@property (assign, nonatomic) int rowHeight;
@property (strong, nonatomic) UIImage *cellImage;
@property (strong, nonatomic) UIImage *dotImage;
@property (strong, nonatomic) UIImage *boundaryImage;
@property (assign, nonatomic) int numberOfPlayers;

//factory
+ (instancetype)levelWithType:(LevelType)type andShape:(LevelShape)shape andSize:(LevelSize)size andNumberOfPlayers:(int)numPlayers
             andToolbarHeight:(int)toolbarHeight;

//how many cols in this row?
- (int) numberOfCols:(int) row;

@end
