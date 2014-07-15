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
            andNavigationController:(UINavigationController *)navController andView:(UIView *)view andPalette:(int)paletteNum andIphoneRunning:(BOOL)isIphoneRunning
            andToolbarHeight:(CGFloat)tbHeight
{
	SCGLevel *level = [[SCGLevel alloc] init];

    if (isIphoneRunning)
        level.statusBarOffset = 0;
    else
        level.statusBarOffset = kStatusBarHeight;

    level.isIphone = isIphoneRunning;
	level.levelType = type;
	level.levelShape = shape;
	level.levelSize = size;
    level.numberOfPlayers = numPlayers;
    level.numberOfCells = 0;
    level.paletteNumber = paletteNum;
    level.navigationController = navController;
    level.boardView = view;
    level.toolbarHeight = tbHeight;

    //set level.sideMarginWidth, etc.
    level.statusBarHeight = kStatusBarHeight;

    level.scaleGeometry = 1.0;

    CGPoint numberOfRowsAndCols[2][kNumLevelShapes][kNumLevelSizes];

    //this is done mainly for readability
    //rows in x, cols in y
    //iPad
    numberOfRowsAndCols[0][SquareShape][SmallSize].x = 4;
    numberOfRowsAndCols[0][SquareShape][SmallSize].y = 5;
    numberOfRowsAndCols[0][SquareShape][MediumSize].x = 6;
    numberOfRowsAndCols[0][SquareShape][MediumSize].y = 10;
    numberOfRowsAndCols[0][SquareShape][LargeSize].x = 8;
    numberOfRowsAndCols[0][SquareShape][LargeSize].y = 14;
    
    numberOfRowsAndCols[0][TriangleShape][SmallSize].x = 4;
    numberOfRowsAndCols[0][TriangleShape][SmallSize].y = 9;
    numberOfRowsAndCols[0][TriangleShape][MediumSize].x = 6;
    numberOfRowsAndCols[0][TriangleShape][MediumSize].y = 15;
    numberOfRowsAndCols[0][TriangleShape][LargeSize].x = 8;
    numberOfRowsAndCols[0][TriangleShape][LargeSize].y = 21;
    
    numberOfRowsAndCols[0][HexagonShape][SmallSize].x = 5;
    numberOfRowsAndCols[0][HexagonShape][SmallSize].y = 7;
    numberOfRowsAndCols[0][HexagonShape][MediumSize].x = 7;
    numberOfRowsAndCols[0][HexagonShape][MediumSize].y = 9;
    numberOfRowsAndCols[0][HexagonShape][LargeSize].x = 9;
    numberOfRowsAndCols[0][HexagonShape][LargeSize].y = 13;

    //iPhone
    numberOfRowsAndCols[1][SquareShape][SmallSize].x = 5;
    numberOfRowsAndCols[1][SquareShape][SmallSize].y = 4;
    numberOfRowsAndCols[1][SquareShape][MediumSize].x = 8;
    numberOfRowsAndCols[1][SquareShape][MediumSize].y = 6;
    numberOfRowsAndCols[1][SquareShape][LargeSize].x = 10;
    numberOfRowsAndCols[1][SquareShape][LargeSize].y = 8;
    
    numberOfRowsAndCols[1][TriangleShape][SmallSize].x = 4;
    numberOfRowsAndCols[1][TriangleShape][SmallSize].y = 7;
    numberOfRowsAndCols[1][TriangleShape][MediumSize].x = 6;
    numberOfRowsAndCols[1][TriangleShape][MediumSize].y = 9;
    numberOfRowsAndCols[1][TriangleShape][LargeSize].x = 8;
    numberOfRowsAndCols[1][TriangleShape][LargeSize].y = 11;
    
    numberOfRowsAndCols[1][HexagonShape][SmallSize].x = 5;
    numberOfRowsAndCols[1][HexagonShape][SmallSize].y = 4;
    numberOfRowsAndCols[1][HexagonShape][MediumSize].x = 7;
    numberOfRowsAndCols[1][HexagonShape][MediumSize].y = 5;
    numberOfRowsAndCols[1][HexagonShape][LargeSize].x = 9;
    numberOfRowsAndCols[1][HexagonShape][LargeSize].y = 7;

    if (isIphoneRunning)
    {
        //scale margins
        CGFloat hRatio = view.bounds.size.height / 712.0;
        CGFloat wRatio = view.bounds.size.width / 1024;
        
        level.scaleGeometry = MIN(hRatio, wRatio);
    }

    level.topMarginHeight = (int)(kBoardMargin * level.scaleGeometry);
    level.bottomMarginHeight = (int)(kBoardMargin * level.scaleGeometry);
    if (level.isIphone)
    {
        level.leftMarginWidth = (int)(kBoardMargin * .8f * level.scaleGeometry);
        level.rightMarginWidth = (int)(kBoardMargin * .8f * level.scaleGeometry);
    }
    else
    {
        level.leftMarginWidth = (int)(kBoardMargin * level.scaleGeometry);
        level.rightMarginWidth = (int)(kBoardMargin * level.scaleGeometry);
    }

    level.scoreViewHeight = (int)(kScoreViewHeight * level.scaleGeometry);

    if (level.isIphone)
    {
        level.bottomMarginHeight += tbHeight;// - level.scoreViewHeight;
        level.scoreViewHeight *= 2;
        level.topMarginHeight += kStatusBarHeight + level.scoreViewHeight;
    }

    CGFloat boardWidth = view.bounds.size.width - (level.leftMarginWidth + level.rightMarginWidth);
    CGFloat boardHeight = view.bounds.size.height - (level.topMarginHeight + level.bottomMarginHeight) - level.statusBarOffset;
    level.boardWidth = boardWidth;
    level.boardHeight = boardHeight;

    int iPadIPhoneIndex = 0;
    if (level.isIphone)
        iPadIPhoneIndex = 1;
    level.numRows = numberOfRowsAndCols[iPadIPhoneIndex][level.levelShape][level.levelSize].x;
    level.numCols = numberOfRowsAndCols[iPadIPhoneIndex][level.levelShape][level.levelSize].y;

    CGFloat effectiveNumRows = level.numRows;
    CGFloat effectiveNumCols = level.numCols;

	if (level.levelShape == SquareShape)
	{
        if (level.levelType == CoinsType)
        {
            if (level.isIphone)
            {
                if (level.levelSize == SmallSize)
                {
                    effectiveNumCols += .2;
                    effectiveNumRows += .2;
                }
            }
            else
            {
                effectiveNumCols += .5;
                effectiveNumRows += .5;
            }
        }

        //calculate maximum w & h
        level.cellWidth = boardWidth / effectiveNumCols;
        level.cellHeight = boardHeight / effectiveNumRows;

        //shrink to equilateral shape
        if (level.cellHeight > level.cellWidth)
            level.cellHeight = level.cellWidth;
        else if (level.cellWidth > level.cellHeight)
            level.cellWidth = level.cellHeight;

        level.rowHeight = level.cellHeight;
	}
	else if (level.levelShape == TriangleShape)
	{
        //calculate maximum w & h
        effectiveNumCols = (effectiveNumCols + 1) / 2;
        
        if (level.levelType == CoinsType)
        {
            if (level.isIphone)
            {
                effectiveNumRows += .5;
            }
        }
        
        level.cellWidth = boardWidth / effectiveNumCols;
        level.cellHeight = boardHeight / effectiveNumRows;

        //shrink to equilateral shape
        CGFloat calculatedHeight = (float)(level.cellWidth / 2) * kSquareRootOf3;
        CGFloat calculatedWidth = (float)(level.cellHeight * 2) / kSquareRootOf3;
        
        if (level.cellHeight > calculatedHeight)
            level.cellHeight = calculatedHeight;
        else if (level.cellWidth > calculatedWidth)
            level.cellWidth = calculatedWidth;

        level.rowHeight = level.cellHeight;
	}
	else	//hexagons
	{
        if (level.levelType == CoinsType)
        {
            if (level.isIphone)
            {
                if (level.levelSize == SmallSize)
                {
                    effectiveNumCols += .3;
                    effectiveNumRows += .3;
                }
                else
                {
                    effectiveNumCols += .2;
                    effectiveNumRows += .2;
                }
            }
            else
            {
                effectiveNumCols += .2;
                effectiveNumRows += .2;
            }
        }
        
        //calculate maximum w & h
        level.cellWidth = boardWidth / effectiveNumCols;
        level.cellHeight = (boardHeight * 4) / (effectiveNumRows * 3);

        //shrink to equilateral shape
        CGFloat calculatedHeight = (float)(level.cellWidth * 2) / kSquareRootOf3;
		CGFloat calculatedWidth = (level.cellHeight * kSquareRootOf3) / 2;
        
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
