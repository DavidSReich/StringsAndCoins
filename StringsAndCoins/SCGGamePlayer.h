//
//  SCGGamePlayer.h
//  StringsAndCoins
//
//  Created by David S Reich on 16/02/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

@class SCGPlayer;

#import <Foundation/Foundation.h>

@interface SCGGamePlayer : NSObject

@property (strong, nonatomic) SCGPlayer *player;
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) int score;

- (instancetype) initWithPlayer:(SCGPlayer *)p andColor:(UIColor *)c;

@end
