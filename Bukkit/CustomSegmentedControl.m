//
//  CustomSegmentedControl.m
//  Bukkit
//
//  Created by Kevin Lamb on 11/26/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "CustomSegmentedControl.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation CustomSegmentedControl


- (id)initWithItems:(NSArray *)items {
    self = [super initWithItems:items];
    if (self) {
        // Initialization code
        
        self.frame = CGRectMake(-5, 0, 340, 30);
        self.segmentedControlStyle = UISegmentedControlStylePlain;
        self.selectedSegmentIndex = 1;
        self.tag = 11;
        self.tintColor = RGB(34, 158, 245);
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
