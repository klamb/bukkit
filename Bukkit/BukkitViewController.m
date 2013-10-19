//
//  BukkitViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "BukkitViewController.h"

@interface BukkitViewController ()

@end

@implementation BukkitViewController

@synthesize numberOfBukkit, numberOfDiddit, titleBukkit, bukkit;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
