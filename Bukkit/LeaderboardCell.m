//
//  LeaderboardCell.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/30/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "LeaderboardCell.h"

@implementation LeaderboardCell

@synthesize rankingText, profilePic, title, didditPoints, delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)didTapDidditButton:(UIButton *)sender {
    [self.delegate bukkitCell:self didTapDiddit:sender];
}

@end
