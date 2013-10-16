//
//  BukkitCell.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/15/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "BukkitCell.h"

@implementation BukkitCell

@synthesize title;

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

@end
