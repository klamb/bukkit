//
//  AppDelegate.h
//  Bukkit
//
//  Created by Kevin Lamb on 9/17/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController.h"
#import "ViewController.h"
#import "SettingsViewController.h"
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SWRevealViewController *revealViewController;
@property (nonatomic, strong) UIStoryboard *storyboard;

-(void)logOut:(SettingsViewController *) settingsViewController;
-(void)getBukkitList:(MainViewController *) mainViewController;
-(BOOL)checkForLogin;
-(void)presentLogInViewController;


@end
