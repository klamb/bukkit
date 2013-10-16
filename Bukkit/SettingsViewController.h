//
//  SettingsViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/8/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

-(IBAction)logOut:(id)sender;

@end
