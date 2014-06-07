//
//  SCGPaletteGridView.h
//  StringsAndCoins
//
//  Created by David S Reich on 6/06/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGSettings.h"

@interface SCGPaletteGridView : UIView

@property (strong, nonatomic) IBOutlet UIView *paletteGridOuterView;
@property (strong, nonatomic) IBOutlet UIView *paletteGridInnerView;
@property (strong, nonatomic) IBOutlet UIButton *palette0Button;

@property (weak, nonatomic) IBOutlet SCGSettings *settings;

- (void) updatePaletteSelection;
- (NSMutableArray *) getPaletteColors:(int)paletteNumber;

@end
