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
#import "SCGAppDelegate.h"
#import "SCGMainViewController.h"

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

    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Canvas1a_offwhite_1.png"]];
    backgroundView.frame = CGRectMake(0, 0, self.boardView.frame.size.width, self.boardView.frame.size.height);
    [self.boardView addSubview:backgroundView];
    [self.boardView sendSubviewToBack:backgroundView];

    self.lastBoundary = nil;
	self.level = level;

    level.numberOfCells = 0;

//	self.boardView.layer.borderWidth = 3.f;
//  self.boardView.layer.borderColor = [UIColor redColor].CGColor;
    
	//cells before boundaries if boxes
    if (level.levelType == BoxesType)
        [self makeCells];
    
	//boundaries
    [self makeBoundaries];
    
	//cells after boundaries if coins
    if (level.levelType == CoinsType)
        [self makeCells];
    
    //grid for Boxes
    if (level.levelType == BoxesType)
        [self makeDots];

    if (level.levelType == CoinsType)
        [self makeBoardFrame];
    
    //players will come from outside later
    numberOfPlayers = level.numberOfPlayers;
    players = [[NSMutableArray alloc] initWithCapacity:numberOfPlayers];
    
    UIColor *color;
#if true
    NSMutableArray *colors = [self.mainViewController.paletteGridView getPaletteColors:self.level.paletteNumber];
#endif
    
    for (int p = 0; p < numberOfPlayers; p++)
    {
        SCGPlayer *player = [SCGPlayer alloc];
        player.playerName = [NSMutableString stringWithFormat:@"Player %d", p + 1];
#if true
        int colorNum = arc4random_uniform(colors.count);
        color = [colors objectAtIndex:colorNum];
        [colors removeObjectAtIndex:colorNum];
#elif true
        int paletteNumber = 1;
        
        if (paletteNumber == 0)
        {
            if (p == 0)
                color = [UIColor redColor];
            else if (p == 1)
                color = [UIColor blueColor];
            else if (p == 2)
                color = [UIColor yellowColor];
            else //if (p == 3)
                color = [UIColor cyanColor];
        }
        else if (paletteNumber == 1)
        {
            if (p == 0)
                color = [UIColor colorWithRed:215.0f/255.0f green:25.0f/255.0f blue:28.0f/255.0f alpha:1.0f];
            else if (p == 1)
                color = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:191.0f/255.0f alpha:1.0f];
            else if (p == 2)
                color = [UIColor colorWithRed:171.0f/255.0f green:217.0f/255.0f blue:233.0f/255.0f alpha:1.0f];
            else //if (p == 3)
                color = [UIColor colorWithRed:44.0f/255.0f green:123.0f/255.0f blue:182.0f/255.0f alpha:1.0f];
        }
        else if (paletteNumber == 2)
        {
            if (p == 0)
                color = [UIColor colorWithRed:166.0f/255.0f green:97.0f/255.0f blue:26.0f/255.0f alpha:1.0f];
            else if (p == 1)
                color = [UIColor colorWithRed:223.0f/255.0f green:194.0f/255.0f blue:125.0f/255.0f alpha:1.0f];
            else if (p == 2)
                color = [UIColor colorWithRed:128.0f/255.0f green:205.0f/255.0f blue:193.0f/255.0f alpha:1.0f];
            else //if (p == 3)
                color = [UIColor colorWithRed:1.0f/255.0f green:133.0f/255.0f blue:113.0f/255.0f alpha:1.0f];
        }
        else if (paletteNumber == 3)
        {
            if (p == 0)
                color = [UIColor colorWithRed:216.0f/255.0f green:179.0f/255.0f blue:101.0f/255.0f alpha:1.0f];
            else if (p == 1)
                color = [UIColor colorWithRed:199.0f/255.0f green:234.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
            else if (p == 2)
                color = [UIColor colorWithRed:90.0f/255.0f green:180.0f/255.0f blue:172.0f/255.0f alpha:1.0f];
            else //if (p == 3)
                color = [UIColor colorWithRed:1.0f/255.0f green:102.0f/255.0f blue:94.0f/255.0f alpha:1.0f];
        }
#else
        if (p == 0)
            color = [UIColor redColor];
        else if (p == 1)
            color = [UIColor greenColor];
        else if (p == 2)
            color = [UIColor yellowColor];
        else //if (p == 3)
            color = [UIColor cyanColor];
#endif
        SCGGamePlayer *gamePlayer = [[SCGGamePlayer alloc] initWithPlayer:player andColor:color];
        [players addObject:gamePlayer];
    }

    currentPlayer = 0;

    //scores
    CGFloat xWidthCenter = level.sideMarginWidth + (level.boardWidth / 2);
    CGFloat yHeightCenter = level.topMarginHeight + (level.boardHeight / 2) + level.statusBarOffset;

    scoreViews = [[NSMutableArray alloc] initWithCapacity:4];
    SCGScoreView *scoreView;
    scoreView = [[SCGScoreView alloc] initWithLevel:level andOrientation:LeftScore andPlayers:players andWidth:level.boardHeight];
    [scoreViews addObject:scoreView];
    [self.boardView addSubview:scoreView];
    scoreView.center = CGPointMake(level.statusBarHeight + 2, yHeightCenter);

    scoreView = [[SCGScoreView alloc] initWithLevel:level andOrientation:RightScore andPlayers:players andWidth:level.boardHeight];
    [scoreViews addObject:scoreView];
    [self.boardView addSubview:scoreView];
    scoreView.center = CGPointMake(level.sideMarginWidth * 2 + level.boardWidth - level.statusBarHeight - 2, yHeightCenter);

    //set Top and Bottom width to same as Left and Right

    scoreView = [[SCGScoreView alloc] initWithLevel:level andOrientation:TopScore andPlayers:players andWidth:level.boardHeight];
    [scoreViews addObject:scoreView];
    [self.boardView addSubview:scoreView];
    scoreView.center = CGPointMake(xWidthCenter, scoreView.bounds.size.height / 2 + level.statusBarOffset);

    scoreView = [[SCGScoreView alloc] initWithLevel:level andOrientation:BottomScore andPlayers:players andWidth:level.boardHeight];
    [scoreViews addObject:scoreView];
    [self.boardView addSubview:scoreView];
    scoreView.center = CGPointMake(xWidthCenter, level.topMarginHeight + level.bottomMarginHeight + level.boardHeight - 2);// + level.statusBarOffset?

    [self refreshScores:NO];
}

