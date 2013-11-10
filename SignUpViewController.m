//
//  SignUpViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 9/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "SignUpViewController.h"
#import "MainViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


@interface SignUpViewController ()

@end

@implementation SignUpViewController

@synthesize signUpButton, facebookButton, nameBox, emailBox, passwordBox, signUpTable, imageData;

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
	// Do any additional setup after loading the view.
    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"User is already signed in");
        // [self performSegueWithIdentifier:@"Signing Up" sender:facebookButton];
        // [self.navigationController pushViewController:
         // [MainViewController alloc] animated:NO];
    }
    
    [signUpTable setBackgroundView:nil];
    [signUpTable setBackgroundColor:UIColor.clearColor];
    signUpTable.allowsSelection=NO;
    
    [signUpButton setEnabled:NO];
    signUpButton.alpha = 0.5;
    
    [facebookButton setBackgroundColor:RGB(59, 89, 152)];
    facebookButton.titleLabel.shadowOffset = CGSizeMake(0.0, -0.8);
    
}


-(UITextField*) makeTextField: (NSString*)placeholder {
    UITextField *tf = [[UITextField alloc] init];
    tf.placeholder = placeholder ;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.adjustsFontSizeToFitWidth = YES;
    return tf ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return 3;
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
    
    if([indexPath row] == 0) {
        nameBox = [self makeTextField:@"Name"];
        nameBox.tag = 0;
        nameBox.keyboardType = UIKeyboardTypeAlphabet;
        nameBox.returnKeyType = UIReturnKeyNext;
        nameBox.delegate = self;
        nameBox.frame = CGRectMake(20, 12, 170, 30);
        [cell addSubview:nameBox];
    }
    if([indexPath row] == 1) {
        emailBox = [self makeTextField:@"Email"];
        emailBox.tag = 1;
        emailBox.keyboardType = UIKeyboardTypeEmailAddress;
        emailBox.returnKeyType = UIReturnKeyNext;
        emailBox.delegate = self;
        emailBox.frame = CGRectMake(20, 12, 170, 30);
        [cell addSubview:emailBox];
    }
    if ([indexPath row] == 2) {
        passwordBox = [self makeTextField:@"Password"];
        passwordBox.tag = 2;
        passwordBox.keyboardType = UIKeyboardTypeAlphabet;
        passwordBox.secureTextEntry = YES;
        passwordBox.returnKeyType = UIReturnKeyGo;
        passwordBox.delegate = self;
        passwordBox.frame = CGRectMake(20, 12, 170, 30);
        [cell addSubview:passwordBox];
        
    }
    
    return cell;
}


// To get rid of the section header for the tableview
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    switch (textField.tag) {
        case 0:
            [emailBox becomeFirstResponder];
            break;
            
        case 1:
            [passwordBox becomeFirstResponder];
            break;
            
        default:
             [self signup:textField];
            break;
            
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *testString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    testString = [testString stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *otherField = @"";
    NSString *otherOtherField = @"";
    
    if ([textField isEqual:nameBox]) {
        otherField = emailBox.text;
        otherOtherField = passwordBox.text;
    }
    if ([textField isEqual:emailBox]) {
        otherField = nameBox.text;
        otherOtherField = passwordBox.text;
    }
    else {
        otherField = nameBox.text;
        otherOtherField = emailBox.text;
    }
    // NSString *otherTextString = ([textField isEqual:password]) ? username.text : password.text;
    
    if(testString.length != 0 && otherField.length != 0 && otherOtherField.length != 0) {
        signUpButton.enabled = YES;
        signUpButton.alpha = 1.0;
    }
    else {
        signUpButton.enabled = NO;
        signUpButton.alpha = 0.5;
    }
    
    return YES;
}

-(IBAction)signup:(id)sender {
    if([self validEmail:emailBox.text]) {
        PFUser *user = [PFUser user];
        user.username = nameBox.text;
        user.email = emailBox.text;
        user.password = passwordBox.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
                NSLog(@"Hooray");
                [self performSegueWithIdentifier:@"Signing Up" sender:sender];
            } else {
                NSString *errorString = [error userInfo][@"error"];
                // Show the errorString somewhere and let the user try again.
                NSLog(@"%@", errorString);
                UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Sign Up"
                                                                  message:errorString
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                [errorMessage show];
            }
        }];
        
    }
    else {
        NSLog(@"Ah dang");
    }
}

- (IBAction)loginFacebookButtonTouchHandler:(id)sender  {
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"user_education_history"];
    
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
            [self linkSchoolwithUser:user];
        } else {
            NSLog(@"User with facebook logged in!");
            [self performSegueWithIdentifier:@"Signing Up" sender:facebookButton];
        }
    }];
}

-(void)linkSchoolwithUser:(PFUser *) user{
    
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSString *schoolName = @"";
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            
            NSArray *education = userData[@"education"];
            NSString *name = userData[@"name"];
            NSString *facebookID = userData[@"id"];
            
            imageData = [[NSMutableData alloc] init];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            
            if (!urlConnection) {
                NSLog(@"Failed to download picture");
            }

            
            for (FBGraphObject* edu in education) {
                if ([[edu objectForKey:@"type"] isEqualToString:@"College"]) {
                    schoolName = [[edu objectForKey:@"school"] objectForKey:@"name"];
                }
            }
            
            NSLog(@"USERNAME: %@", name);

            user.username = name;
            [self createUser:user andBukkitList:schoolName];
        }
    }];
}

-(void)createUser:(PFUser *) user andBukkitList:(NSString *)school {
    
    user[@"school"] = school;
    
    PFQuery *query = [PFQuery queryWithClassName:@"bukkitlist"];
    [query whereKey:@"name" equalTo:school];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            PFObject *bukkitlist = [PFObject objectWithClassName:@"bukkitlist"];
            [bukkitlist setObject:school forKey:@"name"];
            [bukkitlist saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                PFRelation *relation = [user relationforKey:@"lists"];
                [relation addObject:bukkitlist];
                [user setObject:bukkitlist forKey:@"defaultList"];
                [user saveInBackground];
            }];
        } else {
            // The find succeeded.
            PFRelation *relation = [user relationforKey:@"lists"];
            [relation addObject:object];
            [user setObject:object forKey:@"defaultList"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self performSegueWithIdentifier:@"Signing Up" sender:facebookButton];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
}


-(BOOL) validEmail:(NSString*)text {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [emailTest evaluateWithObject:text];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
