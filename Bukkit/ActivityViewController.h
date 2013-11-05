//
//  ActivityViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/28/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <Parse/Parse.h>

@interface ActivityViewController : PFQueryTableViewController

@property (nonatomic, assign) BOOL showDidditUsers;
@property (nonatomic, assign) PFObject *selectedBukkit;

@end
