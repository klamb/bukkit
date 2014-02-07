//
//  BukkitCell.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/15/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "BukkitCell.h"

@implementation BukkitCell

@synthesize title, imageView, rank, didditButton, commentButton, bukkitButton, item, delegate;

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
        [[PFUser currentUser] incrementKey:@"didditRanking" byAmount:[NSNumber numberWithInt:-1]];
        [item incrementKey:@"ranking" byAmount:[NSNumber numberWithInt:-1]];
        [self removeFromList:@"diddit"];
    }
    else {
        [self.didditButton setSelected:YES];
        [[PFUser currentUser] incrementKey:@"didditRanking"];
        [item incrementKey:@"ranking"];
        [self addToList:@"diddit"];
        if (self.bukkitButton.selected) {
            [bukkitButton setSelected:NO];
            [self removeFromList:@"bukkit"];
        }
    }
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
        [self removeFromList:@"bukkit"];
    }
    else {
        [self.bukkitButton setSelected:YES];
        [self addToList:@"bukkit"];
        if (self.didditButton.selected) {
            [didditButton setSelected:NO];
            [self removeFromList:@"diddit"];
        }
    }
}

-(void) removeFromList:(NSString *)type {
    [[self.item relationforKey:type] removeObject:[PFUser currentUser]];
    [self.item saveInBackground];
    [[[[PFUser currentUser] objectForKey:[NSString stringWithFormat:@"%@List", type]] relationforKey:@"items"] removeObject:self.item];
    [[PFUser currentUser] saveInBackground];
}

-(void) addToList:(NSString *)type {
    [[self.item relationforKey:type] addObject:[PFUser currentUser]];
    [self.item saveInBackground];
    [[[[PFUser currentUser] objectForKey:[NSString stringWithFormat:@"%@List", type]] relationforKey:@"items"] addObject:self.item];
    [[PFUser currentUser] saveInBackground];
}

@end
