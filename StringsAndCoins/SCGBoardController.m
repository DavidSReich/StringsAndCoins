//
//  SCBoardController.m
//  StringsAndCoins
//
//  Created by David S Reich on 9/02/2014.
//  Copyright (c) 2014 David S Reich. All rights reserved.
//

#import "SCGBoardController.h"
#import "SCGCellView.h"
#import "SCGBoundaryView.h"
#import "SCGLevel.h"
#import "SCGDotView.h"
#import "SCGPlayer.h"
#import "SCGGamePlayer.h"
#import "SCGScoreView.h"
#import "constants.h"

@implementation SCGBoardController
{
	//item lists
	NSMutableArray *cells;
	NSMutableArray *horizontalBoundaries;
	NSMutableArray *verticalBoundaries;
	NSMutableArray *dots;
    NSMutableArray *players;
    NSMutableArray *scoreViews;
    int currentPlayer;
    int lastPlayer;
    int numberOfPlayers;
}

- (void) clearGameBoard
{
    for (NSMutableArray *row in cells)
        [row removeAllObjects];
	[cells removeAllObjects];
    for (NSMutableArray *row in horizontalBoundaries)
        [row removeAllObjects];
	[horizontalBoundaries removeAllObjects];
    for (NSMutableArray *row in verticalBoundaries)
        [row removeAllObjects];
	[verticalBoundaries removeAllObjects];
    for (NSMutableArray *row in dots)
        [row removeAllObjects];
    [dots removeAllObjects];
	[players removeAllObjects];
	[scoreViews removeAllObjects];
    
    for (UIView *view in self.boardView.subviews)
        [view removeFromSuperview];
}

