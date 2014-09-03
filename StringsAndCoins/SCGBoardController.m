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
#import "SCGMainViewController.h"
#import "SCGGameOverViewController.h"

@implementation SCGBoardController
{
	//item lists
	NSMutableArray *cells;
	NSMutableArray *horizontalBoundaries;
	NSMutableArray *verticalBoundaries;
	NSMutableArray *dots;
    NSMutableArray *players;
    NSMutableArray *scoreViews;
    NSMutableArray *lastAIBoundaries;
    int currentPlayer;
    int lastPlayer;
    int numberOfPlayers;
    SCGGameOverViewController *gameOverViewController;
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
    [lastAIBoundaries removeAllObjects];
    
    for (UIView *view in self.boardView.subviews)
        [view removeFromSuperview];
}

- (void) setupGameBoard:(SCGLevel *)level
{
    self.mainViewController.settings.gameOver = NO;
    self.mainViewController.settings.gameInProgress = NO;
    [self clearGameBoard];

    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Canvas1a_offwhite_1.png"]];
    backgroundView.frame = CGRectMake(0, 0, self.boardView.frame.size.width, self.boardView.frame.size.height);
    
    [self.boardView addSubview:backgroundView];
    [self.boardView sendSubviewToBack:backgroundView];

    self.lastBoundary = nil;
	self.level = level;

    level.numberOfCells = 0;

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
    NSMutableArray *colors = [self.mainViewController.paletteGridView getPaletteColors:self.level.paletteNumber];
    
    for (int p = 0; p < numberOfPlayers; p++)
    {
        int colorNum = arc4random_uniform(colors.count);
        color = [colors objectAtIndex:colorNum];
        [colors removeObjectAtIndex:colorNum];

        SCGPlayer *player = [SCGPlayer alloc];
//        player.playerName = [NSMutableString stringWithFormat:@"Player %d", p + 1];
        SCGGamePlayer *gamePlayer = [[SCGGamePlayer alloc] initWithPlayer:player andColor:color];
        [players addObject:gamePlayer];

        if (self.mainViewController.settings.isAI)
        {
            if (p == numberOfPlayers - 1)
                gamePlayer.isAI = YES;
        }
//        if (p < numberOfPlayers - 1)
//            player.playerName = [NSString stringWithFormat:@"Player %d ", p + 1];
//        else
//        {
//            gamePlayer.isAI = YES;
//            player.playerName = [NSString stringWithFormat:@"AI "];
//        }
//        NSLog(@"playerName: %@", player.playerName);
    }

    if (self.mainViewController.settings.isAI)
        currentPlayer = arc4random_uniform(numberOfPlayers);
    else
        currentPlayer = 0;
    
    //scores
    CGFloat xWidthCenter = level.leftMarginWidth + (level.boardWidth / 2);
    CGFloat yHeightCenter = level.topMarginHeight + (level.boardHeight / 2) + level.statusBarOffset;
    CGFloat scoreHeight = level.boardHeight;
    CGFloat scoreWidth = level.boardWidth;

    //iPhone will only use top (if landscape) or right (if not landscape) -- never using left or bottom
    BOOL iPhoneTop = NO;
    iPhoneTop = YES;

    scoreViews = [[NSMutableArray alloc] initWithCapacity:4];
    SCGScoreView *scoreView;
    if (!level.isIphone)
    {
        scoreView = [[SCGScoreView alloc] initWithLevel:level andOrientation:LeftScore andPlayers:players andWidth:scoreHeight];
        [scoreViews addObject:scoreView];
        [self.boardView addSubview:scoreView];
        if (level.isIphone)
            scoreView.center = CGPointMake(level.toolbarHeight + level.scoreViewHeight / 2, yHeightCenter);
        else
            scoreView.center = CGPointMake(level.statusBarHeight + 2, yHeightCenter);
    }

    if (!level.isIphone)
    {
        scoreView = [[SCGScoreView alloc] initWithLevel:level andOrientation:RightScore andPlayers:players andWidth:scoreHeight];
        [scoreViews addObject:scoreView];
        [self.boardView addSubview:scoreView];
        if (level.isIphone)
            scoreView.center = CGPointMake(level.leftMarginWidth + level.rightMarginWidth + level.boardWidth - kStatusBarHeight - (level.scoreViewHeight / 2), yHeightCenter);
        else
            scoreView.center = CGPointMake(level.leftMarginWidth + level.rightMarginWidth + level.boardWidth - level.statusBarHeight - 2, yHeightCenter);
    }

    //set Top and Bottom width to same as Left and Right

    scoreView = [[SCGScoreView alloc] initWithLevel:level andOrientation:TopScore andPlayers:players andWidth:scoreWidth];
    [scoreViews addObject:scoreView];
    [self.boardView addSubview:scoreView];
    scoreView.center = CGPointMake(xWidthCenter, kStatusBarHeight + (level.scoreViewHeight / 2));

    if (!level.isIphone)
    {
        scoreView = [[SCGScoreView alloc] initWithLevel:level andOrientation:BottomScore andPlayers:players andWidth:scoreWidth];
        [scoreViews addObject:scoreView];
        [self.boardView addSubview:scoreView];
        if (level.isIphone)
            scoreView.center = CGPointMake(xWidthCenter, self.boardView.frame.size.height - (level.scoreViewHeight / 2));// + level.statusBarOffset?
        else
            scoreView.center = CGPointMake(xWidthCenter, level.topMarginHeight + level.bottomMarginHeight + level.boardHeight - 2);// +level.statusBarOffset?
    }

    [self refreshScores:NO];

    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClicked)];
    self.tapRecognizer.numberOfTapsRequired = 2;
    [self.boardView addGestureRecognizer:self.tapRecognizer];

    if (self.mainViewController.settings.isAI)
    {
        lastAIBoundaries = [[NSMutableArray alloc] init];

        //if currentPlayer is AI it has to go first
        if (((SCGGamePlayer *)([players objectAtIndex:currentPlayer])).isAI)
        {
            self.boardView.userInteractionEnabled = NO;
            SCGBoundaryView *nextBoundary = [self getNextAIMove];
            double delay;
            if (self.mainViewController.settings.aiSpeed == 0)
                delay = 2.0 * NSEC_PER_SEC;
            else
                delay = 1;
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay);
            //careful ... about to recurse (even though asynchronously)
            dispatch_after(time, dispatch_get_main_queue(), ^(void){
                [nextBoundary ActionTapped];
            });
        }
    }
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
        xOffset = self.level.leftMarginWidth;
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
            xOffset = self.level.leftMarginWidth + (self.level.cellWidth / 2) * rowDelta;
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
            
            xOffset = self.level.leftMarginWidth + (self.level.cellWidth / 2) * rowDelta;
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
            
            xOffset = self.level.leftMarginWidth + self.level.cellWidth / 2;
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
            
            xOffset = self.level.leftMarginWidth + (self.level.cellWidth / 2) * rowDelta;
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
            
            xOffset = self.level.leftMarginWidth + (self.level.cellWidth / 2) * rowDelta;
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

	CGFloat xOffset = self.level.leftMarginWidth + self.level.cellWidth / 2;
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
                //is this a bug?  what happens when r == 0????
                numCols = ([self.level numberOfCols:r - 1] + 1) / 2;
                rowDelta = ((self.level.numRows / 2) + 1) - r;
            }
            else
            {
                numCols = ([self.level numberOfCols:r] + 1) / 2;
                rowDelta = r - (self.level.numRows / 2) + 1;
            }
            
            xOffset = self.level.leftMarginWidth + (self.level.cellWidth / 2) * rowDelta;
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
            
            xOffset = self.level.leftMarginWidth + self.level.cellWidth / 4 + (self.level.cellWidth / 2) * rowDelta;
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
	xOffset = self.level.leftMarginWidth;
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
            
            xOffset = self.level.leftMarginWidth + (self.level.cellWidth / 4) + (self.level.cellWidth / 2) * rowDelta;
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
            
            xOffset = self.level.leftMarginWidth + (self.level.cellWidth / 2) * (rowDelta - 1);
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

    CGRect boardFrameRect;
    
    boardFrameRect = CGRectMake(0, 0, self.boardView.frame.size.width, self.boardView.frame.size.height);
    UIImageView *boardFrame = [[UIImageView alloc] initWithFrame:boardFrameRect];

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(boardFrame.frame.size.width, boardFrame.frame.size.height), NO, 0.0);
    
    //use the the image that is going to be drawn on as the receiver
    UIImage *img = boardFrame.image;
    
    [img drawInRect:CGRectMake(0.0, 0.0, boardFrame.frame.size.width, boardFrame.frame.size.height)];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIGraphicsPushContext(ctx);
    
    CGFloat lineWidth = (int)(16 * self.level.scaleGeometry);
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
 
        boundary = [[verticalBoundaries objectAtIndex:0] objectAtIndex:1];
        topLeft = boundary.frame.origin.x;
        boundary = [[verticalBoundaries objectAtIndex:0] objectAtIndex:[self.level numberOfCols:0] - 1];
        topRight = boundary.frame.origin.x + boundary.frame.size.width;
        
        //we want middle row, not top
        boundary = [[verticalBoundaries objectAtIndex:self.level.numRows / 2] objectAtIndex:0];
        left = boundary.frame.origin.x + boundaryWidth / 2;
        farLeft = boundary.frame.origin.x;// + boundaryWidth / 2 - self.level.cellWidth / 4;

        boundary = [[verticalBoundaries objectAtIndex:self.level.numRows / 2] objectAtIndex:[self.level numberOfCols:(self.level.numRows / 2)]];
        farRight = boundary.frame.origin.x + boundary.frame.size.width;

        topRight -= boundaryWidth * .07;
        farRight += boundaryWidth * .07;
        topLeft += boundaryWidth * .07;
        farLeft -= boundaryWidth * .07;
        
        boundary = [[horizontalBoundaries objectAtIndex:self.level.numRows] objectAtIndex:0];
        bottom = boundary.frame.origin.y + boundary.frame.size.height;
        
        //we want middle row, not top
        boundary = [[verticalBoundaries objectAtIndex:self.level.numRows / 2] objectAtIndex:self.level.numCols];
        right = boundary.frame.origin.x + boundary.frame.size.width - boundaryWidth / 2;
        
        CGPoint pts[6];
        CGFloat xOffset = boundaryWidth * .04;
        
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
        top = boundary.frame.origin.y;
        topLeft = boundary.frame.origin.x + boundaryWidth * 0.25;

        boundary = [[horizontalBoundaries objectAtIndex:0] objectAtIndex:([self.level numberOfCols:0] * 2) - 1];
        topRight = boundary.frame.origin.x + boundary.frame.size.width - boundaryWidth * 0.25;

        //we want middle row, not top
        boundary = [[verticalBoundaries objectAtIndex:self.level.numRows / 2] objectAtIndex:0];
        farLeft = boundary.frame.origin.x;
        
        boundary = [[horizontalBoundaries objectAtIndex:self.level.numRows] objectAtIndex:0];
        bottom = boundary.frame.origin.y + boundary.frame.size.height;
        
        //we want middle row, not top
        boundary = [[verticalBoundaries objectAtIndex:self.level.numRows / 2] objectAtIndex:self.level.numCols];
        farRight = boundary.frame.origin.x + boundary.frame.size.width;

        CGPoint pts[6];
        CGFloat topOffset = boundaryWidth * 0.16f;

        pts[0] = CGPointMake(topLeft, top + topOffset);
        pts[1] = CGPointMake(topRight, top + topOffset);
        pts[2] = CGPointMake(farRight, (top + bottom) / 2);
        pts[3] = CGPointMake(topRight, bottom - topOffset);
        pts[4] = CGPointMake(topLeft, bottom - topOffset);
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
    self.mainViewController.settings.gameInProgress = YES;

    if (self.mainViewController.settings.isAI)
    {
        if (((SCGGamePlayer *)([players objectAtIndex:currentPlayer])).isAI)
        {
            [lastAIBoundaries addObject:boundary];
            //don't want player clicking on these
            [boundary LockBoundary];
        }
        else
        {
            //clear lastAIBoundaries, won't be undoing past them
            [lastAIBoundaries removeAllObjects];
            if (self.lastBoundary)
                [self.lastBoundary LockBoundary];
            self.lastBoundary = boundary;
        }
    }
    else
    {
        if (self.lastBoundary)
            [self.lastBoundary LockBoundary];
        self.lastBoundary = boundary;
    }

    boundary.boundaryColor = ((SCGGamePlayer *)([players objectAtIndex:currentPlayer])).color;
    
    BOOL completedACell = NO;
    if (self.mainViewController.settings.isAI && (((SCGGamePlayer *)([players objectAtIndex:currentPlayer])).isAI))
    {
        SCGBoundaryView *tempBoundaryView = self.lastBoundary;
        self.lastBoundary = boundary;
        completedACell = [self testCells];
        self.lastBoundary = tempBoundaryView;
    }
    else
        completedACell = [self testCells];

    if (completedACell)
    {
        if ([self testBoard])
        {
            //all done!
            self.mainViewController.settings.gameInProgress = NO;
            self.mainViewController.settings.gameOver = YES;
            [self refreshScores:YES];
            if (self.lastBoundary)
                [self.lastBoundary LockBoundary];

            [self.tapRecognizer removeTarget:self action:@selector(doubleClicked)];

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
    
    if (self.mainViewController.settings.isAI)
    {
        if (((SCGGamePlayer *)([players objectAtIndex:currentPlayer])).isAI)
        {
            self.boardView.userInteractionEnabled = NO;
            SCGBoundaryView *nextBoundary = [self getNextAIMove];
            double delay;
            if (self.mainViewController.settings.aiSpeed == 0)
                delay = 2.0 * NSEC_PER_SEC;
            else
                delay = 1;
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay);
            //careful ... about to recurse (even though asynchronously)
            dispatch_after(time, dispatch_get_main_queue(), ^(void){
                [nextBoundary ActionTapped];
            });
        }
        else
            self.boardView.userInteractionEnabled = YES;
    }
}

