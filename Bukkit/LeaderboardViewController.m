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
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (assign, nonatomic) NSInteger previousNumOfObjects;
@property (assign, nonatomic) BOOL endOfList;

@end

@implementation LeaderboardViewController

@synthesize sidebarButton, activityIndicatorView, endOfList, previousNumOfObjects;

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

-(void)viewWillAppear:(BOOL)animated {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] resetNavigationBar:self.navigationController.navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect footerRect = CGRectMake(0, 0, self.view.frame.size.width, 30);
    UIView *footerView = [[UIView alloc] initWithFrame:footerRect];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.center = CGPointMake(footerView.frame.size.width/2, footerView.frame.size.height/2);
    self.activityIndicatorView.hidesWhenStopped = YES;
    [footerView addSubview:activityIndicatorView];
    
    // self.tableView.tableFooterView = footerView;
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (PFQuery *)queryForTable {
    
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *queryAllUsers = [PFUser query];
    queryAllUsers.limit = 100;
    [queryAllUsers orderByDescending:@"didditRanking"];
    
    return queryAllUsers;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    LeaderboardCell *cell = (LeaderboardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LeaderboardCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:CellIdentifier];
    }
    
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
    
    cell.delegate = self;
    cell.title.text = [object objectForKey:@"name"];
    
    NSString *text = [[object objectForKey:@"didditRanking"] stringValue];
    [cell.didditPoints setTitle:text forState:UIControlStateNormal];
    
    NSString *rankText = [NSString stringWithFormat:@"%d", indexPath.row+1];
    cell.rankingText.text = rankText;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.objects.count) {
        ProfileViewController *profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        profileViewController.profile = [self.objects objectAtIndex:indexPath.row];
        profileViewController.pushedView = YES;
        [self.navigationController pushViewController:profileViewController animated:YES];
    }
}


-(void)bukkitCell:(LeaderboardCell *)leaderboardCell didTapDiddit:(UIButton *)button {
    MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController.userList = YES;
    
    [self.navigationController pushViewController:mainViewController animated:YES];
}

- (void) loadObjects {
    [super loadObjects];
    
    self.endOfList = NO;
    self.previousNumOfObjects = 0;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    if (self.previousNumOfObjects >= self.objects.count) {
        self.endOfList = YES;
        // self.tableView.tableFooterView = [[UIView alloc] init];
    }
    
    self.previousNumOfObjects = self.objects.count;
    
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
    }
}


#pragma UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height - scrollView.contentOffset.y < (self.view.bounds.size.height) && !self.endOfList) {
        if (![self isLoading]) {
            [self.activityIndicatorView startAnimating];
            [self loadNextPage];
        }
    }
}

 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
