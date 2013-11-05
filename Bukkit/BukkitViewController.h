//
//  BukkitViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol BukkitViewDelegate <NSObject>

@end

@interface BukkitViewController : UIViewController

@property(nonatomic, assign) id <BukkitViewDelegate> delegate;
@property(nonatomic, assign) PFObject *bukkit;

@property (weak, nonatomic) IBOutlet UILabel *titleBukkit;
@property (weak, nonatomic) IBOutlet UILabel *numberOfDiddit;
@property (weak, nonatomic) IBOutlet UILabel *numberOfBukkit;
@property (weak, nonatomic) IBOutlet UIButton *bukkitButton;
@property (weak, nonatomic) IBOutlet UIButton *didditButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

-(IBAction)didTapBukkitButton:(id)sender;
-(IBAction)didTapDidditButton:(id)sender;

@end
