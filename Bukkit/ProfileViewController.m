//
//  ProfileViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/8/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "ProfileViewController.h"
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end


@implementation ProfileViewController

@synthesize sidebarButton, nameText, profileView, upperBackgroundView, didditButton, bukkitButton, numberOfDiddit, numberOfBukkit, profile, pushedView;


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
    
    if (!pushedView) {
        
        //UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
        
        // [self.navigationController.navigationBar pushNavigationItem:navItem animated:NO];
        
        UIImage *image = [UIImage imageNamed:@"Menu-Button.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.leftBarButtonItem = menuButtonItem;
    
        // Set the gesture
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    nameText.text = [profile objectForKey:@"username"];
    upperBackgroundView.backgroundColor = RGB(34, 158, 245);
    
    PFFile *profPicFile = [profile objectForKey:@"profilepic"];
    [profPicFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.profileView.image = [UIImage imageWithData:imageData];
            profileView.backgroundColor = [UIColor clearColor];
            
            // Add a nice corner radius to the image
            self.profileView.layer.cornerRadius = 50.0;
            self.profileView.layer.masksToBounds = YES;
            
            profileView.layer.borderColor = [UIColor whiteColor].CGColor;
            profileView.layer.borderWidth = 2.0;
        }
    }];
    
    PFRelation *relationOfBukkit = [profile relationforKey:@"bukkit"];
    [[relationOfBukkit query] countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            if (count == 0) {
                numberOfBukkit.text = @"Add to BukkitList";
            } else if (count == 1){
                numberOfBukkit.text = [NSString stringWithFormat:@"%i Person", count];
            } else {
                numberOfBukkit.text = [NSString stringWithFormat:@"%i People", count];
            }
        } else {
            // The request failed
        }
    }];
    
    
    PFRelation *relationOfDiddit = [profile relationforKey:@"diddit"];
    [[relationOfDiddit query] countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if(!error) {
            if (number == 0) {
                numberOfDiddit.text = @"Accomplish in Diddit";
            } else if (number == 1){
                numberOfDiddit.text = [NSString stringWithFormat:@"%i Diddit", number];
            } else {
                numberOfDiddit.text = [NSString stringWithFormat:@"%i Diddit", number];
            }
            
        } else {
            
        }
    }];
}

-(IBAction)didTapBukkitButton {
    MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    NSString *listTitle = [NSString stringWithFormat:@"%@ Bukkit List", profile.username];
    mainViewController.nameOfList = listTitle;
    PFRelation *list = [profile relationforKey:@"bukkit"];
    mainViewController.query = [list query];
    mainViewController.navItem.title = [NSString stringWithFormat:@"%@'s Bukkit List", [profile objectForKey:@"username"]];
    mainViewController.pushedView = YES;
    [self.navigationController pushViewController:mainViewController animated:YES];
     
}

-(IBAction)didTapDidditButton {
    
    MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    NSString *listTitle = [NSString stringWithFormat:@"%@ Diddit List", profile.username];
    mainViewController.nameOfList = listTitle;
    PFRelation *list = [profile relationforKey:@"diddit"];
    mainViewController.query = [list query];
     mainViewController.navItem.title = [NSString stringWithFormat:@"%@'s Diddit List", [profile objectForKey:@"username"]];
    mainViewController.pushedView = YES;
    [self.navigationController pushViewController:mainViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
