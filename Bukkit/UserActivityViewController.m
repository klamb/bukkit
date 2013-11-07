//
//  UserActivityViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 11/5/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "UserActivityViewController.h"
#import "BukkitCell.h"

@interface UserActivityViewController ()

@end

@implementation UserActivityViewController

@synthesize displayBukkitList;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
        // The className to query on
        self.parseClassName = @"bukkit";
        
        self.textKey = @"title";
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (PFQuery *)queryForTable {
    
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFRelation *list;
    if(displayBukkitList) {
        list = [[PFUser currentUser] relationforKey:@"bukkit"];
    }
    else {
        list = [[PFUser currentUser] relationforKey:@"diddit"];
    }
    
    PFQuery *queryBukkitList = [list query];
    queryBukkitList.limit = 100;
    
    return queryBukkitList;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    BukkitCell *cell = (BukkitCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BukkitCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:CellIdentifier];
    }
    
    // cell.delegate = self;
    cell.title.text = [object objectForKey:@"title"];
    cell.bukkit = object;
    
    //[self checkForUserActivity:object forButton:cell.didditButton];
    // [self checkForUserActivity:object forButton:cell.bukkitButton];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
