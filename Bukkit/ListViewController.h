//
//  ListViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 12/8/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <Parse/Parse.h>
#import "CreateListViewController.h"

@protocol ListsDelegate;

@interface ListViewController : PFQueryTableViewController <CreateListDelegate>

@property(nonatomic, assign) id <ListsDelegate> delegate;
@end


@protocol ListsDelegate <NSObject>

- (PFUser *)getProfile;

@end