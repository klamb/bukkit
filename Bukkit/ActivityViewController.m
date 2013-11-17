//
//  ActivityViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/28/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "ActivityViewController.h"
#import "ProfileViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

@synthesize showDidditUsers, selectedBukkit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"bukkit";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"username";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
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
    
    PFRelation *users;
    
    if(showDidditUsers) {
        users = [selectedBukkit relationforKey:@"diddit"];
    } else {
         users = [selectedBukkit relationforKey:@"bukkit"];
    }
    
    PFQuery *query = [users query];
    
    // queryBukkitList.cachePolicy = kPFCachePolicyIgnoreCache;
    query.limit = 100;
    
    
    return query;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProfileViewController *profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    profileViewController.profile = [self.objects objectAtIndex:indexPath.row];
    profileViewController.pushedView = YES;
    [self.navigationController pushViewController:profileViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
