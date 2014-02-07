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
#import "ListCell.h"
#import "AppDelegate.h"

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
        // self.textKey = @"name";
        
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
    
    PFQuery *queryBukkitList = [[[PFUser currentUser] relationforKey:@"lists"] query];

    queryBukkitList.limit = 100;

    return queryBukkitList;
}

-(void)viewWillAppear:(BOOL)animated {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] resetNavigationBar:self.navigationController.navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"Cell";
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    cell.listTitle.text = [object objectForKey:@"name"];
    // cell.listSubtitle.text = @"The Official Bukkit List";
    
    PFFile *listImageFile = [object objectForKey:@"Image"];
    [listImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.listImageView.image = [UIImage imageWithData:imageData];
        }
    }];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController.list = [self.objects objectAtIndex:indexPath.row];
    mainViewController.pushedView = YES;
    [self.navigationController pushViewController:mainViewController animated:YES];
}

-(IBAction)addList:(id)sender {
    CreateListViewController *createListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateListViewController"];
    createListViewController.delegate = self;
    UINavigationController *createListNavController = [[UINavigationController alloc] initWithRootViewController:createListViewController];
    
    [self presentViewController:createListNavController animated:YES completion:nil];
}

#pragma mark - CreateListDelegate Methods

- (void)cancel:(CreateListViewController *)createListViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createNewList:(id)sender {
    [self loadObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
