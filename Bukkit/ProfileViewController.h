//
//  ProfileViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/8/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController.h"

@interface ProfileViewController : UIViewController <NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (nonatomic, strong) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UIView *upperBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *didditButton;
@property (weak, nonatomic) IBOutlet UIButton *bukkitButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfBukkit;
@property (weak, nonatomic) IBOutlet UILabel *numberOfDiddit;

@property (weak, nonatomic) PFUser *profile;
@property (nonatomic, assign) BOOL pushedView;

-(IBAction)didTapBukkitButton;
-(IBAction)didTapDidditButton;

@end
