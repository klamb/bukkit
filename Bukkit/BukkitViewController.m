//
//  BukkitViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "BukkitViewController.h"
#import "ActivityViewController.h"

@interface BukkitViewController ()

@end

@implementation BukkitViewController

@synthesize numberOfBukkit, numberOfDiddit, titleBukkit, bukkit, imageView, bukkitButton, didditButton;

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
    
    titleBukkit.text = [bukkit objectForKey:@"title"];
    
    PFFile *userImageFile = [bukkit objectForKey:@"Image"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [imageView setImage:image];
        }
    }];
    
    
    PFRelation *relationOfBukkitUsers = [bukkit relationforKey:@"bukkit"];
    [[relationOfBukkitUsers query] countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            if (count == 0) {
                numberOfBukkit.text = @"Be first to Bukkit";
            } else if (count == 1){
                numberOfBukkit.text = [NSString stringWithFormat:@"%i Person", count];
            } else {
                numberOfBukkit.text = [NSString stringWithFormat:@"%i People", count];
            }
        } else {
            // The request failed
        }
    }];
    
    
    PFRelation *relationOfDidditUsers = [bukkit relationforKey:@"diddit"];
    [[relationOfDidditUsers query] countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if(!error) {
            if (number == 0) {
                numberOfDiddit.text = @"Be first to Diddit";
            } else if (number == 1){
                numberOfDiddit.text = [NSString stringWithFormat:@"%i Person", number];
            } else {
                numberOfDiddit.text = [NSString stringWithFormat:@"%i People", number];
            }

        } else {
            
        }
    }];
    
}

-(IBAction)didTapBukkitButton:(id)sender {
    ActivityViewController *activityViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
    activityViewController.showDidditUsers = NO;
    activityViewController.selectedBukkit = bukkit;
    [self.navigationController pushViewController:activityViewController animated:YES];
}

-(IBAction)didTapDidditButton:(id)sender {
    ActivityViewController *activityViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
    activityViewController.showDidditUsers = YES;
    activityViewController.selectedBukkit = bukkit;
    [self.navigationController pushViewController:activityViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
