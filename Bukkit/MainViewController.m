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

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addItemButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

-(IBAction)presentAddItemView:(id)sender;

@end

@implementation MainViewController

@synthesize sidebarButton, addItemButton, navItem, list;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
    
    // Change button color
    sidebarButton.tintColor = [UIColor colorWithWhite:0.16f alpha:0.8f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // [(AppDelegate *)[[UIApplication sharedApplication] delegate] getBukkitList:self];

    
    PFRelation *lists = [user relationforKey:@"lists"];
    
    [[lists query] getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            // There was an error
        } else {
            list = object;
            navItem.title = [object objectForKey:@"name"];
            // NSLog(@"%@", [object objectForKey:@"name"]);
        }
    }];
    
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(myRightAction)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
    
    

    PFQuery *query = [lists query];
    
    /*
    PFQuery *queryBukkitList = [PFQuery queryWithClassName:@"bukkit"];
    [query whereKey:@"list" matchesQuery:query];
    [queryBukkitList orderByDescending:@"createdAt"];
    // queryBukkitList.cachePolicy = kPFCachePolicyNetworkOnly;
    queryBukkitList.limit = 100;
    
    [queryBukkitList findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            
            if (objects.count == 0) {
                
            } else {
                for (PFObject *bukkitlist in objects) {
                    NSLog(@"%@", [bukkitlist objectForKey:@"title"]);
                }
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
     */
    
}

-(IBAction)presentAddItemView: (id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:nil];
    
    AddItemViewController *addItemController =
    [storyboard instantiateViewControllerWithIdentifier:@"AddItemViewController"];
    // addItemController.bukkitList = bukkitList;
    addItemController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addItemController];
    
     [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)cancelAddingItem:(AddItemViewController *) addItemController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
