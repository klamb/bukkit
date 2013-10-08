//
//  LogInViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 9/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

@synthesize logInButton, username, password, loginTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [loginTable setBackgroundView:nil];
    [loginTable setBackgroundColor:UIColor.clearColor];
    loginTable.allowsSelection=NO;
    
    [logInButton setEnabled:NO];
    logInButton.alpha = 0.5;
    
	// Do any additional setup after loading the view.
}

-(UITextField*) makeTextField: (NSString*)placeholder {
    UITextField *tf = [[UITextField alloc] init];
    tf.placeholder = placeholder ;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.adjustsFontSizeToFitWidth = YES;
    // tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    return tf ;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell... setting the text of our cell's label
    
    if ([indexPath row] == 0) {
         username = [self makeTextField:@"Username"];
         username.keyboardType = UIKeyboardTypeEmailAddress;
         username.returnKeyType = UIReturnKeyNext;
         [username becomeFirstResponder];
         username.delegate = self;
         [cell addSubview:username];
    }
    else {
        password = [self makeTextField:@"Password"];
        password.secureTextEntry = YES;
        password.returnKeyType = UIReturnKeyGo;
        password.delegate = self;
        [cell addSubview:password];
    }
    
    username.frame = CGRectMake(20, 12, 170, 30);
    password.frame = CGRectMake(20, 12, 170, 30);
    
    return cell;
}


// To get rid of the section header for the tableview
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField == self.username) {
        [username resignFirstResponder];
        [password becomeFirstResponder];
        
    }
    else {
        [password resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *testString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    testString = [testString stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *otherTextString = ([textField isEqual:password]) ? username.text : password.text;
    
    if(testString.length != 0 && otherTextString.length != 0) {
        logInButton.enabled = YES;
        logInButton.alpha = 1.0;
    }
    else {
        logInButton.enabled = NO;
        logInButton.alpha = 0.5;
    }
    
    return YES;
}

- (void) validateTextFields {
    NSLog(@"USERNAME: %@ PASSWORD %@", username.text, password.text);
    if (![username.text isEqualToString:@""] && ![password.text isEqualToString:@""]) {
        // NSLog(@"USERNAME: %@ PASSWORD %@", username.text, password.text);
        [logInButton setEnabled:YES];
    }
    else {
        [logInButton setEnabled:NO];
    }
}

- (IBAction)login:(id)sender {
    
    
    [PFUser logInWithUsernameInBackground:username.text password:password.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            [self performSegueWithIdentifier:@"LOGGING IN" sender:logInButton];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"Hah Yea Right");
                                        }
                                    }];
    
    }

@end
