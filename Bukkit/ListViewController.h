//
//  ListViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/13/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <Parse/Parse.h>
#import "BukkitCell.h"
#import "MainViewController.h"


@interface ListViewController : PFQueryTableViewController

-(void)updateTable:(NSString *)segmentSelected;
@property (nonatomic, assign) BOOL shouldReloadOnAppear;

@end
