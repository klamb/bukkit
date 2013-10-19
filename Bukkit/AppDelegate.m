//
//  AppDelegate.m
//  Bukkit
//
//  Created by Kevin Lamb on 9/17/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation AppDelegate

@synthesize revealViewController, storyboard;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    // ****************************************************************************
    // Parse initialization
    [Parse setApplicationId:@"UvQUJni3ffqceFAN9A3znpedOc1eNHf3v3tyGdHE"
                  clientKey:@"ih9c1SogIstMaQzR0cSlhwqpx8Er3uvdErpN8MrR"];
    // ****************************************************************************
    
    [PFFacebookUtils initializeFacebook];
    [FBLoginView class];
    
    self.storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.revealViewController = [storyboard instantiateViewControllerWithIdentifier:@"RevealViewController"];
    
    self.window.rootViewController = self.revealViewController;
    [self.window makeKeyAndVisible];
    
    if([self checkForLogin]) {
        
    }
    
    [[UINavigationBar appearance] setBarTintColor:RGB(34, 158, 245)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           UITextAttributeTextColor: [UIColor whiteColor]
                                                           }];

    return YES;
}

-(BOOL)checkForLogin {
    if (![PFUser currentUser]) {
        [self presentLogInViewController];
        return YES;
    }
    else {
        return NO;
    }
}

-(void)logOut:(SettingsViewController *) settingsViewController {
    // Log out
    [PFUser logOut];
    
    
    ViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    [settingsViewController presentViewController:navigationController animated:NO completion:nil];
}

-(void)getBukkitList:(MainViewController *) viewController {
    PFUser *user = [PFUser currentUser];
    
    PFRelation *lists = [user relationforKey:@"lists"];
    
    [[lists query] getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            // There was an error
        } else {
            viewController.list = object;
            // navItem.title = [object objectForKey:@"name"];
            NSLog(@"%@", [object objectForKey:@"name"]);
        }
    }];
}

-(void)presentLogInViewController {
    ViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    [self.revealViewController presentViewController:navigationController animated:NO completion:nil];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
