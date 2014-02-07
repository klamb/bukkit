//
//  BukkitListsViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/22/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController.h"
#import "CreateListViewController.h"

@interface BukkitListsViewController : PFQueryTableViewController <CreateListDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addListBarButton;

-(IBAction)addList:(id)sender;

@end
