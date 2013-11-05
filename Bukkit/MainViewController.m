//
//  MainViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 9/30/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "MainViewController.h"

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addItemButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (nonatomic, assign) BOOL topRated;
@property (nonatomic, assign) BOOL shouldReloadOnAppear;

-(IBAction)presentAddItemView:(id)sender;

@end

@implementation MainViewController

@synthesize sidebarButton, addItemButton, navItem, list, topRated, shouldReloadOnAppear;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        return;
    }
    
    // Change button color
    sidebarButton.tintColor = [UIColor colorWithWhite:0.16f alpha:0.8f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // navItem.title = [list objectForKey:@"name"];
    
    /*
    PFRelation *lists = [user relationforKey:@"lists"];
    
    PFQuery *query = [lists query];
    [query whereKey:@"name" equalTo:[user objectForKey:@"school"]];
    
    PFQuery *queryBukkitList = [PFQuery queryWithClassName:@"bukkitList"];
    [queryBukkitList whereKey:@"list" matchesQuery:query];
    
    [[lists query] getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            // There was an error
        } else {
            list = object;
            navItem.title = [object objectForKey:@"name"];
        }
    }];
    */
}

-(void) getListCallback:(PFObject *)object error:(NSError *)error {
    if (!error) {
        // The get request succeeded. Log the score
        navItem.title = [object objectForKey:@"name"];
        list = object;
        
    } else {
        // Log details of our failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

-(void) pickOne:(id)sender{
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSString *order = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    [self updateTable:order];
}

-(IBAction)presentAddItemView: (id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:nil];
    
    AddItemViewController *addItemController =
    [storyboard instantiateViewControllerWithIdentifier:@"AddItemViewController"];
    addItemController.delegate = self;
    addItemController.bukkitList = list;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addItemController];
    
     [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)cancelAddingItem:(AddItemViewController *) addItemController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addItem:(id)sender {
    self.shouldReloadOnAppear = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadBukkitView:(PFObject *)object {
    
    BukkitViewController *bukkitViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"BukkitViewController"];
    bukkitViewController.delegate = self;
    bukkitViewController.bukkit = object;
    
    [self.navigationController pushViewController:bukkitViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"bukkit";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"title";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        self.topRated = NO;
        
        self.shouldReloadOnAppear = NO;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = self.objects.count;
    if (self.paginationEnabled && sections != 0)
        sections = sections + 2;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0f;
    }
    return 8.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section > self.objects.count || section == 0) {
        return 0.0f;
    }
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > self.objects.count) {
        return 50.0f;   // Load More Section
    } else if (indexPath.section == 0) {
        return 30.0f;   // Segmented Control Section
    } else {
        return 175.0f;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }
}


- (PFQuery *)queryForTable {
    
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *queryBukkitList;
    
        PFRelation *lists = [user relationforKey:@"lists"];
        
        PFQuery *query = [lists query];
        [query whereKey:@"name" equalTo:[user objectForKey:@"school"]];
        
        
        queryBukkitList = [PFQuery queryWithClassName:self.parseClassName];
        [queryBukkitList whereKey:@"list" matchesQuery:query];
    
    
    if(topRated) {
        [queryBukkitList orderByDescending:@"ranking"];
    }
    else {
        [queryBukkitList orderByDescending:@"createdAt"];
    }

    
    // queryBukkitList.cachePolicy = kPFCachePolicyIgnoreCache;
    queryBukkitList.limit = 100;
    
    // A pull-to-refresh should always trigger a network request.
    // [queryBukkitList setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    //if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
    // [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    //}
    
    /*
     This query will result in an error if the schema hasn't been set beforehand. While Parse usually handles this automatically, this is not the case for a compound query such as this one. The error thrown is:
     
     Error: bad special key: __type
     
     To set up your schema, you may post a photo with a caption. This will automatically set up the Photo and Activity classes needed by this query.
     
     You may also use the Data Browser at Parse.com to set up your classes in the following manner.
     
     Create a User class: "User" (if it does not exist)
     
     Create a Custom class: "Activity"
     - Add a column of type pointer to "User", named "fromUser"
     - Add a column of type pointer to "User", named "toUser"
     - Add a string column "type"
     
     Create a Custom class: "Photo"
     - Add a column of type pointer to "User", named "user"
     
     You'll notice that these correspond to each of the fields used by the preceding query.
     */
    
    return queryBukkitList;
}


