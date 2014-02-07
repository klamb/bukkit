//
//  SignUpViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 9/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PickerViewCell.h"
#import "WebViewController.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,  FBLoginViewDelegate, PickerViewCellDelegate, UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, WebViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UITextField *nameBox;
@property (weak, nonatomic) IBOutlet UITextField *emailBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordBox;
@property (weak, nonatomic) IBOutlet UITableView *signUpTable;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIPickerView *schoolPickerView;
@property (strong, nonatomic) IBOutlet UILabel *termsAndConditionsLabel;

@property (nonatomic, strong) NSMutableData *imageData;
@property (nonatomic, strong) NSArray *itemsArray;

- (IBAction)signup:(id)sender;
- (IBAction)loginFacebookButtonTouchHandler:(id)sender;
- (IBAction)dateAction:(id)sender;

@end
