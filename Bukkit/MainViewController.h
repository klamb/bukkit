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
#import "BukkitViewController.h"
#import "CommentViewController.h"
#import "BukkitCell.h"

@interface MainViewController : PFQueryTableViewController <AddItemDelegate, CommentViewDelegate,BukkitViewDelegate, BukkitDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (nonatomic, strong) PFObject *list;
@property (nonatomic, strong) PFQuery *query;

@property (nonatomic, assign) BOOL userList;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, assign) BOOL pushedView;
@property (nonatomic, weak) NSString *nameOfList;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

-(void)loadBukkitView:(PFObject *)object isAnimated:(BOOL)isAnimated;

@end