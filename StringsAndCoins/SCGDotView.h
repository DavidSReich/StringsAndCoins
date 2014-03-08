//
//  SCGDotView.h
//  StringsAndCoins
//
//  Created by David S Reich on 16/02/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCGLevel;

@interface SCGDotView : UIImageView

@property (weak, nonatomic) SCGLevel *level;

- (instancetype) initWithLevel:(SCGLevel *)l;

- (instancetype) initWithLevel:(SCGLevel *)l andRow:(int)r andCol:(int)c;

@end
