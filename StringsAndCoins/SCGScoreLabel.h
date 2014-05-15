//
//  SCGScoreLabel
//  StringsAndCoins
//
//  Created by David S Reich on 19/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCGGamePlayer;

@interface SCGScoreLabel : UILabel

@property (weak, nonatomic) SCGGamePlayer *player;

- (instancetype) initWithFrame:(CGRect)frame andPlayer:(SCGGamePlayer *)p;

- (void) refreshScore:(BOOL)blank;

@end