- (void) makeDots
{
    if (self.level.levelType != BoxesType)
        return;

	CGFloat xOffset = 0;
	CGFloat yOffset = self.level.statusBarOffset;
    
    //grid for Boxes
    dots = [[NSMutableArray alloc] initWithCapacity:self.level.numRows + 1];
    
    if (self.level.levelShape == SquareShape)
    {
        xOffset = self.level.sideMarginWidth;
        yOffset = self.level.topMarginHeight + self.level.statusBarOffset;
        
        xOffset += (self.level.boardWidth - (self.level.cellWidth * self.level.numCols)) / 2;
        yOffset += (self.level.boardHeight - (self.level.cellHeight * self.level.numRows)) / 2;
        
        for (int r = 0; r < self.level.numRows + 1; r++)
        {
            [dots addObject:[NSMutableArray array]];
            
            for (int c = 0; c < self.level.numCols + 1; c++)
            {
                SCGDotView *dot = [[SCGDotView alloc] initWithLevel:self.level];
                [[dots objectAtIndex:r] addObject:dot];
                //set center
                //add to view
                dot.center = CGPointMake(xOffset + c * self.level.cellWidth, yOffset + r * self.level.rowHeight);
                [self.boardView addSubview:dot];
            }
        }
    }
    else if (self.level.levelShape == TriangleShape)
    {
        int numColDots;
        
        yOffset = self.level.topMarginHeight + self.level.statusBarOffset;
        yOffset += (self.level.boardHeight - (self.level.rowHeight * self.level.numRows)) / 2;
        
        for (int r = 0; r < self.level.numRows + 1; r++)
        {
            BOOL topHalf = (r < (self.level.numRows / 2) + 1);
            int rowDelta = r - (self.level.numRows / 2);
            int rowForCols = r - 1;
            
            if (topHalf)
            {
                rowForCols++;
                rowDelta = -rowDelta;
            }
            
            numColDots = ([self.level numberOfCols:rowForCols] + 1) / 2;
            xOffset = self.level.sideMarginWidth + (self.level.cellWidth / 2) * rowDelta;
            xOffset += (self.level.boardWidth - (self.level.cellWidth * (self.level.numCols + 1) / 2)) / 2;
            
            if (r == self.level.numRows / 2)
                numColDots++;
            
            [dots addObject:[NSMutableArray array]];
            
            for (int c = 0; c < numColDots; c++)
            {
                SCGDotView *dot = [[SCGDotView alloc] initWithLevel:self.level];
                [[dots objectAtIndex:r] addObject:dot];
                //set center
                //add to view
                dot.center = CGPointMake(xOffset + c * self.level.cellWidth, yOffset + r * self.level.rowHeight);
                [self.boardView addSubview:dot];
            }
        }
    }
    else    //hexagons
    {
        int numColDots;
        
        yOffset = self.level.topMarginHeight + self.level.statusBarOffset;
        yOffset += (self.level.boardHeight - (self.level.rowHeight * self.level.numRows)) / 2;
        
        for (int r = 0; r < self.level.numRows + 1; r++)
        {
            BOOL topHalf = (r < (self.level.numRows + 1) / 2);
            int rowDelta;
            
            if (topHalf)
            {
                numColDots = [self.level numberOfCols:r] * 2 + 1;
                rowDelta = ((self.level.numRows + 1) / 2) - r - 1;
            }
            else
            {
                numColDots = [self.level numberOfCols:r - 1] * 2 + 1;
                rowDelta = r - ((self.level.numRows + 1) / 2);
            }
            
            xOffset = self.level.sideMarginWidth + (self.level.cellWidth / 2) * rowDelta;
            xOffset += (self.level.boardWidth - (self.level.cellWidth * self.level.numCols)) / 2;
            
            [dots addObject:[NSMutableArray array]];
            
            for (int c = 0; c < numColDots; c++)
            {
#if defined(SHOWROWANDCOL)
                SCGDotView *dot = [[SCGDotView alloc] initWithLevel:self.level andRow:r andCol:c];
#else
                SCGDotView *dot = [[SCGDotView alloc] initWithLevel:self.level];
#endif
                [[dots objectAtIndex:r] addObject:dot];
                
                CGFloat yOffsetOffset;
                if (topHalf == (c % 2 == 0))
                    yOffsetOffset = yOffset + self.level.cellHeight / 8;
                else
                    yOffsetOffset = yOffset - self.level.cellHeight / 8;
                //set center
                //add to view
                dot.center = CGPointMake(xOffset + (c * self.level.cellWidth) / 2, yOffsetOffset + r * self.level.rowHeight);
                [self.boardView addSubview:dot];
            }
        }
    }
}

