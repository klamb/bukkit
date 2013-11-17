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
#import "CommentViewController.h"

@interface MainViewController : PFQueryTableViewController <AddItemDelegate, CommentViewDelegate,BukkitViewDelegate, BukkitDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (nonatomic, strong) PFObject *list;
@property (nonatomic, strong) PFQuery *query;

@property (nonatomic, assign) BOOL userList;
@property (nonatomic, assign) BOOL pushedView;
@property (nonatomic, weak) NSString *nameOfList;


-(void)loadBukkitView:(PFObject *)object;

@end