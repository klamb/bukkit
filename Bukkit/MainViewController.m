//
//  MainViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 9/30/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "MainViewController.h"
#import "CustomSegmentedControl.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addItemButton;

@property (nonatomic, assign) BOOL topRated;
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@property (nonatomic, assign) BOOL endOfList;

@property (nonatomic, assign) NSInteger previousNumOfObjects;

-(IBAction)presentAddItemView:(id)sender;

@end

@implementation MainViewController

@synthesize sidebarButton, addItemButton, navItem, list, topRated, shouldReloadOnAppear, userList, query, nameOfList, pushedView, editable;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
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
        self.textKey = @"title";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        self.topRated = YES;
        
        self.shouldReloadOnAppear = NO;
        
        self.userList = NO;
        
        self.editable = YES;
        
        self.endOfList = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        return;
    }
    
    if (!pushedView) {
        UIImage *image = [UIImage imageNamed:@"Menu-Button.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        menuButtonItem.tintColor = [UIColor colorWithWhite:0.16f alpha:0.8f];
        self.navigationItem.leftBarButtonItem = menuButtonItem;
        
        // Set the gesture
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    PFQuery *listsQuery = [[[PFUser currentUser] relationforKey:@"lists"] query];
    [listsQuery whereKey:@"objectId" equalTo:list.objectId];
    [listsQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            if(number > 0) {
                UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentAddItemView:)];
                menuButtonItem.tintColor = [UIColor whiteColor];
                self.navigationItem.rightBarButtonItem = menuButtonItem;
            }
        }
    }];
    
    [list fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        navItem.title = [object objectForKey:@"name"];
    }];
    
    CGRect footerRect = CGRectMake(0, 0, self.view.frame.size.width, 30);
    UIView *footerView = [[UIView alloc] initWithFrame:footerRect];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.center = CGPointMake(footerView.frame.size.width/2, footerView.frame.size.height/2);
    self.activityIndicatorView.hidesWhenStopped = YES;
    [footerView addSubview:self.activityIndicatorView];
    
    self.tableView.tableFooterView = footerView;
    
    [self.tableView reloadData];
}



#pragma mark - SegmentedControl action
-(void) pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSString *order = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    
    if([order isEqualToString:@"Most Popular"])
        self.topRated = YES;
    else
        self.topRated = NO;
    
    [self loadObjects];
}


#pragma mark - Present Add Item Viewcontroller

-(IBAction)presentAddItemView: (id)sender {
    
    AddItemViewController *addItemController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"AddItemViewController"];
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

#pragma mark - Present Item ViewController

-(void)loadBukkitView:(PFObject *)object isAnimated:(BOOL)isAnimated {
    
    BukkitViewController *bukkitViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"BukkitViewController"];
    bukkitViewController.delegate = self;
    bukkitViewController.bukkit = object;
    
    [self.navigationController pushViewController:bukkitViewController animated:isAnimated];
}

-(void)deletedItem {
    self.shouldReloadOnAppear = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (section == 0 || section == 1) {
        return 0.000001f;
    }
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.000001f;
    }
    else if (section > self.objects.count) {
        return 0.000001f;
    } else {
        return 8.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > self.objects.count) {
        return 50.0f;   // Load More Section
    } else if (indexPath.section == 0) {
        return 30.0f;   // Segmented Control Section
    } else {
        return 208.0f;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] resetNavigationBar:self.navigationController.navigationBar];
}


- (PFQuery *)queryForTable {
    
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        PFQuery *noUserQuery = [PFQuery queryWithClassName:self.parseClassName];
        [noUserQuery setLimit:0];
        return noUserQuery;
    }
    
    PFQuery *postQuery = [[list relationforKey:@"items"] query];

    if(topRated) {
        [postQuery orderByDescending:@"ranking"];
    }
    else {
        [postQuery orderByDescending:@"createdAt"];
    }
    
    postQuery.limit = 100;
    return postQuery;
    
    // queryBukkitList.cachePolicy = kPFCachePolicyIgnoreCache;
    
    // A pull-to-refresh should always trigger a network request.
    // [queryBukkitList setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    //if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
    // [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    //}
}

