//
//  MainViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 9/30/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController.h"
#import "AddItemViewController.h"
#import "ListViewController.h"
#import "BukkitViewController.h"

@interface MainViewController : UIViewController <AddItemDelegate, BukkitViewDelegate>

@property (nonatomic, weak) PFObject *list;

-(void)loadBukkitView:(PFObject *)object;

@end