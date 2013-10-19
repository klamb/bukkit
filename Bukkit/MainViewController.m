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
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

-(IBAction)presentAddItemView:(id)sender;

@end

@implementation MainViewController

@synthesize sidebarButton, addItemButton, navItem, list, segmentedControl;



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
    
    // Change button color
    sidebarButton.tintColor = [UIColor colorWithWhite:0.16f alpha:0.8f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    [segmentedControl addTarget:self
                         action:@selector(pickOne:)
               forControlEvents:UIControlEventValueChanged];
    
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
}

-(void) pickOne:(id)sender{
    
    segmentedControl = (UISegmentedControl *)sender;
    NSString *order = [segmentedControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    
    ListViewController *listVC = self.childViewControllers[0]; //assuming you have only one child
    [listVC updateTable:order];
}

-(IBAction)presentAddItemView: (id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:nil];
    
    AddItemViewController *addItemController =
    [storyboard instantiateViewControllerWithIdentifier:@"AddItemViewController"];
    addItemController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addItemController];
    
     [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)cancelAddingItem:(AddItemViewController *) addItemController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addItem:(id)sender {
    ListViewController *listVC = self.childViewControllers[0]; //assuming you have only one child
    listVC.shouldReloadOnAppear = YES;
    // [listVC loadObjects];
    
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

@end
