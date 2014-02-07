//
//  PickerViewCell.m
//  Bukkit
//
//  Created by Kevin Lamb on 12/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "PickerViewCell.h"

@implementation PickerViewCell

@synthesize schoolPickerView, schoolList;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib {
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.schoolPickerView addGestureRecognizer:gestureRecognizer];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        schoolList = [[NSArray alloc] initWithObjects:@"Harvard University", @"Boston College", nil];
        
        UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
        gestureRecognizer.cancelsTouchesInView = NO;
        
        [self.schoolPickerView addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = self.schoolPickerView.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, self.schoolPickerView.bounds.size.height * 0.85 / 2.0);
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) ) {
        NSLog( @"Selected Row: %@", [self.schoolList objectAtIndex:[self.schoolPickerView selectedRowInComponent:0]] );
    }
    
    [self.delegate selectItem];
}

#pragma mark - UIPickerView DataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [schoolList count];
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [schoolList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self.delegate updateChosenSchool:[schoolList objectAtIndex:row]];
}


@end