- (void) makeCells
{
	CGFloat xOffset = 0;
	CGFloat yOffset = self.level.statusBarOffset;
    
	cells = [[NSMutableArray alloc] initWithCapacity:self.level.numRows];
	
	for (int r = 0; r < self.level.numRows; r++)
	{
		[cells addObject:[NSMutableArray array]];
        
        if (self.level.levelShape == SquareShape)
        {
            BOOL topHalf = (r <= self.level.numRows / 2);
            int numCols = [self.level numberOfCols:r];
            
            xOffset = self.level.sideMarginWidth + self.level.cellWidth / 2;
            yOffset = self.level.topMarginHeight + self.level.rowHeight / 2 + self.level.statusBarOffset;
            
            xOffset += (self.level.boardWidth - (self.level.cellWidth * self.level.numCols)) / 2;
            yOffset += (self.level.boardHeight - (self.level.cellHeight * self.level.numRows)) / 2;
            
            for (int c = 0; c < numCols; c++)
            {
                //set center
                CGPoint cellCenter = CGPointMake(xOffset + c * self.level.cellWidth, yOffset + r * self.level.rowHeight);
                SCGCellView *cell = [[SCGCellView alloc] initWithLevel:self.level andRow:r andCol:c andTopHalf:topHalf andCenter:cellCenter];
                [[cells objectAtIndex:r] addObject:cell];
                //add to view
                [self.boardView addSubview:cell];
                
                self.level.numberOfCells++;
            }
        }
        else if (self.level.levelShape == TriangleShape)
        {
            BOOL topHalf = (r < (self.level.numRows / 2));
            int rowDelta;
            
            if (topHalf)
                rowDelta = (self.level.numRows / 2) - r;
            else
                rowDelta = r - (self.level.numRows / 2) + 1;
            
            int numCols = [self.level numberOfCols:r];
            
            xOffset = self.level.sideMarginWidth + (self.level.cellWidth / 2) * rowDelta;
            yOffset = self.level.topMarginHeight + self.level.rowHeight / 2 + self.level.statusBarOffset;
            
            xOffset += (self.level.boardWidth - (self.level.cellWidth * (self.level.numCols + 1) / 2)) / 2;
            yOffset += (self.level.boardHeight - (self.level.rowHeight * self.level.numRows)) / 2;
            
            for (int c = 0; c < numCols; c++)
            {
                //set center
                CGPoint cellCenter = CGPointMake(xOffset + (c * self.level.cellWidth / 2), yOffset + r * self.level.rowHeight);
                SCGCellView *cell = [[SCGCellView alloc] initWithLevel:self.level andRow:r andCol:c andTopHalf:topHalf andCenter:cellCenter];
                [[cells objectAtIndex:r] addObject:cell];
                //add to view
                [self.boardView addSubview:cell];
                
                self.level.numberOfCells++;
            }
        }
        else    //hexagons
        {
            BOOL topHalf = (r < (self.level.numRows + 1) / 2);
            int rowDelta;
            
            if (topHalf)
                rowDelta = ((self.level.numRows + 1) / 2) - r;
            else
                rowDelta = r - ((self.level.numRows + 1) / 2) + 2;
            
            int numCols = [self.level numberOfCols:r];
            
            xOffset = self.level.sideMarginWidth + (self.level.cellWidth / 2) * rowDelta;
            yOffset = self.level.topMarginHeight + self.level.rowHeight / 2 + self.level.statusBarOffset;
            xOffset += (self.level.boardWidth - (self.level.cellWidth * self.level.numCols)) / 2;
            yOffset += (self.level.boardHeight - (self.level.rowHeight * self.level.numRows)) / 2;
            
            for (int c = 0; c < numCols; c++)
            {
                //set center
                CGPoint cellCenter = CGPointMake(xOffset + c * self.level.cellWidth, yOffset + r * self.level.rowHeight);
                SCGCellView *cell = [[SCGCellView alloc] initWithLevel:self.level andRow:r andCol:c andTopHalf:topHalf andCenter:cellCenter];
                [[cells objectAtIndex:r] addObject:cell];
                //add to view
                [self.boardView addSubview:cell];
                
                self.level.numberOfCells++;
            }
        }
    }
}

