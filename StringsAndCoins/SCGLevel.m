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
+ (instancetype) levelWithType:(LevelType)type andShape:(LevelShape)shape andSize:(LevelSize)size andNumberOfPlayers:(int)numPlayers
              andNavigationController:(UINavigationController *)navController
{
	SCGLevel *level = [[SCGLevel alloc] init];

	level.levelType = type;
	level.levelShape = shape;
	level.levelSize = size;
    level.numberOfPlayers = numPlayers;
    level.numberOfCells = 0;
    level.navigationController = navController;

	level.screenHeight = [UIScreen mainScreen].bounds.size.height;
	level.screenWidth = [UIScreen mainScreen].bounds.size.width;
	int boardWidth = level.screenHeight - (2 * kBoardMargin);
	int boardHeight = level.screenWidth - (2 * kBoardMargin) - navController.navigationBar.bounds.size.height
            - navController.toolbar.bounds.size.height;
    level.boardWidth = boardWidth;
    level.boardHeight = boardHeight;
	
	if (level.levelSize == SmallSize)
	{
		if (level.levelType == BoxesType)
		{
			//boxes have dots but no cell image
//			level.dotImage = [UIImage imageNamed:@"dot-lg.png"];
			level.dotImage = [UIImage imageNamed:@"dot-md.png"];
//			level.boundaryImage = [UIImage imageNamed:@"rope-lg-horz.png"];
			level.boundaryImage = [UIImage imageNamed:@"ellipse-md-horz.png"];
		}
		else
		{
			//coins have cell image, but no dots
//			level.cellImage = [UIImage imageNamed:@"coin-lg.png"];
			level.cellImage = [UIImage imageNamed:@"coin-md.png"];
//			level.boundaryImage = [UIImage imageNamed:@"chain-lg-horz.png"];
			level.boundaryImage = [UIImage imageNamed:@"ellipse-md-horz.png"];
		}
	}
	else if (level.levelSize == MediumSize)
	{
		if (level.levelType == BoxesType)
		{
			//boxes have dots but no cell image
			level.dotImage = [UIImage imageNamed:@"dot-md.png"];
			level.boundaryImage = [UIImage imageNamed:@"ellipse-md-horz.png"];
		}
		else
		{
			//coins have cell image, but no dots
			level.cellImage = [UIImage imageNamed:@"coin-md.png"];
//			level.boundaryImage = [UIImage imageNamed:@"chain-md-horz.png"];
			level.boundaryImage = [UIImage imageNamed:@"ellipse-md-horz.png"];
		}
	}
	else	//must be large
	{
		if (level.levelType == BoxesType)
		{
			//boxes have dots but no cell image
//			level.dotImage = [UIImage imageNamed:@"dot-sm.png"];
			level.dotImage = [UIImage imageNamed:@"dot-md.png"];
//			level.boundaryImage = [UIImage imageNamed:@"rope-sm-horz.png"];
			level.boundaryImage = [UIImage imageNamed:@"ellipse-md-horz.png"];
		}
		else
		{
			//coins have cell image, but no dots
//			level.cellImage = [UIImage imageNamed:@"coin-sm.png"];
			level.cellImage = [UIImage imageNamed:@"coin-md.png"];
//			level.boundaryImage = [UIImage imageNamed:@"chain-sm-horz.png"];
			level.boundaryImage = [UIImage imageNamed:@"ellipse-md-horz.png"];
		}
	}

	if (level.levelShape == SquareShape)
	{
        if (level.levelSize == SmallSize)
        {
            level.numCols = kSmallSquareCols;
            level.numRows = kSmallSquareRows;
        }
        else if (level.levelSize == MediumSize)
        {
            level.numCols = kMediumSquareCols;
            level.numRows = kMediumSquareRows;
        }
        else    //large
        {
            level.numCols = kLargeSquareCols;
            level.numRows = kLargeSquareRows;
        }

        //calculate maximum w & h
        level.cellWidth = boardWidth / level.numCols;
        level.cellHeight = boardHeight / level.numRows;
        //shrink to equilateral shape
        if (level.cellHeight > level.cellWidth)
            level.cellHeight = level.cellWidth;
        else if (level.cellWidth > level.cellHeight)
            level.cellWidth = level.cellHeight;

        level.rowHeight = level.cellHeight;
	}
	else if (level.levelShape == TriangleShape)
	{
        if (level.levelSize == SmallSize)
        {
            level.numCols = kSmallTriangleCols;
            level.numRows = kSmallTriangleRows;
        }
        else if (level.levelSize == MediumSize)
        {
            level.numCols = kMediumTriangleCols;
            level.numRows = kMediumTriangleRows;
        }
        else    //large
        {
            level.numCols = kLargeTriangleCols;
            level.numRows = kLargeTriangleRows;
        }

        //calculate maximum w & h
        int numberOfWidths = (level.numCols + 1) / 2;
        
        level.cellWidth = boardWidth / numberOfWidths;
        level.cellHeight = boardHeight / level.numRows;

        //shrink to equilateral shape
        int calculatedHeight = (float)(level.cellWidth / 2) * kSquareRootOf3;
        int calculatedWidth = (float)(level.cellHeight * 2) / kSquareRootOf3;
        
        if (level.cellHeight > calculatedHeight)
            level.cellHeight = calculatedHeight;
        else if (level.cellWidth > calculatedWidth)
            level.cellWidth = calculatedWidth;

        level.rowHeight = level.cellHeight;
	}
	else	//hexagons
	{
        if (level.levelSize == SmallSize)
        {
            level.numCols = kSmallHexagonCols;
            level.numRows = kSmallHexagonRows;
        }
        else if (level.levelSize == MediumSize)
        {
            level.numCols = kMediumHexagonCols;
            level.numRows = kMediumHexagonRows;
        }
        else    //large
        {
            level.numCols = kLargeHexagonCols;
            level.numRows = kLargeHexagonRows;
        }

        //calculate maximum w & h
        level.cellWidth = boardWidth / level.numCols;
        level.cellHeight = (boardHeight * 4) / (level.numRows * 3);

        //shrink to equilateral shape
        int calculatedHeight = (float)(level.cellWidth * 2) / kSquareRootOf3;
		int calculatedWidth = (level.cellHeight * kSquareRootOf3) / 2;
        
        if (level.cellHeight > calculatedHeight)
            level.cellHeight = calculatedHeight;
        else if (level.cellWidth > calculatedWidth)
            level.cellWidth = calculatedWidth;
        
        level.rowHeight = (3 * level.cellHeight) / 4;
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
