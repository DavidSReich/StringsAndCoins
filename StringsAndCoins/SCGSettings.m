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
#define kKeyPaletteNumber   @"paletteNumber"

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
        [self setDefaultSettings];
        self.levelType = [decoder decodeIntForKey:kKeyLevelType];
        self.levelShape = [decoder decodeIntForKey:kKeyLevelShape];
        self.levelSize = [decoder decodeIntForKey:kKeyLevelSize];
        self.numberOfPlayers = [decoder decodeIntForKey:kKeyNumPlayers];
        self.paletteNumber = [decoder decodeIntForKey:kKeyPaletteNumber];
    }

    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt:self.levelType forKey:kKeyLevelType];
    [encoder encodeInt:self.levelShape forKey:kKeyLevelShape];
    [encoder encodeInt:self.levelSize forKey:kKeyLevelSize];
    [encoder encodeInt:self.numberOfPlayers forKey:kKeyNumPlayers];
    [encoder encodeInt:self.paletteNumber forKey:kKeyPaletteNumber];
}

- (void) setDefaultSettings
{
    self.levelType = BoxesType;
    self.levelShape = SquareShape;
    self.levelSize = SmallSize;
    self.numberOfPlayers = 2;
    self.paletteNumber = 1;
    self.gameInProgress = NO;
    self.gameOver = NO;
    self.newGame = NO;

    self.isIphone = ([UIDevice currentDevice].userInterfaceIdiom != UIUserInterfaceIdiomPad);
    if (self.isIphone)
        self.isIphone4 = [[UIScreen mainScreen] bounds].size.height < 500;
    else
        self.isIphone4 = false;

#if defined(ADJUSTNUMBERROWSCOLS)
    self.numCols = 4;
    self.numRows = 2;
#endif
}

@end