- (NSIndexPath *)indexPathForObject:(PFObject *)targetObject {
    for (int i = 0; i < self.objects.count; i++) {
        PFObject *object = [self.objects objectAtIndex:i];
        if ([[object objectId] isEqualToString:[targetObject objectId]]) {
            return [NSIndexPath indexPathForRow:0 inSection:i+1];
        }
    }
    
    return nil;
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    // overridden, since we want to implement sections
    if (indexPath.section > 0 && indexPath.section <= self.objects.count) {
        return [self.objects objectAtIndex:indexPath.section-1];
    }
    
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    if(indexPath.section == 0) {
        UITableViewCell *cell = [self tableView:tableView cellForSegmentedControl:indexPath];
        return cell;
    }
    
    if (indexPath.section > self.objects.count) {
        // this behavior is normally handled by PFQueryTableViewController, but we are using sections for each object and we must handle this ourselves
        UITableViewCell *cell = [self tableView:tableView cellForNextPageAtIndexPath:indexPath];
        return cell;
    }
    
    BukkitCell *cell = (BukkitCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BukkitCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:CellIdentifier];
    }
    
    cell.delegate = self;
    cell.title.text = [object objectForKey:@"title"];
    cell.bukkit = object;
    
    [self checkForUserActivity:object forButton:cell.didditButton];
    [self checkForUserActivity:object forButton:cell.bukkitButton];
    
    if (topRated) {
        NSString *rankText = [NSString stringWithFormat:@"%d", indexPath.section];
        cell.rank.text = rankText;
    } else {
        NSString *time = [self getTimeElapsed:object.createdAt];
        cell.rank.text = time;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        
    }
    
    cell.textLabel.text = @"Load More";
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds] ;
    cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
    
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForSegmentedControl:(NSIndexPath *)indexPath {
    static NSString *SegementedControlCell = @"SegmentedControlCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SegementedControlCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SegementedControlCell];
        
    }
    
    if (![cell.contentView viewWithTag:11]) {
        NSArray *itemArray = [NSArray arrayWithObjects: @"Most Recent", @"Top Rated", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        segmentedControl.frame = CGRectMake(0, 0, 320, 29);
        segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tag = 11;
        segmentedControl.tintColor = RGB(34, 158, 245);
        [segmentedControl addTarget:self
                             action:@selector(pickOne:)
                   forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:segmentedControl];
    }
    
    return cell;
}


-(void)checkForUserActivity:(PFObject *)object forButton:(UIButton *)button {
    PFRelation *relation = [object relationforKey:button.titleLabel.text.lowercaseString];
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            for (PFObject *user in objects) {
                if ([user.objectId isEqual:[PFUser currentUser].objectId]) {
                    [button setSelected:YES];
                }
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}


-(void)updateTable:(NSString *)segmentSelected {
    
    if([segmentSelected isEqualToString:@"Top Rated"]) {
        self.topRated = YES;
    } else {
        self.topRated = NO;
    }
    
    [self loadObjects];
}

-(NSString *)getTimeElapsed:(NSDate *)timeStamp {
    NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:timeStamp];
    double secondsInAnHour = 3600;
    double secondsInAMinute = 60;
    double secondsInADay = 86400;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    
    if (hoursBetweenDates <= 0) {
        NSInteger minutesBetweenDates = distanceBetweenDates / secondsInAMinute;
        return [NSString stringWithFormat:@"%d m", minutesBetweenDates];
    } else if(hoursBetweenDates >= 24) {
        NSInteger daysBetweenDates = distanceBetweenDates/secondsInADay;
        return [NSString stringWithFormat:@"%d d", daysBetweenDates];
    } else {
        return [NSString stringWithFormat:@"%d h", hoursBetweenDates];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0) {
        
    }
    else if (indexPath.section > self.objects.count && self.paginationEnabled) {
        // Load More Cell
        [self loadNextPage];
    } else {
        [self loadBukkitView:self.objects[indexPath.section-1]];
    }
}

-(void)bukkitCell:(BukkitCell *)bukkitCell didTapDiddit:(UIButton *)button {
    
    PFObject *bukkit = bukkitCell.bukkit;
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [bukkit relationforKey:@"diddit"];
    [[relation query] getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            [relation addObject:user];
            [bukkit incrementKey:@"ranking"];
            [bukkit saveInBackground];
            
            PFRelation *relationForUser = [user relationforKey:@"diddit"];
            [relationForUser addObject:bukkit];
            [user saveInBackground];
        } else {
            [relation removeObject:user];
            [bukkit incrementKey:@"ranking" byAmount:[NSNumber numberWithInt:-1]];
            [bukkit saveInBackground];
            
            PFRelation *relationForUser = [user relationforKey:@"diddit"];
            [relationForUser removeObject:bukkit];
            [user saveInBackground];
        }
    }];
}

-(void)bukkitCell:(BukkitCell *)bukkitCell didTapBukkit:(UIButton *)button {
    
    PFObject *bukkit = bukkitCell.bukkit;
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [bukkit relationforKey:@"bukkit"];
    [[relation query] getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            [relation addObject:user];
            [bukkit incrementKey:@"ranking"];
            [bukkit saveInBackground];
            
            PFRelation *relationForUser = [user relationforKey:@"bukkit"];
            [relationForUser addObject:bukkit];
            [user saveInBackground];
        } else {
            [relation removeObject:user];
            [bukkit incrementKey:@"ranking" byAmount:[NSNumber numberWithInt:-1]];
            [bukkit saveInBackground];
            
            PFRelation *relationForUser = [user relationforKey:@"bukkit"];
            [relationForUser removeObject:bukkit];
            [user saveInBackground];
        }
    }];
}

-(void)bukkitCell:(BukkitCell *)bukkitCell didTapComment:(UIButton *)button {
    
}

@end
