//
//  SCGGamePlayer.h
//  StringsAndCoins
//
//  Created by David S Reich on 16/02/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

@class SCGPlayer;
@class SCGBoundaryView;

#import <Foundation/Foundation.h>

@interface SCGGamePlayer : NSObject

@property (strong, nonatomic) SCGPlayer *player;
@property (strong, nonatomic) UIColor *color;
@property (weak, nonatomic) SCGBoundaryView *lastBoundary;
@property (assign, nonatomic) int score;
@property (assign, nonatomic) BOOL isAI;

- (instancetype) initWithPlayer:(SCGPlayer *)p andColor:(UIColor *)c;

@end
