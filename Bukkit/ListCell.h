//
//  ListCell.h
//  Bukkit
//
//  Created by Kevin Lamb on 1/3/14.
//  Copyright (c) 2014 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *listImageView;
@property (weak, nonatomic) IBOutlet UILabel *listTitle;
@property (weak, nonatomic) IBOutlet UILabel *listSubtitle;

@end
