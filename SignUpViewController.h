//
//  SignUpViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 9/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,  FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UITextField *nameBox;
@property (weak, nonatomic) IBOutlet UITextField *emailBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordBox;
@property (weak, nonatomic) IBOutlet UITableView *signUpTable;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;

- (IBAction)signup:(id)sender;
- (IBAction)loginFacebookButtonTouchHandler:(id)sender;

@end