- (void)loadObjects {
    [super loadObjects];
    
    self.previousNumOfObjects = 0;
    self.endOfList = NO;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    if (self.previousNumOfObjects >= self.objects.count) {
        self.endOfList = YES;
        
    }
    self.previousNumOfObjects = self.objects.count;
    
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
    }
    
    if ([self.objects count] == 0) {
        NSLog(@"Database is empty");
        
        UIView *emptyTableView = [[UIView alloc] initWithFrame:self.tableView.bounds];
        
        UIImage *image = [UIImage imageNamed:@"no-items-in-list.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(15, 90, 300, 56)];
        [emptyTableView addSubview:imageView];
        
        [self.tableView setBackgroundView:emptyTableView];
    } else  {
        self.tableView.backgroundView = nil;
    }
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
    cell.imageView.file = [object objectForKey:@"Image"];
    
    if (topRated)
        cell.rank.text = [NSString stringWithFormat:@"%d", indexPath.section];
    else
        cell.rank.text = [self getTimeElapsed:object.createdAt];
    
    if ([cell.imageView.file isDataAvailable]) {
        [cell.imageView loadInBackground];
    }
    
    cell.item = object;
    
    [self checkForUserActivity:object forButton:cell.didditButton];
    [self checkForUserActivity:object forButton:cell.bukkitButton];
    
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
        NSArray *itemArray = [NSArray arrayWithObjects: @"Most Recent", @"Most Popular", nil];
        CustomSegmentedControl *segmentedControl = [[CustomSegmentedControl alloc] initWithItems:itemArray];
        
        [segmentedControl addTarget:self
                             action:@selector(pickOne:)
                   forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:segmentedControl];
    }
    
    return cell;
}


-(void)updateBukkitCell:(PFObject *)object fromButton:(id)sender {
    NSIndexPath *indexPath = [self indexPathForObject:object];
    BukkitCell *cell = (BukkitCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    UIButton *buttonType = (UIButton *)sender;
    if ([buttonType.titleLabel.text isEqualToString:@"Bukkit"]) {
        [cell didTapBukkitButtonAction:nil];
    } else {
        [cell didTapDidditButtonAction:nil];
    }
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


-(NSString *)getTimeElapsed:(NSDate *)timeStamp {
    NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:timeStamp];
    double secondsInAnHour = 3600;
    double secondsInAMinute = 60;
    double secondsInADay = 86400;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    
    if (hoursBetweenDates <= 0) {
        NSInteger minutesBetweenDates = distanceBetweenDates / secondsInAMinute;
        return [NSString stringWithFormat:@"%dm", minutesBetweenDates];
    } else if(hoursBetweenDates >= 24) {
        NSInteger daysBetweenDates = distanceBetweenDates/secondsInADay;
        return [NSString stringWithFormat:@"%dd", daysBetweenDates];
    } else {
        return [NSString stringWithFormat:@"%dh", hoursBetweenDates];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section != 0) {
        if (indexPath.section > self.objects.count && self.paginationEnabled) {
            [self loadNextPage]; // Load More Cell
        } else {
            [self loadBukkitView:self.objects[indexPath.section-1] isAnimated:YES];
        }
    }
}

-(void)bukkitCell:(BukkitCell *)bukkitCell didTapDiddit:(UIButton *)button {

    PFObject *bukkit = bukkitCell.item;
    [[bukkit relationforKey:@"diddit"] addObject:[PFUser currentUser]];
}

-(void)bukkitCell:(BukkitCell *)bukkitCell didTapBukkit:(UIButton *)button {
    
    PFObject *bukkit = bukkitCell.item;
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [bukkit relationforKey:@"bukkit"];
    PFQuery *queryBukkit = [relation query];
    [queryBukkit whereKey:@"objectId" equalTo:user.objectId];
    
    [queryBukkit getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
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
    
    CommentViewController *addCommentViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    addCommentViewController.delegate = self;
    addCommentViewController.bukkit = bukkitCell.item;
    addCommentViewController.mainListComment = YES;
    UINavigationController *commentNavController = [[UINavigationController alloc] initWithRootViewController:addCommentViewController];
    
    [self presentViewController:commentNavController animated:YES completion:nil];
}


#pragma mark - CommentViewDelegate Methods

- (void)cancelAddingComment:(CommentViewController *)addCommentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addComment:(id)sender toBukkit:(PFObject *)bukkit {
    CommentViewController *commentVC = (CommentViewController *)sender;
    
    if(commentVC.mainListComment) {
        [self loadBukkitView:bukkit isAnimated:NO];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height - scrollView.contentOffset.y < (self.view.bounds.size.height) && !self.endOfList) {
        if (![self isLoading]) {
            [self.activityIndicatorView startAnimating];
            [self loadNextPage];
            NSLog(@"Loading");
        }
    }
}

@end