- (void) makeBoundaries
{
	//horizontal boundaries

	CGFloat xOffset = self.level.sideMarginWidth + self.level.cellWidth / 2;
    CGFloat yOffset = self.level.topMarginHeight + self.level.statusBarOffset;
    yOffset += (self.level.boardHeight - (self.level.rowHeight * self.level.numRows)) / 2;
    
    if (self.level.levelShape == SquareShape)
        xOffset += (self.level.boardWidth - (self.level.cellWidth * self.level.numCols)) / 2;
    
	horizontalBoundaries = [[NSMutableArray alloc] initWithCapacity:self.level.numRows + 1];
	
	for (int r = 0; r < self.level.numRows + 1; r++)
	{
		[horizontalBoundaries addObject:[NSMutableArray array]];
		
        if (self.level.levelShape == SquareShape)
        {
            BOOL topHalf = (r <= self.level.numRows / 2);
            
            int numCols = [self.level numberOfCols:r];
            
            for (int c = 0; c < numCols; c++)
            {
                SCGBoundaryView *boundary = [[SCGBoundaryView alloc] initWithLevel:self.level andRow:r andCol:c andTopHalf:topHalf andOrientation:Horizontal];
                [[horizontalBoundaries objectAtIndex:r] addObject:boundary];
                //set center
                //add to view
                boundary.center = CGPointMake(xOffset + c * self.level.cellWidth, yOffset + r * self.level.rowHeight);
                boundary.board = self;
                [self.boardView addSubview:boundary];
            }
        }
        else if (self.level.levelShape == TriangleShape)
        {
            BOOL topHalf = (r < (self.level.numRows / 2));
            int rowDelta;
            int numCols;
            
            if (topHalf)
            {
                numCols = ([self.level numberOfCols:r - 1] + 1) / 2;
                rowDelta = ((self.level.numRows / 2) + 1) - r;
            }
            else
            {
                numCols = ([self.level numberOfCols:r] + 1) / 2;
                rowDelta = r - (self.level.numRows / 2) + 1;
            }
            
            xOffset = self.level.sideMarginWidth + (self.level.cellWidth / 2) * rowDelta;
            xOffset += (self.level.boardWidth - (self.level.cellWidth * (self.level.numCols + 1) / 2)) / 2;
            
            for (int c = 0; c < numCols; c++)
            {
                SCGBoundaryView *boundary = [[SCGBoundaryView alloc] initWithLevel:self.level andRow:r andCol:c andTopHalf:topHalf andOrientation:Horizontal];
                [[horizontalBoundaries objectAtIndex:r] addObject:boundary];
                //set center
                //add to view
                boundary.center = CGPointMake(xOffset + c * self.level.cellWidth, yOffset + r * self.level.rowHeight);
                boundary.board = self;
                [self.boardView addSubview:boundary];
            }
        }
        else    //hexagons
        {
            BOOL topHalf = (r < (self.level.numRows + 1) / 2);
            int rowDelta;
            int numCols;
            BoundaryOrientation orientation;
            
            if (topHalf)
            {
                numCols = [self.level numberOfCols:r] * 2;
                rowDelta = ((self.level.numRows + 1) / 2) - r - 1;
            }
            else
            {
                numCols = [self.level numberOfCols:r - 1] * 2;
                rowDelta = r - ((self.level.numRows + 1) / 2);
            }
            
            xOffset = self.level.sideMarginWidth + self.level.cellWidth / 4 + (self.level.cellWidth / 2) * rowDelta;
            xOffset += (self.level.boardWidth - (self.level.cellWidth * self.level.numCols)) / 2;
            
            for (int c = 0; c < numCols; c++)
            {
                if (topHalf == (c % 2 == 0))
                    orientation = HorizontalRight;
                else
                    orientation = HorizontalLeft;
                
                SCGBoundaryView *boundary = [[SCGBoundaryView alloc] initWithLevel:self.level andRow:r andCol:c andTopHalf:topHalf andOrientation:orientation];
                [[horizontalBoundaries objectAtIndex:r] addObject:boundary];
                //set center
                //add to view
                boundary.center = CGPointMake(xOffset + (c * self.level.cellWidth) / 2, yOffset + r * self.level.rowHeight);
                boundary.board = self;
                [self.boardView addSubview:boundary];
            }
        }
	}
    
	//vertical boundaries
    //triangles need different xOffsets, odd and even -- and angles too
	xOffset = self.level.sideMarginWidth;
	yOffset = self.level.topMarginHeight + self.level.rowHeight / 2 + self.level.statusBarOffset;
    yOffset += (self.level.boardHeight - (self.level.rowHeight * self.level.numRows)) / 2;
    
	verticalBoundaries = [[NSMutableArray alloc] initWithCapacity:self.level.numRows + 1];
	
    if (self.level.levelShape == SquareShape)
        xOffset += (self.level.boardWidth - (self.level.cellWidth * self.level.numCols)) / 2;
    
	for (int r = 0; r < self.level.numRows; r++)
	{
		[verticalBoundaries addObject:[NSMutableArray array]];
		
		BOOL topHalf = (r <= self.level.numRows / 2);
        BoundaryOrientation orientation;
		
		int numCols = [self.level numberOfCols:r] + 1;
        
        if (self.level.levelShape == SquareShape)
        {
            for (int c = 0; c < numCols; c++)
            {
                orientation = Vertical;
                
                SCGBoundaryView *boundary = [[SCGBoundaryView alloc] initWithLevel:self.level andRow:r andCol:c andTopHalf:topHalf andOrientation:orientation];
                [[verticalBoundaries objectAtIndex:r] addObject:boundary];
                //set center
                //add to view
                boundary.center = CGPointMake(xOffset + c * self.level.cellWidth, yOffset + r * self.level.rowHeight);
                boundary.board = self;
                [self.boardView addSubview:boundary];
            }
        }
        else if (self.level.levelShape == TriangleShape)
        {
            BOOL topHalf = (r < (self.level.numRows / 2));
            int rowDelta;
            
            if (topHalf)
                rowDelta = (self.level.numRows / 2) - r - 1;
            else
                rowDelta = r - (self.level.numRows / 2);
            
            xOffset = self.level.sideMarginWidth + (self.level.cellWidth / 4) + (self.level.cellWidth / 2) * rowDelta;
            xOffset += (self.level.boardWidth - (self.level.cellWidth * ((self.level.numCols + 1) / 2))) / 2;
            
            for (int c = 0; c < numCols; c++)
            {
                if (topHalf == (c % 2 == 0))
                    orientation = VerticalRight;
                else
                    orientation = VerticalLeft;
                
                SCGBoundaryView *boundary = [[SCGBoundaryView alloc] initWithLevel:self.level andRow:r andCol:c andTopHalf:topHalf andOrientation:orientation];
                [[verticalBoundaries objectAtIndex:r] addObject:boundary];
                //set center
                //add to view
                boundary.center = CGPointMake(xOffset + (c * self.level.cellWidth) / 2, yOffset + r * self.level.rowHeight);
                boundary.board = self;
                [self.boardView addSubview:boundary];
            }
        }
        else    //hexagons
        {
            BOOL topHalf = (r < (self.level.numRows + 1) / 2);
            int rowDelta;
            
            if (topHalf)
                rowDelta = ((self.level.numRows + 1) / 2) - r;
            else
                rowDelta = r - ((self.level.numRows + 1) / 2) + 2;
            
            int numCols = [self.level numberOfCols:r] + 1;
            
            xOffset = self.level.sideMarginWidth + (self.level.cellWidth / 2) * (rowDelta - 1);
            xOffset += (self.level.boardWidth - (self.level.cellWidth * self.level.numCols)) / 2;
            
            for (int c = 0; c < numCols; c++)
            {
                orientation = Vertical;
                
                SCGBoundaryView *boundary = [[SCGBoundaryView alloc] initWithLevel:self.level andRow:r andCol:c andTopHalf:topHalf andOrientation:orientation];
                [[verticalBoundaries objectAtIndex:r] addObject:boundary];
                //set center
                //add to view
                if (self.level.levelType == BoxesType)
                    boundary.center = CGPointMake(xOffset + c * self.level.cellWidth, yOffset + r * self.level.rowHeight);
                //                boundary.center = CGPointMake(xOffset + c * level.cellWidth, (yOffset * 1.01) + r * level.rowHeight);
                else
                    boundary.center = CGPointMake(xOffset + c * self.level.cellWidth, yOffset + r * self.level.rowHeight);
                boundary.board = self;
                [self.boardView addSubview:boundary];
            }
        }
	}
}

