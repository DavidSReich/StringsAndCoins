//
//  constants.h
//  StringsAndCoins
//
//  Created by David S Reich on 9/02/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#ifndef StringsAndCoins_constants_h
#define StringsAndCoins_constants_h

//basic values ... used to adjust
//@property (assign, nonatomic) CGFloat statusBarHeight;
//@property (assign, nonatomic) CGFloat topMarginHeight;
//@property (assign, nonatomic) CGFloat bottomMarginHeight;
//@property (assign, nonatomic) CGFloat sideMarginWidth;
// in SCGLevel constructor

#define kStatusBarHeight    20
#define kScoreViewHeight    40
#define kBoardMargin        90

//#define kCellSmallWidth 100
//#define kCellMediumWidth 150
////#define kCellMediumWidth 100
//#define kCellLargeWidth 200

#define kSmallSquareRows   3
#define kMediumSquareRows  4
#define kLargeSquareRows   5

#define kSmallTriangleRows   2
#define kMediumTriangleRows  4
#define kLargeTriangleRows   6

#define kSmallHexagonRows   3
#define kMediumHexagonRows  5
#define kLargeHexagonRows   7

#define kSmallSquareCols   4
#define kMediumSquareCols  5
#define kLargeSquareCols   8

#define kSmallTriangleCols   7
#define kMediumTriangleCols  9
#define kLargeTriangleCols   15

#define kSmallHexagonCols   4
#define kMediumHexagonCols  9
#define kLargeHexagonCols   10

#define kSquareRootOf3	((float)1.732)
#define kPi     M_PI
#define kPiOver2 M_PI_2
#define kPiOver3 (M_PI/(float)3)
#define kPiOver6 (M_PI_2/(float)3)

//UITabBarController button indices ...
#define kSettingsIndex      0
#define kResumeGameIndex    1
#define kNewGameIndex       2
#define kAboutBoxIndex      3

#define kMaxNumberOfPlayers 4

#define kSettingsName   @"Game Options"
#define kGameBoardName  @"Current Game"
#define kAboutName      @"About"
#define kNewGameName    @"New Game"

//#define SHOWROWANDCOL

#endif
