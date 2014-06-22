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

#if true
    if (isIphoneRunning)
        level.statusBarOffset = 0;
    else
        level.statusBarOffset = kStatusBarHeight;
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        level.statusBarOffset = kStatusBarHeight;
    else
        level.statusBarOffset = 0;
#endif

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

    if (isIphoneRunning)
    {
        //scale margins
        CGFloat hRatio = view.bounds.size.height / 712.0;
        CGFloat wRatio = view.bounds.size.width / 1024;
        
        level.scaleGeometry = MIN(hRatio, wRatio);
    }

    level.topMarginHeight = (int)(kBoardMargin * level.scaleGeometry);
    level.bottomMarginHeight = (int)(kBoardMargin * level.scaleGeometry);
    level.leftMarginWidth = (int)(kBoardMargin * level.scaleGeometry);
    level.rightMarginWidth = (int)(kBoardMargin * level.scaleGeometry);
    level.scoreViewHeight = (int)(kScoreViewHeight * level.scaleGeometry);

    if (level.isIphone)
    {
        level.leftMarginWidth += tbHeight - level.scoreViewHeight;
        level.rightMarginWidth += kStatusBarHeight + level.scoreViewHeight;
        level.scoreViewHeight *= 2;
        
        if ((level.levelType == BoxesType) && (level.levelShape == HexagonShape) && (level.levelSize == SmallSize))
        {
            level.topMarginHeight += 10 * level.scaleGeometry;
            level.bottomMarginHeight += 10 * level.scaleGeometry;
        }
        else if ((level.levelType == CoinsType) && (level.levelShape == HexagonShape))
        {
            if (level.levelSize == SmallSize)
            {
//                level.topMarginHeight = kBoardMargin + kScoreViewHeight;
//                level.bottomMarginHeight = kBoardMargin + kScoreViewHeight;
                level.leftMarginWidth += kBoardMargin * .4f * level.scaleGeometry;
                level.rightMarginWidth += kBoardMargin * .4f * level.scaleGeometry;
            }
            else
            {
                level.leftMarginWidth += kScoreViewHeight * .5f * level.scaleGeometry;
                level.rightMarginWidth += kScoreViewHeight * .5f * level.scaleGeometry;
            }
        }
        else if ((level.levelType == CoinsType) && (level.levelShape == TriangleShape) && (level.levelSize == SmallSize))
        {
            level.leftMarginWidth += kScoreViewHeight * level.scaleGeometry;
            level.rightMarginWidth += kScoreViewHeight * level.scaleGeometry;
        }
    }
    else
    {
        if ((level.levelType == BoxesType) && (level.levelShape == HexagonShape) && (level.levelSize == SmallSize))
        {
            level.topMarginHeight += 10 * level.scaleGeometry;
            level.bottomMarginHeight += 10 * level.scaleGeometry;
        }
        else if ((level.levelType == CoinsType) && (level.levelShape == HexagonShape))
        {
            if (level.levelSize == SmallSize)
            {
//                level.topMarginHeight = kBoardMargin + kScoreViewHeight;
//                level.bottomMarginHeight = kBoardMargin + kScoreViewHeight;
                level.leftMarginWidth += kBoardMargin * level.scaleGeometry;
                level.rightMarginWidth += kBoardMargin * level.scaleGeometry;
            }
            else
            {
                level.leftMarginWidth += kScoreViewHeight * .5f * level.scaleGeometry;
                level.rightMarginWidth += kScoreViewHeight * .5f * level.scaleGeometry;
            }
        }
        else if ((level.levelType == CoinsType) && (level.levelShape == TriangleShape) && (level.levelSize == SmallSize))
        {
            level.leftMarginWidth += kScoreViewHeight * level.scaleGeometry;
            level.rightMarginWidth += kScoreViewHeight * level.scaleGeometry;
        }
    }

    CGFloat boardWidth = view.bounds.size.width - (level.leftMarginWidth + level.rightMarginWidth);
    CGFloat boardHeight = view.bounds.size.height - (level.topMarginHeight + level.bottomMarginHeight) - level.statusBarOffset;
    level.boardWidth = boardWidth;
    level.boardHeight = boardHeight;
    
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

#if !defined(LANDSCAPE_IPHONE)
        if (isIphoneRunning)
        {
//            int swapInt = level.numCols;
//            level.numCols = level.numRows;
//            level.numRows = swapInt;
        }
#endif

        //calculate maximum w & h
        level.cellWidth = boardWidth / level.numCols;
        if (level.levelType == CoinsType)
            level.cellHeight = boardHeight / (level.numRows + .5);   //need extra space for boundaries
        else
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

#if !defined(LANDSCAPE_IPHONE)
        if (isIphoneRunning)
        {
//            int swapInt = level.numCols;
//            level.numCols = level.numRows;
//            level.numRows = swapInt;
        }
#endif

        //calculate maximum w & h
        int numberOfWidths = (level.numCols + 1) / 2;
        
        level.cellWidth = boardWidth / numberOfWidths;
        level.cellHeight = boardHeight / level.numRows;

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

#if !defined(LANDSCAPE_IPHONE)
        if (isIphoneRunning)
        {
//            int swapInt = level.numCols;
//            level.numCols = level.numRows;
//            level.numRows = swapInt;
        }
#endif

        //calculate maximum w & h
        level.cellWidth = boardWidth / level.numCols;
        level.cellHeight = (boardHeight * 4) / (level.numRows * 3);

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
