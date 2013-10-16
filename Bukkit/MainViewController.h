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

@protocol BukkitListDelegate;

@interface MainViewController : UIViewController <AddItemDelegate>

@property (nonatomic, weak) id<BukkitListDelegate> delegate;
@property (nonatomic, weak) PFObject *list;

@end

@protocol BukkitListDelegate <NSObject>

- (PFObject *)bukkitList;

@end
