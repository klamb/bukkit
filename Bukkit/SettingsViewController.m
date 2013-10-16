//
//  SettingsViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/8/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation SettingsViewController

@synthesize sidebarButton, logoutButton;

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
	// Do any additional setup after loading the view.
    
    // Change button color
    sidebarButton.tintColor = [UIColor colorWithWhite:0.16f alpha:0.8f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
}

-(IBAction)logOut:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
