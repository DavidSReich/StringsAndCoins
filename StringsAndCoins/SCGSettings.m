//
//  SCGSettings.m
//  StringsAndCoins
//
//  Created by David S Reich on 2/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGSettings.h"

#define kKeyLevelType   @"levelType"
#define kKeyLevelShape  @"levelShape"
#define kKeyLevelSize   @"levelSize"
#define kKeyNumPlayers  @"numberOfPlayers"

@implementation SCGSettings

- (instancetype) init
{
    self = [super init];
    if (self != nil)
    {
        [self setDefaultSettings];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self != nil)
    {
        self.levelType = [decoder decodeIntForKey:kKeyLevelType];
        self.levelShape = [decoder decodeIntForKey:kKeyLevelShape];
        self.levelSize = [decoder decodeIntForKey:kKeyLevelSize];
        self.numberOfPlayers = [decoder decodeIntForKey:kKeyNumPlayers];
        self.gameInProgress = NO;
        self.newGame = NO;
    }

    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt:self.levelType forKey:kKeyLevelType];
    [encoder encodeInt:self.levelShape forKey:kKeyLevelShape];
    [encoder encodeInt:self.levelSize forKey:kKeyLevelSize];
    [encoder encodeInt:self.numberOfPlayers forKey:kKeyNumPlayers];
}

- (void) setDefaultSettings
{
    self.levelType = BoxesType;
    self.levelShape = SquareShape;
    self.levelSize = SmallSize;
    self.numberOfPlayers = 2;
    self.gameInProgress = NO;
    self.newGame = NO;
}

@end