- (void) makeBoardFrame
{
    if (self.level.levelType != CoinsType)
        return;

    UIImageView *boardFrame = [[UIImageView alloc] initWithFrame:self.boardView.frame];

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(boardFrame.frame.size.width, boardFrame.frame.size.height), NO, 0.0);
    
    //use the the image that is going to be drawn on as the receiver
    UIImage *img = boardFrame.image;
    
    [img drawInRect:CGRectMake(0.0, 0.0, boardFrame.frame.size.width, boardFrame.frame.size.height)];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(ctx);
    
    CGFloat lineWidth = 16;
    
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);

    CGFloat top, topLeft, topRight, farLeft, farRight, left, bottom, right;
    CGFloat boundaryWidth;
    SCGBoundaryView *boundary;

    if (self.level.levelShape == SquareShape)
    {
        boundary = [[horizontalBoundaries objectAtIndex:0] objectAtIndex:0];
        top = boundary.frame.origin.y;

        boundary = [[verticalBoundaries objectAtIndex:0] objectAtIndex:0];
        left = boundary.frame.origin.x;

        boundary = [[horizontalBoundaries objectAtIndex:self.level.numRows] objectAtIndex:0];
        bottom = boundary.frame.origin.y + boundary.frame.size.height;

        boundary = [[verticalBoundaries objectAtIndex:0] objectAtIndex:self.level.numCols];
        right = boundary.frame.origin.x + boundary.frame.size.width;

        CGFloat lineOffset = (lineWidth - 4) / 2;
        
        CGRect drawRect = CGRectMake(left - lineOffset, top - lineOffset, right - left + lineWidth - 4, bottom - top + lineWidth - 4);
        CGContextStrokeRect(ctx, drawRect);
    }
    else if (self.level.levelShape == TriangleShape)
    {
        boundary = [[horizontalBoundaries objectAtIndex:0] objectAtIndex:0];
        top = boundary.frame.origin.y;
        boundaryWidth = boundary.frame.size.width;
        topLeft = boundary.frame.origin.x + boundary.frame.size.width / 2 - self.level.cellWidth / 2;
        topRight = topLeft + (self.level.cellWidth * ([self.level numberOfCols:0] / 2));
        
        //we want middle row, not top
        boundary = [[verticalBoundaries objectAtIndex:self.level.numRows / 2] objectAtIndex:0];
        left = boundary.frame.origin.x + boundaryWidth / 2;
        farLeft = boundary.frame.origin.x + boundaryWidth / 2 - self.level.cellWidth / 4;
        farRight = farLeft + (self.level.cellWidth * ([self.level numberOfCols:self.level.numRows / 2] / 2 + 1));
        farRight += -boundary.frame.size.width / 2 + self.level.cellWidth / 2;
        
        boundary = [[horizontalBoundaries objectAtIndex:self.level.numRows] objectAtIndex:0];
        bottom = boundary.frame.origin.y + boundary.frame.size.height;
        
        //we want middle row, not top
        boundary = [[verticalBoundaries objectAtIndex:self.level.numRows / 2] objectAtIndex:self.level.numCols];
        right = boundary.frame.origin.x + boundary.frame.size.width - boundaryWidth / 2;
        
        CGPoint pts[6];
        CGFloat xOffset = boundaryWidth + 2;

        pts[0] = CGPointMake(topLeft - xOffset, top);
        pts[1] = CGPointMake(topRight + xOffset, top);
        pts[2] = CGPointMake(farRight + xOffset, (top + bottom) / 2);
        pts[3] = CGPointMake(topRight + xOffset, bottom);
        pts[4] = CGPointMake(topLeft - xOffset, bottom);
        pts[5] = CGPointMake(farLeft - xOffset, (top + bottom) / 2);

        CGContextBeginPath(ctx);
        //draw the hexagon
        CGContextMoveToPoint(ctx, pts[0].x, pts[0].y);
        for (int i = 1; i < 6; i++)
            CGContextAddLineToPoint(ctx, pts[i].x, pts[i].y);
        //close the path
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
    }
    else    //hexagons
    {
        boundary = [[horizontalBoundaries objectAtIndex:0] objectAtIndex:0];
        boundaryWidth = boundary.frame.size.width;
        top = boundary.frame.origin.y + boundaryWidth * 0.07;
        topLeft = boundary.frame.origin.x + boundaryWidth * 0.08;
        topRight = boundary.frame.origin.x + (self.level.cellWidth * [self.level numberOfCols:0]);

        //we want middle row, not top
        boundary = [[verticalBoundaries objectAtIndex:self.level.numRows / 2] objectAtIndex:0];
        farLeft = boundary.frame.origin.x;
        
        boundary = [[horizontalBoundaries objectAtIndex:self.level.numRows] objectAtIndex:0];
        bottom = boundary.frame.origin.y + boundary.frame.size.height - boundaryWidth * 0.07;
        
        //we want middle row, not top
        boundary = [[verticalBoundaries objectAtIndex:self.level.numRows / 2] objectAtIndex:self.level.numCols];
        farRight = boundary.frame.origin.x + boundary.frame.size.width;

        CGPoint pts[6];
        pts[0] = CGPointMake(topLeft, top);
        pts[1] = CGPointMake(topRight, top);
        pts[2] = CGPointMake(farRight, (top + bottom) / 2);
        pts[3] = CGPointMake(topRight, bottom);
        pts[4] = CGPointMake(topLeft, bottom);
        pts[5] = CGPointMake(farLeft, (top + bottom) / 2);
        
        CGContextBeginPath(ctx);
        //draw the hexagon
        CGContextMoveToPoint(ctx, pts[0].x, pts[0].y);
        for (int i = 1; i < 6; i++)
            CGContextAddLineToPoint(ctx, pts[i].x, pts[i].y);
        //close the path
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
    }
    
    UIGraphicsPopContext();
    
    //get the new image
    UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
    boardFrame.image = img2;
    
    UIGraphicsEndImageContext();

    [self.boardView addSubview:boardFrame];
}

