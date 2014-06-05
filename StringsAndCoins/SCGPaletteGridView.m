//
//  SCGPaletteGridView.m
//  StringsAndCoins
//
//  Created by David S Reich on 5/06/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import "SCGPaletteGridView.h"

@implementation SCGPaletteGridView

- (void) awakeFromNib {
    [[NSBundle mainBundle] loadNibNamed:@"SCGPaletteGridView" owner:self options:nil];
    [self addSubview: self.paletteGridView];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
