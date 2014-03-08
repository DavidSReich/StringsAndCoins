//
//  SCLevel.m
//  StringsAndCoins
//
//  Created by David S Reich on 7/02/2014.
//  Copyright (c) 2014 David S Reich. All rights reserved.
//

#import "SCGLevel.h"
#import "constants.h"

@implementation SCGLevel

//factory
+ (instancetype) levelWithType:(LevelType)type andShape:(LevelShape)shape andSize:(LevelSize)size
{
	SCGLevel *level = [[SCGLevel alloc] init];

	level.levelType = type;
	level.levelShape = shape;
	level.levelSize = size;

	level.screenHeight = [UIScreen mainScreen].bounds.size.height;
	level.screenWidth = [UIScreen mainScreen].bounds.size.width;
	int boardWidth = level.screenHeight - (2 * kBoardMargin);
	int boardHeight = level.screenWidth - (2 * kBoardMargin);
	
	if (level.levelSize == SmallSize)
	{
		if (level.levelType == BoxesType)
		{
			//boxes have dots but no cell image
			level.dotImage = [UIImage imageNamed:@"dot-lg.png"];
			level.boundaryImage = [UIImage imageNamed:@"rope-lg-horz.png"];
		}
		else
		{
			//coins have cell image, but no dots
			level.cellImage = [UIImage imageNamed:@"coin-lg.png"];
			level.boundaryImage = [UIImage imageNamed:@"chain-lg-horz.png"];
		}

		level.cellWidth = kCellLargeWidth;
		
	}
	else if (level.levelSize == MediumSize)
	{
		if (level.levelType == BoxesType)
		{
//test
//			level.cellImage = [UIImage imageNamed:@"coin-md.png"];

			//boxes have dots but no cell image
			level.dotImage = [UIImage imageNamed:@"dot-md.png"];
//			level.boundaryImage = [UIImage imageNamed:@"rope-md-horz.png"];
			level.boundaryImage = [UIImage imageNamed:@"ellipse-md-horz.png"];
		}
		else
		{
			//coins have cell image, but no dots
			level.cellImage = [UIImage imageNamed:@"coin-md.png"];
			level.boundaryImage = [UIImage imageNamed:@"chain-md-horz.png"];
		}

		level.cellWidth = kCellMediumWidth;

#if 1   //testing
        if (level.levelShape == HexagonShape)
            level.cellWidth = (3 * level.cellWidth) / 4;
#endif
	}
	else	//must be large
	{
		if (level.levelType == BoxesType)
		{
			//boxes have dots but no cell image
			level.dotImage = [UIImage imageNamed:@"dot-sm.png"];
			level.boundaryImage = [UIImage imageNamed:@"rope-sm-horz.png"];
		}
		else
		{
			//coins have cell image, but no dots
			level.cellImage = [UIImage imageNamed:@"coin-sm.png"];
			level.boundaryImage = [UIImage imageNamed:@"chain-sm-horz.png"];
		}

		level.cellWidth = kCellSmallWidth;
	}

    level.cellHeight = level.cellWidth;
    
	//make these constants later
	if (level.levelShape == SquareShape)
	{
		level.numCols = boardWidth / level.cellWidth;
        level.rowHeight = level.cellHeight;
	}
	else if (level.levelShape == TriangleShape)
	{
		level.numCols = (boardWidth / level.cellWidth) * 2 - 1;
		if (level.numCols < level.numRows - 1)
		{
			level.numCols = level.numRows - 1;	//minimum # of cols
		}

		level.cellHeight = (float)(level.cellWidth / 2) * kSquareRootOf3;
        level.rowHeight = level.cellHeight;
	}
	else	//hexagons
	{
		level.cellWidth = (level.cellHeight * kSquareRootOf3) / 2;
        level.rowHeight = (3 * level.cellHeight) / 4;
		level.numCols = boardWidth / level.cellWidth;
	}

	level.numRows = boardHeight / level.rowHeight;
	if (level.levelShape == TriangleShape)
	{
		level.numRows = (level.numRows / 2) * 2; //force to an even # of rows.
        
        //min # rows == 2
        //min # cols == rows - 1
        if (level.numRows < 2)
            level.numRows = 2;
        if (level.numCols < level.numRows - 1)
            level.numCols = level.numRows - 1;
	}
    else if (level.levelShape == HexagonShape)
    {
        if (level.numRows % 2 == 0)
            level.numRows--;    //force to odd # of rows

        //min # rows == 3
        //min # cols == (rows + 1) / 2
        if (level.numRows < 3)
            level.numRows = 3;
        if (level.numCols < (level.numRows + 1) / 2)
            level.numCols = (level.numRows + 1) / 2;
    }

	return level;
}

- (int) numberOfCols:(int) row
{
	if (self.levelShape == SquareShape)
	{
		return self.numCols;
	}
	else if (self.levelShape == TriangleShape)
	{
		int rowOffsetForSize;
		
		//numRows is always even
		if (row <= (self.numRows / 2) - 1)
			rowOffsetForSize = ((self.numRows / 2) - 1) - row;
		else
			rowOffsetForSize = row - (self.numRows / 2);
		
		return self.numCols - (rowOffsetForSize * 2);
	}
	else	//hexagons later
	{
		int rowOffsetForSize;
		
		//numRows is always odd
		if (row <= ((self.numRows + 1) / 2) - 1)
			rowOffsetForSize = (((self.numRows + 1) / 2) - 1) - row;
		else
			rowOffsetForSize = row - ((self.numRows + 1) / 2) + 1;
		
		return self.numCols - rowOffsetForSize;
	}
}

@end