- (void) boundaryDoubleClicked
{
    //unlock any AI
    if (self.mainViewController.settings.isAI)
    {
        SCGBoundaryView *tempBoundaryView = self.lastBoundary;
        for (SCGBoundaryView *boundary in lastAIBoundaries)
        {
            [boundary UnlockBoundary];
            self.lastBoundary = boundary;
            [self testCells];
        }

        self.lastBoundary = tempBoundaryView;
        [lastAIBoundaries removeAllObjects];
    }

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
    if (self.mainViewController.settings.isAI)
    {
        //if is an AI game and not the AI player then don't change.  We never go back to the AI.
        if (!((SCGGamePlayer *)([players objectAtIndex:currentPlayer])).isAI)
            return;
    }
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

- (void) doubleClicked
{
    [self.lastBoundary ActionDoubleTapped];
}

- (SCGBoundaryView *)getNextAIMove
{
    SCGBoundaryView *nextBoundary = nil;

    //count boundaries
    int numberOfBoundaries = 0;
    for (SCGBoundaryView *boundary in self.boardView.subviews)
    {
        if ([boundary isKindOfClass:[SCGBoundaryView class]])
            numberOfBoundaries++;
    }

    do
    {
        //get random boundary
        int boundaryTarget = arc4random_uniform(numberOfBoundaries);

        int boundaryNum = 0;
        //find the boundary
        SCGBoundaryView *boundary;
        for (boundary in self.boardView.subviews)
        {
            if ([boundary isKindOfClass:[SCGBoundaryView class]])
            {
                if (boundaryNum == boundaryTarget)
                    break;
                boundaryNum++;
            }
        }

        //is the boundary available?
        if (!boundary.complete)
            nextBoundary = boundary;

    } while (nextBoundary == nil);

    return nextBoundary;
}
@end
