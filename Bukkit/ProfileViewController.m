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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end


@implementation ProfileViewController

@synthesize sidebarButton, nameText, profileView, upperBackgroundView, didditButton, bukkitButton, numberOfDiddit, numberOfBukkit, profile, pushedView, containerView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Change button color
    //sidebarButton.tintColor = [UIColor colorWithWhite:0.16f alpha:0.8f];
    
    
    if (!pushedView) {
        UIImage *image = [UIImage imageNamed:@"Menu-Button.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.leftBarButtonItem = menuButtonItem;
    
        // Set the gesture
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    nameText.text = [profile objectForKey:@"name"];
    upperBackgroundView.backgroundColor = RGB(34, 158, 245);
    [bukkitButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
    [didditButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
    
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
    
    PFObject *bukkitList = [profile objectForKey:@"bukkitList"];
    PFRelation *bukkitListRelation = [bukkitList relationforKey:@"items"];
    [[bukkitListRelation query] countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            if (count == 1) {
                [bukkitButton setTitle:[NSString stringWithFormat:@"%i Item", count] forState:UIControlStateNormal];
            } else {
                [bukkitButton setTitle:[NSString stringWithFormat:@"%i Items", count] forState:UIControlStateNormal];
            }
        }
    }];
    
    PFObject *didditList = [profile objectForKey:@"didditList"];
    PFRelation *didditListRelation = [didditList relationforKey:@"items"];
    [[didditListRelation query] countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if(!error) {
            if (number == 1) {
                [didditButton setTitle:[NSString stringWithFormat:@"%i Item", number] forState:UIControlStateNormal];
            } else {
                [didditButton setTitle:[NSString stringWithFormat:@"%i Items", number] forState:UIControlStateNormal];
            }
        }
    }];
}

-(IBAction)didTapBukkitButton {
    [self presentList:@"bukkitList" withTitle:@"Bukkit List"];
}

-(IBAction)didTapDidditButton {
    [self presentList:@"didditList" withTitle:@"Diddit List"];
}

-(void)presentList:(NSString *)type withTitle:(NSString *)listName {
    
    MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    PFObject *list = [profile objectForKey:type];
    mainViewController.list = list;
    mainViewController.pushedView = YES;
    
    if ([[PFUser currentUser].objectId isEqualToString:profile.objectId]) {
        mainViewController.editable = YES;
    }
    else {
        mainViewController.editable = NO;
    }
    [self.navigationController pushViewController:mainViewController animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"containerView"]) {
        ListViewController *listViewController = (ListViewController *)segue.destinationViewController;
        listViewController.delegate = self;
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark ListViewController Delegate Methods

-(PFUser *)getProfile {
    return self.profile;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
