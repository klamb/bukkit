//
//  UserActivityViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 11/5/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <Parse/Parse.h>

@interface UserActivityViewController : PFQueryTableViewController

 @property (nonatomic, strong) PFQuery *query;

@end
