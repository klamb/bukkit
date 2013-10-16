//
//  LogInTable.h
//  Bukkit
//
//  Created by Kevin Lamb on 9/22/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LogInTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableView *loginTable;
@property (weak, nonatomic) IBOutlet UITableViewCell *usernameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *passwordCell;

@end