- (void) setupGameBoard:(SCGLevel *)level
{
    [self clearGameBoard];

    self.lastBoundary = nil;
	self.level = level;

    level.numberOfCells = 0;

	self.boardView.layer.borderWidth = 3.f;
    self.boardView.layer.borderColor = [UIColor redColor].CGColor;
    
	//cells
	CGFloat xOffset = 0;
	CGFloat yOffset = level.statusBarOffset;

	cells = [[NSMutableArray alloc] initWithCapacity:level.numRows];
	
	for (int r = 0; r < level.numRows; r++)
	{
		[cells addObject:[NSMutableArray array]];

        if (level.levelShape == SquareShape)
        {
            BOOL topHalf = (r <= level.numRows / 2);
            int numCols = [level numberOfCols:r];
            
            xOffset = kBoardMargin + level.cellWidth / 2;
            yOffset = kBoardMargin + level.rowHeight / 2 + level.statusBarOffset;
            
            xOffset += (level.boardWidth - (level.cellWidth * level.numCols)) / 2;
            yOffset += (level.boardHeight - (level.cellHeight * level.numRows)) / 2;
            
            for (int c = 0; c < numCols; c++)
            {
                //set center
                CGPoint cellCenter = CGPointMake(xOffset + c * level.cellWidth, yOffset + r * level.rowHeight);
                SCGCellView *cell = [[SCGCellView alloc] initWithLevel:level andRow:r andCol:c andTopHalf:topHalf andCenter:cellCenter];
                [[cells objectAtIndex:r] addObject:cell];
                //add to view
                [self.boardView addSubview:cell];

                level.numberOfCells++;
            }
        }
        else if (level.levelShape == TriangleShape)
        {
            BOOL topHalf = (r < (level.numRows / 2));
            int rowDelta;

            if (topHalf)
                rowDelta = (level.numRows / 2) - r;
            else
                rowDelta = r - (level.numRows / 2) + 1;

            int numCols = [level numberOfCols:r];

            xOffset = kBoardMargin + (level.cellWidth / 2) * rowDelta;
            yOffset = kBoardMargin + level.rowHeight / 2 + level.statusBarOffset;
            
            xOffset += (level.boardWidth - (level.cellWidth * (level.numCols + 1) / 2)) / 2;
            yOffset += (level.boardHeight - (level.rowHeight * level.numRows)) / 2;
            
            for (int c = 0; c < numCols; c++)
            {
                //set center
                CGPoint cellCenter = CGPointMake(xOffset + (c * level.cellWidth / 2), yOffset + r * level.rowHeight);
                SCGCellView *cell = [[SCGCellView alloc] initWithLevel:level andRow:r andCol:c andTopHalf:topHalf andCenter:cellCenter];
                [[cells objectAtIndex:r] addObject:cell];
                //add to view
                [self.boardView addSubview:cell];
                
                level.numberOfCells++;
            }
        }
        else    //hexagons
        {
            BOOL topHalf = (r < (level.numRows + 1) / 2);
            int rowDelta;
            
            if (topHalf)
                rowDelta = ((level.numRows + 1) / 2) - r;
            else
                rowDelta = r - ((level.numRows + 1) / 2) + 2;
            
            int numCols = [level numberOfCols:r];
            
            xOffset = kBoardMargin + (level.cellWidth / 2) * rowDelta;
            yOffset = kBoardMargin + level.rowHeight / 2 + level.statusBarOffset;
            xOffset += (level.boardWidth - (level.cellWidth * level.numCols)) / 2;
            yOffset += (level.boardHeight - (level.rowHeight * level.numRows)) / 2;
            
            for (int c = 0; c < numCols; c++)
            {
                //set center
                CGPoint cellCenter = CGPointMake(xOffset + c * level.cellWidth, yOffset + r * level.rowHeight);
                SCGCellView *cell = [[SCGCellView alloc] initWithLevel:level andRow:r andCol:c andTopHalf:topHalf andCenter:cellCenter];
                [[cells objectAtIndex:r] addObject:cell];
                //add to view
                [self.boardView addSubview:cell];
                
                level.numberOfCells++;
            }
        }
    }
    
	//horizontal boundaries
	xOffset = kBoardMargin + level.cellWidth / 2;
    yOffset = kBoardMargin + level.statusBarOffset;
    yOffset += (level.boardHeight - (level.rowHeight * level.numRows)) / 2;

    if (level.levelShape == SquareShape)
        xOffset += (level.boardWidth - (level.cellWidth * level.numCols)) / 2;
    
	horizontalBoundaries = [[NSMutableArray alloc] initWithCapacity:level.numRows + 1];
	
	for (int r = 0; r < level.numRows + 1; r++)
	{
		[horizontalBoundaries addObject:[NSMutableArray array]];
		
        if (level.levelShape == SquareShape)
        {
            BOOL topHalf = (r <= level.numRows / 2);
            
            int numCols = [level numberOfCols:r];
            
            for (int c = 0; c < numCols; c++)
            {
                SCGBoundaryView *boundary = [[SCGBoundaryView alloc] initWithLevel:level andRow:r andCol:c andTopHalf:topHalf andOrientation:Horizontal];
                [[horizontalBoundaries objectAtIndex:r] addObject:boundary];
                //set center
                //add to view
                boundary.center = CGPointMake(xOffset + c * level.cellWidth, yOffset + r * level.rowHeight);
                boundary.board = self;
                [self.boardView addSubview:boundary];
            }
        }
        else if (level.levelShape == TriangleShape)
        {
            BOOL topHalf = (r < (level.numRows / 2));
            int rowDelta;
            int numCols;

            if (topHalf)
            {
                numCols = ([level numberOfCols:r - 1] + 1) / 2;
                rowDelta = ((level.numRows / 2) + 1) - r;
            }
            else
            {
                numCols = ([level numberOfCols:r] + 1) / 2;
                rowDelta = r - (level.numRows / 2) + 1;
            }

            xOffset = kBoardMargin + (level.cellWidth / 2) * rowDelta;
            xOffset += (level.boardWidth - (level.cellWidth * (level.numCols + 1) / 2)) / 2;
            
            for (int c = 0; c < numCols; c++)
            {
                SCGBoundaryView *boundary = [[SCGBoundaryView alloc] initWithLevel:level andRow:r andCol:c andTopHalf:topHalf andOrientation:Horizontal];
                [[horizontalBoundaries objectAtIndex:r] addObject:boundary];
                //set center
                //add to view
                boundary.center = CGPointMake(xOffset + c * level.cellWidth, yOffset + r * level.rowHeight);
                boundary.board = self;
                [self.boardView addSubview:boundary];
            }
        }
        else    //hexagons
        {
            BOOL topHalf = (r < (level.numRows + 1) / 2);
            int rowDelta;
            int numCols;
            BoundaryOrientation orientation;
            
            if (topHalf)
            {
                numCols = [level numberOfCols:r] * 2;
                rowDelta = ((level.numRows + 1) / 2) - r - 1;
            }
            else
            {
                numCols = [level numberOfCols:r - 1] * 2;
                rowDelta = r - ((level.numRows + 1) / 2);
            }

            xOffset = kBoardMargin + level.cellWidth / 4 + (level.cellWidth / 2) * rowDelta;
            xOffset += (level.boardWidth - (level.cellWidth * level.numCols)) / 2;

            for (int c = 0; c < numCols; c++)
            {
                if (topHalf == (c % 2 == 0))
                    orientation = HorizontalRight;
                else
                    orientation = HorizontalLeft;
                
                SCGBoundaryView *boundary = [[SCGBoundaryView alloc] initWithLevel:level andRow:r andCol:c andTopHalf:topHalf andOrientation:orientation];
                [[horizontalBoundaries objectAtIndex:r] addObject:boundary];
                //set center
                //add to view
                boundary.center = CGPointMake(xOffset + (c * level.cellWidth) / 2, yOffset + r * level.rowHeight);
                boundary.board = self;
                [self.boardView addSubview:boundary];
            }
        }
	}

	//vertical boundaries
    //triangles need different xOffsets, odd and even -- and angles too
	xOffset = kBoardMargin;
	yOffset = kBoardMargin + level.rowHeight / 2 + level.statusBarOffset;
    yOffset += (level.boardHeight - (level.rowHeight * level.numRows)) / 2;

	verticalBoundaries = [[NSMutableArray alloc] initWithCapacity:level.numRows + 1];
	
    if (level.levelShape == SquareShape)
        xOffset += (level.boardWidth - (level.cellWidth * level.numCols)) / 2;

	for (int r = 0; r < level.numRows; r++)
	{
		[verticalBoundaries addObject:[NSMutableArray array]];
		
		BOOL topHalf = (r <= level.numRows / 2);
        BoundaryOrientation orientation;
		
		int numCols = [level numberOfCols:r] + 1;
        
        if (level.levelShape == SquareShape)
        {
            for (int c = 0; c < numCols; c++)
            {
                orientation = Vertical;
                
                SCGBoundaryView *boundary = [[SCGBoundaryView alloc] initWithLevel:level andRow:r andCol:c andTopHalf:topHalf andOrientation:orientation];
                [[verticalBoundaries objectAtIndex:r] addObject:boundary];
                //set center
                //add to view
                boundary.center = CGPointMake(xOffset + c * level.cellWidth, yOffset + r * level.rowHeight);
                boundary.board = self;
                [self.boardView addSubview:boundary];
            }
        }
        else if (level.levelShape == TriangleShape)
        {
            BOOL topHalf = (r < (level.numRows / 2));
            int rowDelta;
            
            if (topHalf)
                rowDelta = (level.numRows / 2) - r - 1;
            else
                rowDelta = r - (level.numRows / 2);
            
            xOffset = kBoardMargin + (level.cellWidth / 4) + (level.cellWidth / 2) * rowDelta;
            xOffset += (level.boardWidth - (level.cellWidth * ((level.numCols + 1) / 2))) / 2;

            for (int c = 0; c < numCols; c++)
            {
                if (topHalf == (c % 2 == 0))
                    orientation = VerticalRight;
                else
                    orientation = VerticalLeft;
                
                SCGBoundaryView *boundary = [[SCGBoundaryView alloc] initWithLevel:level andRow:r andCol:c andTopHalf:topHalf andOrientation:orientation];
                [[verticalBoundaries objectAtIndex:r] addObject:boundary];
                //set center
                //add to view
                boundary.center = CGPointMake(xOffset + (c * level.cellWidth) / 2, yOffset + r * level.rowHeight);
                boundary.board = self;
                [self.boardView addSubview:boundary];
            }
        }
        else    //hexagons
        {
            BOOL topHalf = (r < (level.numRows + 1) / 2);
            int rowDelta;
            
            if (topHalf)
                rowDelta = ((level.numRows + 1) / 2) - r;
            else
                rowDelta = r - ((level.numRows + 1) / 2) + 2;
            
            int numCols = [level numberOfCols:r] + 1;
            
            xOffset = kBoardMargin + (level.cellWidth / 2) * (rowDelta - 1);
            xOffset += (level.boardWidth - (level.cellWidth * level.numCols)) / 2;
            
            for (int c = 0; c < numCols; c++)
            {
                orientation = Vertical;
                
                SCGBoundaryView *boundary = [[SCGBoundaryView alloc] initWithLevel:level andRow:r andCol:c andTopHalf:topHalf andOrientation:orientation];
                [[verticalBoundaries objectAtIndex:r] addObject:boundary];
                //set center
                //add to view
                boundary.center = CGPointMake(xOffset + c * level.cellWidth, yOffset + r * level.rowHeight);
                boundary.board = self;
                [self.boardView addSubview:boundary];
            }
        }
	}

    //grid for Boxes
    if (level.levelType == BoxesType)
    {
        dots = [[NSMutableArray alloc] initWithCapacity:level.numRows + 1];
        
        if (level.levelShape == SquareShape)
        {
            xOffset = kBoardMargin;
            yOffset = kBoardMargin + level.statusBarOffset;
            
            xOffset += (level.boardWidth - (level.cellWidth * level.numCols)) / 2;
            yOffset += (level.boardHeight - (level.cellHeight * level.numRows)) / 2;

            for (int r = 0; r < level.numRows + 1; r++)
            {
                [dots addObject:[NSMutableArray array]];
                
                for (int c = 0; c < level.numCols + 1; c++)
                {
                    SCGDotView *dot = [[SCGDotView alloc] initWithLevel:level];
                    [[dots objectAtIndex:r] addObject:dot];
                    //set center
                    //add to view
                    dot.center = CGPointMake(xOffset + c * level.cellWidth, yOffset + r * level.rowHeight);
                    [self.boardView addSubview:dot];
                }
            }
        }
        else if (level.levelShape == TriangleShape)
        {
            int numColDots;

            yOffset = kBoardMargin + level.statusBarOffset;
            yOffset += (level.boardHeight - (level.rowHeight * level.numRows)) / 2;

            for (int r = 0; r < level.numRows + 1; r++)
            {
                BOOL topHalf = (r < (level.numRows / 2) + 1);
                int rowDelta = r - (level.numRows / 2);
                int rowForCols = r - 1;

                if (topHalf)
                {
                    rowForCols++;
                    rowDelta = -rowDelta;
                }

                numColDots = ([level numberOfCols:rowForCols] + 1) / 2;
                xOffset = kBoardMargin + (level.cellWidth / 2) * rowDelta;
                xOffset += (level.boardWidth - (level.cellWidth * (level.numCols + 1) / 2)) / 2;

                if (r == level.numRows / 2)
                    numColDots++;

                [dots addObject:[NSMutableArray array]];
                
                for (int c = 0; c < numColDots; c++)
                {
                    SCGDotView *dot = [[SCGDotView alloc] initWithLevel:level];
                    [[dots objectAtIndex:r] addObject:dot];
                    //set center
                    //add to view
                    dot.center = CGPointMake(xOffset + c * level.cellWidth, yOffset + r * level.rowHeight);
                    [self.boardView addSubview:dot];
//                    if (topHalf)
//                        dot.backgroundColor = [UIColor greenColor];
//                    else
//                        dot.backgroundColor = [UIColor redColor];
                }
            }
        }
        else    //hexagons
        {
            int numColDots;
            
            yOffset = kBoardMargin + level.statusBarOffset;
            yOffset += (level.boardHeight - (level.rowHeight * level.numRows)) / 2;

            for (int r = 0; r < level.numRows + 1; r++)
            {
                BOOL topHalf = (r < (level.numRows + 1) / 2);
                int rowDelta;
                
                if (topHalf)
                {
                    numColDots = [level numberOfCols:r] * 2 + 1;
                    rowDelta = ((level.numRows + 1) / 2) - r - 1;
                }
                else
                {
                    numColDots = [level numberOfCols:r - 1] * 2 + 1;
                    rowDelta = r - ((level.numRows + 1) / 2);
                }
                
                xOffset = kBoardMargin + (level.cellWidth / 2) * rowDelta;
                xOffset += (level.boardWidth - (level.cellWidth * level.numCols)) / 2;
                
                [dots addObject:[NSMutableArray array]];
                
                for (int c = 0; c < numColDots; c++)
                {
#if defined(SHOWROWANDCOL)
                    SCGDotView *dot = [[SCGDotView alloc] initWithLevel:level andRow:r andCol:c];
#else
                    SCGDotView *dot = [[SCGDotView alloc] initWithLevel:level];
#endif
                    [[dots objectAtIndex:r] addObject:dot];

                    CGFloat yOffsetOffset;
                    if (topHalf == (c % 2 == 0))
                        yOffsetOffset = yOffset + level.cellHeight / 8;
                    else
                        yOffsetOffset = yOffset - level.cellHeight / 8;
                    //set center
                    //add to view
                    dot.center = CGPointMake(xOffset + (c * level.cellWidth) / 2, yOffsetOffset + r * level.rowHeight);
                    [self.boardView addSubview:dot];
//                    if (topHalf)
//                        dot.backgroundColor = [UIColor greenColor];
//                    else
//                        dot.backgroundColor = [UIColor redColor];
                }
            }
        }
    }
    
    //players will come from outside later
    numberOfPlayers = level.numberOfPlayers;
    players = [[NSMutableArray alloc] initWithCapacity:numberOfPlayers];
    
    for (int p = 0; p < numberOfPlayers; p++)
    {
        SCGPlayer *player = [SCGPlayer alloc];
        UIColor *color;
        if (p == 0)
            color = [UIColor redColor];
        else if (p == 1)
            color = [UIColor greenColor];
        else if (p == 2)
            color = [UIColor yellowColor];
        else //if (p == 3)
            color = [UIColor cyanColor];
        SCGGamePlayer *gamePlayer = [[SCGGamePlayer alloc] initWithPlayer:player andColor:(UIColor *)color];
        [players addObject:gamePlayer];
    }

    currentPlayer = 0;

    //scores
    CGFloat xWidthCenter = kBoardMargin + (level.boardWidth / 2);
    CGFloat yHeightCenter = kBoardMargin + (level.boardHeight / 2) + level.statusBarOffset;

    scoreViews = [[NSMutableArray alloc] initWithCapacity:4];
    SCGScoreView *scoreView;
    scoreView = [[SCGScoreView alloc] initWithLevel:level andOrientation:LeftScore andPlayers:players andWidth:level.boardHeight];
    [scoreViews addObject:scoreView];
    [self.boardView addSubview:scoreView];
    scoreView.center = CGPointMake(kStatusBarHeight, yHeightCenter);

    scoreView = [[SCGScoreView alloc] initWithLevel:level andOrientation:RightScore andPlayers:players andWidth:level.boardHeight];
    [scoreViews addObject:scoreView];
    [self.boardView addSubview:scoreView];
    scoreView.center = CGPointMake(kBoardMargin * 2 + level.boardWidth - kStatusBarHeight - 2, yHeightCenter);

    scoreView = [[SCGScoreView alloc] initWithLevel:level andOrientation:TopScore andPlayers:players andWidth:level.boardWidth];
    [scoreViews addObject:scoreView];
    [self.boardView addSubview:scoreView];
    scoreView.center = CGPointMake(xWidthCenter, scoreView.bounds.size.height / 2 + level.statusBarOffset);

    scoreView = [[SCGScoreView alloc] initWithLevel:level andOrientation:BottomScore andPlayers:players andWidth:level.boardWidth];
    [scoreViews addObject:scoreView];
    [self.boardView addSubview:scoreView];
    scoreView.center = CGPointMake(xWidthCenter, kBoardMargin * 2 + level.boardHeight);
}

