//
//  ViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 9/17/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize signUpButton, logInButton;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"User is already signed in");
        [self performSegueWithIdentifier: @"LoggedIn" sender: self];
    }
     // self.view.backgroundColor = [UIColor redColor];
	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)login {
    //self.view.backgroundColor = [UIColor redColor];
    // [self.navigationController pushViewController:viewcontroller animated:NO];
    // [self performSegueWithIdentifier:@"Logging In" sender:self];
    // [self performSegueWithIdentifier:@"LoggingIn" sender:self];
}

- (IBAction)signin {
     // self.view.backgroundColor = [UIColor blueColor];
    //[self performSegueWithIdentifier:@"Signing Up" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
