//
//  SCGGamePlayer.m
//  StringsAndCoins
//
//  Created by David S Reich on 16/02/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGGamePlayer.h"

@implementation SCGGamePlayer

- (instancetype) initWithPlayer:(SCGPlayer *)p andColor:(UIColor *)c
{
    self = [super init];

    if (self)
    {
        self.player = p;
        self.color = c;
        self.score = 0;
        self.isAI = NO;
    }
    
    return self;
}

@end
