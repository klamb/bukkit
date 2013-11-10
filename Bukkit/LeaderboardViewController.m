//
//  LeaderboardViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/22/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "ProfileViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface LeaderboardViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation LeaderboardViewController

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
        self.parseClassName = @"User";
        
        // The key of the PFObject to display in the label of the default cell style
        // self.textKey = @"username";
        
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
    
    PFQuery *queryAllUsers = [PFUser query];
    
    queryAllUsers.limit = 100;
    
    return queryAllUsers;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Change button color
    sidebarButton.tintColor = [UIColor colorWithWhite:0.16f alpha:0.8f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    LeaderboardCell *cell = (LeaderboardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LeaderboardCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:CellIdentifier];
    }
    
    cell.delegate = self;
    cell.title.text = [object objectForKey:@"username"];
    
    PFFile *profPicFile = [object objectForKey:@"profilepic"];
    [profPicFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.profilePic.image = [UIImage imageWithData:imageData];
            cell.profilePic.backgroundColor = [UIColor clearColor];
            
            // Add a nice corner radius to the image
            cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2;
            cell.profilePic.layer.masksToBounds = YES;
            
            cell.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.profilePic.layer.borderWidth = 1.5;
        }
    }];
    
    PFRelation *relationOfDiddit = [object relationforKey:@"diddit"];
    [[relationOfDiddit query] countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if(!error) {
            if (number > 0) {
                 NSString *text = [NSString stringWithFormat:@"%i", number];
                [cell.didditPoints setTitle:text forState:UIControlStateNormal];
            }
            
        } else {
            
        }
    }];
    
    
    NSString *rankText = [NSString stringWithFormat:@"%d", indexPath.row+1];
    cell.rankingText.text = rankText;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProfileViewController *profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    profileViewController.profile = [self.objects objectAtIndex:indexPath.row];
    profileViewController.pushedView = YES;
    [self.navigationController pushViewController:profileViewController animated:YES];
    
    
}

-(void)bukkitCell:(LeaderboardCell *)leaderboardCell didTapDiddit:(UIButton *)button {
    MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController.userList = YES;
    
    [self.navigationController pushViewController:mainViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
