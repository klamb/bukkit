//
//  ProfileViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/8/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "ProfileViewController.h"
#import "ActivityViewController.h"
#import <QuartzCore/QuartzCore.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end


@implementation ProfileViewController

@synthesize sidebarButton, nameText, profileView, upperBackgroundView, didditButton, bukkitButton, numberOfDiddit, numberOfBukkit;


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
    
     nameText.text = [[PFUser currentUser] objectForKey:@"username"];
    
    upperBackgroundView.backgroundColor = RGB(34, 158, 245);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    PFFile *profPicFile = [[PFUser currentUser] objectForKey:@"profilepic"];
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
    
    PFRelation *relationOfBukkit = [[PFUser currentUser] relationforKey:@"bukkit"];
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
    
    
    PFRelation *relationOfDiddit = [[PFUser currentUser] relationforKey:@"diddit"];
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

-(IBAction)didTapBukkitButton:(id)sender {
    ActivityViewController *activityViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
    activityViewController.showDidditUsers = NO;
    [self.navigationController pushViewController:activityViewController animated:YES];
}

-(IBAction)didTapDidditButton:(id)sender {
    ActivityViewController *activityViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
    activityViewController.showDidditUsers = YES;
    [self.navigationController pushViewController:activityViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
