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
#if defined(ADJUSTNUMBERROWSCOLS)
+ (instancetype) levelWithType:(LevelType)type andShape:(LevelShape)shape andSize:(LevelSize)size andNumberOfPlayers:(int)numPlayers
       andNavigationController:(UINavigationController *)navController andView:(UIView *)view andPalette:(int)paletteNum andIphoneRunning:(BOOL)isIphoneRunning
              andToolbarHeight:(CGFloat)tbHeight andNumRows:(int)numRows andNumCols:(int)numCols
#else
+ (instancetype) levelWithType:(LevelType)type andShape:(LevelShape)shape andSize:(LevelSize)size andNumberOfPlayers:(int)numPlayers
            andNavigationController:(UINavigationController *)navController andView:(UIView *)view andPalette:(int)paletteNum andIphoneRunning:(BOOL)isIphoneRunning
            andToolbarHeight:(CGFloat)tbHeight
#endif
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

#if defined(ROWSCOLSFROMARRAY)
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
#endif

    if (isIphoneRunning)
    {
        //scale margins
        CGFloat hRatio = view.bounds.size.height / 712.0;
        CGFloat wRatio = view.bounds.size.width / 1024;
        
        level.scaleGeometry = MIN(hRatio, wRatio);
    }

    level.topMarginHeight = (int)(kBoardMargin * level.scaleGeometry);
    level.bottomMarginHeight = (int)(kBoardMargin * level.scaleGeometry);
#if defined(LANDSCAPE_IPHONE)
    if (level.isIphone)
    {
//        if (level.levelShape == HexagonShape)
//        {
//            level.leftMarginWidth = (int)(kBoardMargin * .6f * level.scaleGeometry);
//            level.rightMarginWidth = (int)(kBoardMargin * .6f * level.scaleGeometry);
//        }
//        else
        {
            level.leftMarginWidth = (int)(kBoardMargin * .2f * level.scaleGeometry);
            level.rightMarginWidth = (int)(kBoardMargin * .2f * level.scaleGeometry);
        }
    }
    else
    {
        level.leftMarginWidth = (int)(kBoardMargin * level.scaleGeometry);
        level.rightMarginWidth = (int)(kBoardMargin * level.scaleGeometry);
    }
#else
    level.leftMarginWidth = (int)(kBoardMargin * level.scaleGeometry);
    level.rightMarginWidth = (int)(kBoardMargin * level.scaleGeometry);
#endif
    level.scoreViewHeight = (int)(kScoreViewHeight * level.scaleGeometry);

#if defined(ADJUSTNUMBERROWSCOLS)
    //for testing #s of rows and columns
    //force size to "small" so margins will be larger??
    level.levelSize = SmallSize;
    level.numRows = numRows;
    level.numCols = numCols;

    //adjust rows and cols as needed

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

#endif
    
    if (level.isIphone)
    {
#if defined(LANDSCAPE_IPHONE)
        level.bottomMarginHeight += tbHeight;// - level.scoreViewHeight;
        level.scoreViewHeight *= 2;
        level.topMarginHeight += kStatusBarHeight + level.scoreViewHeight;
#else
#if true
        level.leftMarginWidth += tbHeight;// - level.scoreViewHeight;
        level.scoreViewHeight *= 2;
        level.rightMarginWidth += kStatusBarHeight + level.scoreViewHeight;
#else
        level.leftMarginWidth += tbHeight - level.scoreViewHeight;
        level.rightMarginWidth += kStatusBarHeight + level.scoreViewHeight;
        level.scoreViewHeight *= 2;
#endif

        if ((level.levelType == BoxesType) && (level.levelShape == HexagonShape) && (level.levelSize == SmallSize))
        {
//            level.topMarginHeight += 10 * level.scaleGeometry;
//            level.bottomMarginHeight += 10 * level.scaleGeometry;
        }
        else if ((level.levelType == CoinsType) && (level.levelShape == HexagonShape))
        {
#if true
//            level.topMarginHeight += kScoreViewHeight * .3f * level.scaleGeometry;
//            level.bottomMarginHeight += kScoreViewHeight * .3f * level.scaleGeometry;
//            level.leftMarginWidth += kScoreViewHeight * .5f * level.scaleGeometry;
//            level.rightMarginWidth += kScoreViewHeight * .5f * level.scaleGeometry;
#else
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
#endif
        }
        else if ((level.levelType == CoinsType) && (level.levelShape == TriangleShape) && (level.levelSize == SmallSize))
        {
//            level.leftMarginWidth += kScoreViewHeight * level.scaleGeometry;
//            level.rightMarginWidth += kScoreViewHeight * level.scaleGeometry;
        }
#endif
    }
    else    //not iPhone
    {
        if ((level.levelType == BoxesType) && (level.levelShape == HexagonShape) && (level.levelSize == SmallSize))
        {
//            level.topMarginHeight += 10 * level.scaleGeometry;
//            level.bottomMarginHeight += 10 * level.scaleGeometry;
        }
        else if ((level.levelType == CoinsType) && (level.levelShape == HexagonShape))
        {
            level.topMarginHeight += kScoreViewHeight * .3f * level.scaleGeometry;
            level.bottomMarginHeight += kScoreViewHeight * .3f * level.scaleGeometry;
//            level.leftMarginWidth += kScoreViewHeight * .5f * level.scaleGeometry;
//            level.rightMarginWidth += kScoreViewHeight * .5f * level.scaleGeometry;
        }
        else if ((level.levelType == CoinsType) && (level.levelShape == TriangleShape) && (level.levelSize == SmallSize))
        {
//            level.leftMarginWidth += kScoreViewHeight * level.scaleGeometry;
//            level.rightMarginWidth += kScoreViewHeight * level.scaleGeometry;
        }
    }

    CGFloat boardWidth = view.bounds.size.width - (level.leftMarginWidth + level.rightMarginWidth);
    CGFloat boardHeight = view.bounds.size.height - (level.topMarginHeight + level.bottomMarginHeight) - level.statusBarOffset;
    level.boardWidth = boardWidth;
    level.boardHeight = boardHeight;

#if defined(ROWSCOLSFROMARRAY)
    int iPadIPhoneIndex = 0;
    if (level.isIphone)
        iPadIPhoneIndex = 1;
    level.numRows = numberOfRowsAndCols[iPadIPhoneIndex][level.levelShape][level.levelSize].x;
    level.numCols = numberOfRowsAndCols[iPadIPhoneIndex][level.levelShape][level.levelSize].y;
#endif

	if (level.levelShape == SquareShape)
	{
#if !defined(ROWSCOLSFROMARRAY)
        if (level.levelSize == SmallSize)
        {
#if !defined(ADJUSTNUMBERROWSCOLS)
            level.numCols = kSmallSquareCols;
            level.numRows = kSmallSquareRows;
#endif
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
#endif

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
#if !defined(ROWSCOLSFROMARRAY)
        if (level.levelSize == SmallSize)
        {
#if !defined(ADJUSTNUMBERROWSCOLS)
            level.numCols = kSmallTriangleCols;
            level.numRows = kSmallTriangleRows;
#endif
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
#endif

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
#if !defined(ROWSCOLSFROMARRAY)
        if (level.levelSize == SmallSize)
        {
#if !defined(ADJUSTNUMBERROWSCOLS)
            level.numCols = kSmallHexagonCols;
            level.numRows = kSmallHexagonRows;
#endif
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
#endif

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
#if defined(LANDSCAPE_IPHONE)
        if (level.isIphone)
            level.cellWidth = boardWidth / (level.numCols + 1);   //need extra space for boundaries
#endif
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
