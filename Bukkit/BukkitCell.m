//
//  BukkitCell.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/15/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "BukkitCell.h"

@implementation BukkitCell

@synthesize title, imageView, rank, didditButton, commentButton, bukkitButton, bukkit, delegate;

/*
- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        NSLog(@"Booshit");
    }
    return self;
}
*/ 

-(void)awakeFromNib {
    [self setButton:self.commentButton];
    [self setButton:self.didditButton];
    [self setButton:self.bukkitButton];
}


-(void)setButton:(UIButton *)button {
     button.adjustsImageWhenHighlighted = NO;
    [button setSelected:NO];
}

- (IBAction)didTapDidditButtonAction:(UIButton *)sender {
    if(self.didditButton.selected) {
        [self.didditButton setSelected:NO];
    }
    else {
        [self.didditButton setSelected:YES];
    }
    
    [self.delegate bukkitCell:self didTapDiddit:sender];
}

- (IBAction)didTapCommentButtonAction:(UIButton *)sender {
    if(self.commentButton.selected) {
        [self.commentButton setSelected:NO];
    }
    else {
        [self.commentButton setSelected:YES];
    }
    [delegate bukkitCell:self didTapComment:sender];
}

- (IBAction)didTapBukkitButtonAction:(UIButton *)sender {
    if(self.bukkitButton.selected) {
        [self.bukkitButton setSelected:NO];
    }
    else {
        [self.bukkitButton setSelected:YES];
    }
    [delegate bukkitCell:self didTapBukkit:sender];
}

@end
