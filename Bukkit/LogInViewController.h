//
//  LogInViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 9/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LogInViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, FBLoginViewDelegate, NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITableView *loginTable;

@property (nonatomic, strong) NSMutableData *imageData;


-(IBAction)login:(id)sender;
- (IBAction)loginFacebookButtonTouchHandler:(id)sender;

@end
