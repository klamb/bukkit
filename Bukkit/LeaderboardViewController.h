//
//  LeaderboardViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/22/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController.h"
#import "LeaderboardCell.h"

@interface LeaderboardViewController : PFQueryTableViewController <LeaderboardCellDelegate>

@end