- (void) boundaryClicked:(SCGBoundaryView *)boundary
{
    if (self.lastBoundary)
        [self.lastBoundary LockBoundary];
    self.lastBoundary = boundary;
    BOOL completedACell = [self testCells];
    if (completedACell)
    {
        if ([self testBoard])
        {
            //all done!
        }
    }
    else
        [self testBoard];   //want to count and update scores

    if (!completedACell)
        [self gotoNextPlayer];
    else
        lastPlayer = currentPlayer;
}

- (void) boundaryDoubleClicked
{
    //uncheck cells
    [self testCells];
    [self testBoard];
    [self gotoPreviousPlayer];
    self.lastBoundary = nil;
}

- (BOOL) testCells
{
    BOOL completedACell = NO;
    
    if (self.lastBoundary == nil)
        return completedACell;

    int row = self.lastBoundary.row;
    int col = self.lastBoundary.col;
    
    //check cells
    if (self.level.levelShape == SquareShape)
    {
        if (self.lastBoundary.orientation == Horizontal)
        {
            //cell above
            if (row > 0)
            {
                if ([self testCell:row - 1 andCol:col])
                    completedACell = YES;
            }
            //and below
            if (row < self.level.numRows)
            {
                 if ([self testCell:row andCol:col])
                     completedACell = YES;
            }
        }
        else
        {
            //cell left
            if (col > 0)
            {
                if ([self testCell:row andCol:col - 1])
                    completedACell = YES;
            }
            //and right
            if (col < self.level.numCols)
            {
                if ([self testCell:row andCol:col])
                    completedACell = YES;
            }
        }
    }
    else if (self.level.levelShape == TriangleShape)
    {
        if (self.lastBoundary.orientation == Horizontal)
        {
            BOOL topHalf;
            
            //cell above
            if (row > 0)
            {
                topHalf = (row < self.level.numRows / 2 + 1);
                if (topHalf)
                {
                    if ([self testCell:row - 1 andCol:col * 2])
                        completedACell = YES;
                }
                else
                {
                    if ([self testCell:row - 1 andCol:(col * 2) + 1])
                        completedACell = YES;
                }
            }

            //and below
            if (row < self.level.numRows)
            {
                topHalf = (row < self.level.numRows / 2);
                if (topHalf)
                {
                    if ([self testCell:row andCol:(col * 2) + 1])
                        completedACell = YES;
                }
                else
                {
                    if ([self testCell:row andCol:col * 2])
                        completedACell = YES;
                }
            }
        }
        else if (self.lastBoundary.orientation == VerticalLeft)
        {
            //cell left
            if (col > 0)
            {
                if ([self testCell:row andCol:col - 1])
                    completedACell = YES;
            }

            //and right
            if (col < [self.level numberOfCols:row])
            {
                if ([self testCell:row andCol:col])
                    completedACell = YES;
            }
        }
        else    //must be VerticalRight - code looks the same as VerticalLeft
        {
            //cell left
            if (col > 0)
            {
                if ([self testCell:row andCol:col - 1])
                    completedACell = YES;
            }

            //and right
            if (col < [self.level numberOfCols:row])
            {
                if ([self testCell:row andCol:col])
                    completedACell = YES;
            }
        }
    }
    else    //hexagons
    {
        BOOL topHalf = (row < (self.level.numRows + 1) / 2 );

        if (self.lastBoundary.orientation == Vertical)
        {
            //cell left
            if (col > 0)
            {
                if ([self testCell:row andCol:col - 1])
                    completedACell = YES;
            }

            //and right
            if (col < [self.level numberOfCols:row])
            {
                if ([self testCell:row andCol:col])
                    completedACell = YES;
            }
        }
        else if (self.lastBoundary.orientation == HorizontalLeft)
        {
            //cell above
            if (row > 0)
            {
                if (topHalf)
                {
                    if (col < [self.level numberOfCols:row - 1] * 2)
                    {
                        if ([self testCell:row - 1 andCol:(col - 1) / 2])
                            completedACell = YES;
                    }
                }
                else
                {
                    if ([self testCell:row - 1 andCol:col / 2])
                        completedACell = YES;
                }
            }
            
            //and below
            if (row < self.level.numRows)
            {
                if (topHalf)
                {
                    if ([self testCell:row andCol:(col - 1) / 2])
                        completedACell = YES;
                }
                else
                {
                    if (col > 0)
                    {
                        if ([self testCell:row andCol:(col / 2) - 1])
                            completedACell = YES;
                    }
                }
            }
        }
        else    //must be HorizontalRight
        {
            //cell above
            if (row > 0)
            {
                if (topHalf)
                {
                    if (col > 0)
                    {
                        if ([self testCell:row - 1 andCol:(col / 2) - 1])
                            completedACell = YES;
                    }
                }
                else
                {
                    if ([self testCell:row - 1 andCol:(col - 1) / 2])
                        completedACell = YES;
                }
            }
            
            //and below
            if (row < self.level.numRows)
            {
                if (topHalf)
                {
                    if ([self testCell:row andCol:col / 2])
                        completedACell = YES;
                }
                else
                {
                    if (col < [self.level numberOfCols:row] * 2)
                    {
                        if ([self testCell:row andCol:(col - 1) / 2])
                            completedACell = YES;
                    }
                }
            }
        }
    }

    return completedACell;
}

