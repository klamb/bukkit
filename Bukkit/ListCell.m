//
//  ListCell.m
//  Bukkit
//
//  Created by Kevin Lamb on 1/3/14.
//  Copyright (c) 2014 Kevin Lamb. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

@synthesize listImageView, listTitle, listSubtitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.listImageView.backgroundColor = [UIColor clearColor];
    
    // Add a nice corner radius to the image
    self.listImageView.layer.cornerRadius = self.listImageView.frame.size.width/2.0;
    self.listImageView.layer.masksToBounds = YES;
    
    self.listImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.listImageView.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
