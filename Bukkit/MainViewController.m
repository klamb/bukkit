//
//  MainViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 9/30/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "MainViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

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

-(IBAction)presentAddItemView:(id)sender;

@end

@implementation MainViewController

@synthesize sidebarButton, addItemButton, navItem, list, topRated, shouldReloadOnAppear, userList, query, nameOfList, pushedView;



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
        
        self.topRated = NO;
        
        self.shouldReloadOnAppear = NO;
        
        self.userList = NO;
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
        button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height);
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        menuButtonItem.tintColor = [UIColor colorWithWhite:0.16f alpha:0.8f];
        self.navigationItem.leftBarButtonItem = menuButtonItem;
        
        // Set the gesture
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [list fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        navItem.title = [object objectForKey:@"name"];
    }];
}



#pragma mark - SegmentedControl action
-(void) pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSString *order = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    [self updateTable:order];
}


#pragma mark - Present Add Item Viewcontroller

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

-(void)showUIPickerView:(AddItemViewController *) addItemController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self shouldStartCameraController];
}


- (BOOL)shouldStartCameraController {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
        && [[UIImagePickerController availableMediaTypesForSourceType:
             UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
        
        cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *) kUTTypeImage];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
    } else {
        return NO;
    }
    
    cameraUI.allowsEditing = YES;
    cameraUI.showsCameraControls = YES;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
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
        return 208.0f;
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
        PFQuery *noUserQuery = [PFQuery queryWithClassName:self.parseClassName];
        [noUserQuery setLimit:0];
        return noUserQuery;
    }
    
    if(topRated) {
        [query orderByDescending:@"ranking"];
    }
    else {
        [query orderByDescending:@"createdAt"];
    }
    
    query.limit = 100;
    return query;
    
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
    
    if ([cell.imageView.file isDataAvailable]) {
        [cell.imageView loadInBackground];
    }
    
    
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
        segmentedControl.frame = CGRectMake(0, 0, 320, 30);
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
    
    if(indexPath.section == 0) {
        
    }
    else if (indexPath.section > self.objects.count && self.paginationEnabled) {
        // Load More Cell
        [self loadNextPage];
    } else {
        [self loadBukkitView:self.objects[indexPath.section-1]];
    }
}

-(void)loadBukkitView:(PFObject *)object {
    
    BukkitViewController *bukkitViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"BukkitViewController"];
    bukkitViewController.delegate = self;
    bukkitViewController.bukkit = object;
    
    [self.navigationController pushViewController:bukkitViewController animated:YES];
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
            [user incrementKey:@"didditRanking"];
            [user saveInBackground];
        } else {
            [relation removeObject:user];
            [bukkit incrementKey:@"ranking" byAmount:[NSNumber numberWithInt:-1]];
            [bukkit saveInBackground];
            
            PFRelation *relationForUser = [user relationforKey:@"diddit"];
            [relationForUser removeObject:bukkit];
            [user incrementKey:@"didditRanking" byAmount:[NSNumber numberWithInt:-1]];
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
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:nil];
    
    CommentViewController *addCommentViewController =
    [storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    addCommentViewController.delegate = self;
    //addCommentViewController.bukkitList = list;
    UINavigationController *commentNavController = [[UINavigationController alloc] initWithRootViewController:addCommentViewController];
    
    [self presentViewController:commentNavController animated:YES completion:nil];
     */
}


#pragma mark - CommentViewDelegate Methods

- (void)cancelAddingComment:(CommentViewController *)addCommentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)addComment:(id)sender {
    
}


@end
