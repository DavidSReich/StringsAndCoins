//
//  SCBoardController.h
//  StringsAndCoins
//
//  Created by David S Reich on 9/02/2014.
//  Copyright (c) 2014 David S Reich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCGLevel;
@class SCGBoundaryView;
@class SCGMainViewController;

@interface SCGBoardController : NSObject

//the board - play game here
@property (weak, nonatomic) UIView *boardView;

//the board's controller
@property (weak, nonatomic) IBOutlet SCGMainViewController *mainViewController;

//contains game settings
@property (strong, nonatomic) SCGLevel *level;

//the last boundary clicked
@property (weak, nonatomic) SCGBoundaryView *lastBoundary;

//start a new game
- (void) setupGameBoard:(SCGLevel *)level;
- (void) clearGameBoard;
- (void) makeDots;
- (void) makeCells;
- (void) makeBoundaries;
- (void) makeBoardFrame;

//user actions
- (void) boundaryClicked:(SCGBoundaryView *)boundary;
- (void) boundaryDoubleClicked;

- (BOOL) testCells;
- (BOOL) testCell:(int)row andCol:(int)col;

- (BOOL) testBoard;

- (void) refreshScores:(BOOL)done;

- (void) gotoNextPlayer;
- (void) gotoPreviousPlayer;

- (NSMutableArray *)getPlayers;

- (void) MenuButtonTapped;

@end
