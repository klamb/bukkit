//
//  BukkitCell.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/15/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "BukkitCell.h"

@implementation BukkitCell

@synthesize title, rank, didditButton, commentButton, bukkitButton, bukkit, delegate;

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
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [button setTintColor:[UIColor clearColor]];
     button.adjustsImageWhenHighlighted = NO;
    [button setSelected:NO];
    /*
    if (![button isEqual:self.commentButton]) {
        PFRelation *relation = [self.bukkit relationforKey:button.titleLabel.text.lowercaseString];
        
        [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d scores.", objects.count);
                
                for (PFObject *user in objects) {
                    if (user.objectId == [PFUser currentUser].objectId)
                        [button setSelected:YES];
                }
            } else {
                // Log details of the failure
                NSLog(@"WTF Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
     */
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    [delegate bukkitCell:self didTapBukkit:sender];
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
