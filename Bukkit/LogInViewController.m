//
//  LogInViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 9/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "LogInViewController.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface LogInViewController ()

@end

@implementation LogInViewController

@synthesize logInButton, username, password, loginTable, facebookButton, imageData;

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
    
    [facebookButton setBackgroundColor:RGB(59, 89, 152)];
    facebookButton.titleLabel.shadowOffset = CGSizeMake(0.0, -0.8);
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
        [self login:theTextField];
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
                                            NSString *errorString = [error userInfo][@"error"];
                                            // Show the errorString somewhere and let the user try again.
                                            UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Log In"
                                                                                                   message:errorString
                                                                                                  delegate:nil
                                                                                         cancelButtonTitle:@"OK"
                                                                                         otherButtonTitles:nil];
                                            [errorMessage show];
                                        }
                                    }];
    
    }

- (IBAction)loginFacebookButtonTouchHandler:(id)sender  {
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        // [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
             [self loadProfileView:user];
            [self performSegueWithIdentifier:@"LOGGING IN" sender:facebookButton];
        } else {
            NSLog(@"User with facebook logged in!");
            [self loadProfileView:user];
            [self performSegueWithIdentifier:@"LOGGING IN" sender:facebookButton];
            // [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }
    }];
}

-(void)loadProfileView:(PFUser *) user {
    NSLog(@"Loading... ");
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            // Download the user's facebook profile picture
            imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
            
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            
            if (!urlConnection) {
                NSLog(@"Failed to download picture");
            }
            
            
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];

}

#pragma mark - NSURLConnectionDataDelegate

/* Callback delegate methods used for downloading the user's profile picture */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // All data has been downloaded, now we can set the image in the header image view
    // UIImage *profilePic = [UIImage imageWithData:self.imageData];
    NSLog(@"Got the picture...");
    PFFile *imageFile = [PFFile fileWithName:@"profilepic.jpg" data:self.imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFUser *user = [PFUser currentUser];
            [user setObject:imageFile forKey:@"profilepic"];
            [user saveInBackground];
            
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