- (void) boundaryClicked:(SCGBoundaryView *)boundary
{
    SCGAppDelegate *appDelegate = (SCGAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.settings.gameInProgress = YES;

    if (self.lastBoundary)
        [self.lastBoundary LockBoundary];
    self.lastBoundary = boundary;
    boundary.boundaryColor = ((SCGGamePlayer *)([players objectAtIndex:currentPlayer])).color;
    
    BOOL completedACell = [self testCells];
    if (completedACell)
    {
        if ([self testBoard])
        {
            //all done!
            self.mainViewController.settings.gameInProgress = false;
            [self refreshScores:YES];
            if (self.lastBoundary)
                [self.lastBoundary LockBoundary];
            
            [self.mainViewController performSegueWithIdentifier:@"GameOver" sender:self];
            return;
        }
    }
    else
        [self testBoard];   //want to count and update scores

    if (!completedACell)
        [self gotoNextPlayer];
    else
        lastPlayer = currentPlayer;

    [self refreshScores:NO];
}

- (void) boundaryDoubleClicked
{
    //uncheck cells
    [self testCells];
    [self testBoard];
    [self gotoPreviousPlayer];
    self.lastBoundary = nil;
    
    [self refreshScores:NO];
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

    return allDone;
}

- (void) refreshScores:(BOOL)done
{
    for (SCGScoreView *scoreView in scoreViews)
        [scoreView updateScores:currentPlayer andDone:done];
    
}

- (NSMutableArray *)getPlayers
{
    return players;
}

@end
