//
//  BukkitListsViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/22/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "BukkitListsViewController.h"
#import "UserActivityViewController.h"
#import "MainViewController.h"

@interface BukkitListsViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation BukkitListsViewController

@synthesize sidebarButton;

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
        self.parseClassName = @"bukkitlist";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
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


- (PFQuery *)queryForTable {
    
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFRelation *lists = [[PFUser currentUser] relationforKey:@"lists"];
    
    PFQuery *queryBukkitList = [lists query];

    queryBukkitList.limit = 100;

    return queryBukkitList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Change button color
    // sidebarButton.tintColor = [UIColor colorWithWhite:0.16f alpha:0.8f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PFObject *obj = [self.objects objectAtIndex:indexPath.row];
    
    PFQuery *queryBukkitList = [PFQuery queryWithClassName:@"bukkit"];
    [queryBukkitList whereKey:@"list" equalTo:obj];
    
     MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController.nameOfList = [obj objectForKey:@"name"];
    mainViewController.pushedView = YES;
    mainViewController.query = queryBukkitList;
    [self.navigationController pushViewController:mainViewController animated:YES];
    
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UserActivityViewController *activityViewController = [storyboard instantiateViewControllerWithIdentifier:@"UserActivityViewController"];
    activityViewController.query = queryBukkitList;
    [self.navigationController pushViewController:activityViewController animated:YES];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