- (BOOL) testCell:(int)row andCol:(int)col
{
    NSLog(@"TestCell R:%d C:%d", row, col);

    BOOL cellIsComplete = NO;
    SCGBoundaryView *boundary;
    SCGCellView *cell = [[cells objectAtIndex:row] objectAtIndex:col];
    if (cell == nil)
        NSLog(@"uh oh ... no cell!");
    
	//check all boundaries
    //if all complete, then cell is complete
    if (self.level.levelShape == SquareShape)
    {
        NSLog(@"    HBoundary R:%d C:%d", row, col);
        boundary = [[horizontalBoundaries objectAtIndex:row] objectAtIndex:col];
        if (boundary.complete)
        {
            NSLog(@"    HBoundary R:%d C:%d", row + 1, col);
            boundary = [[horizontalBoundaries objectAtIndex:row + 1] objectAtIndex:col];
            if (boundary.complete)
            {
                NSLog(@"    VBoundary R:%d C:%d", row, col);
                boundary = [[verticalBoundaries objectAtIndex:row] objectAtIndex:col];
                if (boundary.complete)
                {
                    NSLog(@"    VBoundary R:%d C:%d", row, col + 1);
                    boundary = [[verticalBoundaries objectAtIndex:row] objectAtIndex:col + 1];
                    if (boundary.complete)
                    {
                        cellIsComplete = YES;
                    }
                }
            }
        }
    }
    else if (self.level.levelShape == TriangleShape)
    {
        NSLog(@"    VBoundary R:%d C:%d", row, col);
        boundary = [[verticalBoundaries objectAtIndex:row] objectAtIndex:col];
        if (boundary.complete)
        {
            NSLog(@"    VBoundary R:%d C:%d", row, col + 1);
            boundary = [[verticalBoundaries objectAtIndex:row] objectAtIndex:col + 1];
            if (boundary.complete)
            {
                if (cell.isUpTriangle)
                {
                    if (cell.topHalf)
                    {
                        NSLog(@"    HBoundary R:%d C:%d", row + 1, col / 2);
                        boundary = [[horizontalBoundaries objectAtIndex:row + 1] objectAtIndex:col / 2];
                    }
                    else
                    {
                        NSLog(@"    HBoundary R:%d C:%d", row + 1, (col - 1) / 2);
                        boundary = [[horizontalBoundaries objectAtIndex:row + 1] objectAtIndex:(col - 1) / 2];
                    }
                }
                else
                {
                    if (cell.topHalf)
                    {
                        NSLog(@"    HBoundary R:%d C:%d", row, (col - 1) / 2);
                        boundary = [[horizontalBoundaries objectAtIndex:row] objectAtIndex:(col - 1) / 2];
                    }
                    else
                    {
                        NSLog(@"    HBoundary R:%d C:%d", row, col / 2);
                        boundary = [[horizontalBoundaries objectAtIndex:row] objectAtIndex:col / 2];
                    }
                }
                if (boundary.complete)
                {
                    cellIsComplete = YES;
                }
            }
        }
    }
    else    //hexagons
    {
        NSLog(@"    VBoundary R:%d C:%d", row, col);
        boundary = [[verticalBoundaries objectAtIndex:row] objectAtIndex:col];
        if (boundary.complete)
        {
            NSLog(@"    VBoundary R:%d C:%d", row, col + 1);
            boundary = [[verticalBoundaries objectAtIndex:row] objectAtIndex:col + 1];
            if (boundary.complete)
            {
                NSLog(@"    HBoundary R:%d C:%d", row, (col * 2) + 1);
                boundary = [[horizontalBoundaries objectAtIndex:row] objectAtIndex:(col * 2) + 1];
                if (boundary.complete)
                {
                    NSLog(@"    HBoundary R:%d C:%d", row + 1, (col * 2) + 1);
                    boundary = [[horizontalBoundaries objectAtIndex:row + 1] objectAtIndex:(col * 2) + 1];
                    if (boundary.complete)
                    {
                        if (row == (self.level.numRows - 1) / 2)    //middle row
                        {
                            NSLog(@"    HBoundary R:%d C:%d", row, col * 2);
                            boundary = [[horizontalBoundaries objectAtIndex:row] objectAtIndex:col * 2];
                            if (boundary.complete)
                            {
                                NSLog(@"    HBoundary R:%d C:%d", row + 1, col * 2);
                                boundary = [[horizontalBoundaries objectAtIndex:row + 1] objectAtIndex:col * 2];
                                if (boundary.complete)
                                {
                                    cellIsComplete = YES;
                                }
                            }
                        }
                        else  if (cell.topHalf)
                        {
                            NSLog(@"    HBoundary R:%d C:%d", row, col * 2);
                            boundary = [[horizontalBoundaries objectAtIndex:row] objectAtIndex:col * 2];
                            if (boundary.complete)
                            {
                                NSLog(@"    HBoundary R:%d C:%d", row + 1, (col + 1) * 2);
                                boundary = [[horizontalBoundaries objectAtIndex:row + 1] objectAtIndex:(col + 1) * 2];
                                if (boundary.complete)
                                {
                                    cellIsComplete = YES;
                                }
                            }
                        }
                        else    //must be bottom
                        {
                            NSLog(@"    HBoundary R:%d C:%d", row, (col + 1) * 2);
                            boundary = [[horizontalBoundaries objectAtIndex:row] objectAtIndex:(col + 1) * 2];
                            if (boundary.complete)
                            {
                                NSLog(@"    HBoundary R:%d C:%d", row + 1, col * 2);
                                boundary = [[horizontalBoundaries objectAtIndex:row + 1] objectAtIndex:col * 2];
                                if (boundary.complete)
                                {
                                    cellIsComplete = YES;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    UIColor *color = ((SCGGamePlayer *)([players objectAtIndex:currentPlayer])).color;
    [cell setComplete:cellIsComplete withPlayer:currentPlayer andColor:color];

    return  cellIsComplete;
}

- (void) gotoNextPlayer
{
    lastPlayer = currentPlayer;
    currentPlayer++;
    if (currentPlayer == numberOfPlayers)
        currentPlayer = 0;
}

- (void) gotoPreviousPlayer
{
    currentPlayer = lastPlayer;
}

- (BOOL) testBoard
{
    BOOL allDone = YES;
    
    for (SCGGamePlayer *player in players)
        player.score = 0;
    
    for (NSMutableArray *row in cells)
    {
        for (SCGCellView *cell in row)
        {
            if (cell.complete)
            {
                SCGGamePlayer *player = (SCGGamePlayer *)([players objectAtIndex:cell.playerNumber]);
                if (player)
                    player.score++;
            }
            
            if (!cell.complete)
                allDone = NO;
        }
    }

    for (SCGGamePlayer *player in players)
        NSLog(@"Score: %d", player.score);

    for (SCGScoreView *scoreView in scoreViews)
        [scoreView updateScores:currentPlayer];

    return allDone;
}

@end
