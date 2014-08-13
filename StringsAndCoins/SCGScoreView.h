//
//  SCGScoreView.h
//  StringsAndCoins
//
//  Created by David S Reich on 19/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCGLevel;

@interface SCGScoreView : UIView

typedef NS_ENUM(NSInteger, ScoreOrientation)
{
	LeftScore,
	TopScore,
    RightScore,
    BottomScore
};

@property (weak, nonatomic) NSMutableArray *players;
@property (weak, nonatomic) SCGLevel *level;
@property (strong, nonatomic) NSMutableArray *scoreLabels;
@property (assign, nonatomic) CGFloat frameHeight;
@property (assign, nonatomic) CGFloat frameWidth;
@property (assign, nonatomic) ScoreOrientation orientation;


- (instancetype) initWithLevel:(SCGLevel *)l andOrientation:(ScoreOrientation)o andPlayers:(NSMutableArray *)p andWidth:(CGFloat)w;

- (void) updateScores:(int)currentPlayer andDone:(BOOL)done;

@end
