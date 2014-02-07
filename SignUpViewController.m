//
//  SignUpViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 9/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "SignUpViewController.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define kDatePickerTag              99     // view tag identifiying the date picker view
#define kDateKey        @"date"    // key for obtaining the data source item's date value
#define schoolRow 3

static NSString *kDatePickerID = @"schoolPicker"; // the cell containing the date picker
static NSString *kOtherCell = @"otherCell";     // the remaining cells at the end
static NSString *kDateCellID = @"schoolCell";     // the cells with the start or end date

@interface SignUpViewController ()

@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (nonatomic, strong) NSArray *dataArray;
@property (assign) NSInteger pickerCellRowHeight;

@end

@implementation SignUpViewController

@synthesize signUpButton, facebookButton, nameBox, emailBox, passwordBox, signUpTable, imageData, itemsArray, scrollView, schoolPickerView, datePickerIndexPath, termsAndConditionsLabel;

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
    
    [self.scrollView bringSubviewToFront:self.signUpButton];
    
    self.termsAndConditionsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.termsAndConditionsLabel.numberOfLines = 0;
    // [self.view addSubview:self.termsAndConditionsLabel];
    
    itemsArray = [[NSArray alloc] initWithObjects:@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 6", nil];
    [self.view setBackgroundColor:RGB(244, 244, 244)];
    
    [signUpTable setBackgroundView:nil];
    [signUpTable setBackgroundColor:UIColor.clearColor];
    // signUpTable.allowsSelection=NO;
    
    [signUpButton setEnabled:NO];
    signUpButton.alpha = 0.5;
    
    [facebookButton setBackgroundColor:RGB(59, 89, 152)];
    facebookButton.titleLabel.shadowOffset = CGSizeMake(0.0, -0.8);
    
    UITableViewCell *pickerViewCellToCheck = [self.signUpTable dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    /*
    self.schoolPickerView = (UIPickerView *)[pickerViewCellToCheck viewWithTag:kDatePickerTag];
    self.schoolPickerView.delegate = self;
    self.schoolPickerView.dataSource = self;
     */
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    // [tap setCancelsTouchesInView:NO];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnLink)];
    // if labelView is not set userInteractionEnabled, you must do so
    [self.termsAndConditionsLabel setUserInteractionEnabled:YES];
    [self.termsAndConditionsLabel addGestureRecognizer:gesture];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)userTappedOnLink {
    WebViewController *webViewController = [[WebViewController alloc] init];
    webViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - WebViewDelegate

-(void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath {
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.signUpTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIPickerView *checkDatePicker = (UIPickerView *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}


/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.signUpTable cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIPickerView *targetedPicker = (UIPickerView *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedPicker != nil)
        {
            // NEED TO CHANGE THIS AND UPDATE THE PICKER BASED ON THE VALUE OF THE ABOVE CELL
            
            
            // we found a UIDatePicker in this cell, so update it's date value
            //
            //NSDictionary *itemData = self.dataArray[self.datePickerIndexPath.row - 1];
            
            //[targetedPicker setDate:[itemData valueForKey:kDateKey] animated:NO];
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath {
    return (indexPath.row == schoolRow) ? YES : NO;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.signUpTable.rowHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self hasInlineDatePicker]) {
        return 5;
    }
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSString *cellID = kOtherCell;
    
    if ([self indexPathHasPicker:indexPath])
    {
        // the indexPath is the one containing the inline picker
        cellID = kDatePickerID;     // the current/opened picker cell
    }
    else if ([self indexPathHasDate:indexPath])
    {
        // the indexPath is one that contains the date information
        cellID = kDateCellID;       // the school cell
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    // if we have a date picker open whose cell is above the cell we want to update,
    // then we have one more cell than the model allows
    //
    
    if ([cellID isEqualToString:kDateCellID]) {
        cell.textLabel.text = @"School";
        cell.textLabel.textColor = RGB(144, 144, 144);
        cell.detailTextLabel.text = @" ";
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    if ([cellID isEqualToString:kOtherCell]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
            passwordBox.returnKeyType = UIReturnKeyNext;
            passwordBox.delegate = self;
            passwordBox.frame = CGRectMake(20, 12, 170, 30);
            [cell addSubview:passwordBox];
            
        }
    }
    
	return cell;
}

/*! Adds or removes a UIPickerView cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.signUpTable beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    // check if 'indexPath' has an attached picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.signUpTable deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.scrollView bringSubviewToFront:self.signUpButton];
        [self.scrollView bringSubviewToFront:self.termsAndConditionsLabel];
    }
    else
    {
        if([nameBox isFirstResponder]) {
            [nameBox resignFirstResponder];
        }
        if ([emailBox isFirstResponder]) {
            [emailBox resignFirstResponder];
        }
        if([passwordBox isFirstResponder]) {
            [passwordBox resignFirstResponder];
        }
        
        [self.scrollView sendSubviewToBack:self.signUpButton];
        [self.scrollView sendSubviewToBack:self.termsAndConditionsLabel];
        // [scrollView setContentOffset:CGPointMake(0, 55) animated:YES];
        
        // didn't find a picker below it, so we should insert it
        [self.signUpTable insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.signUpTable endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [scrollView setContentOffset:CGPointMake(0, 55) animated:YES];
    
    // display the picker inline with the table content
    [self.signUpTable beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.signUpTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.scrollView bringSubviewToFront:self.signUpButton];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    // always deselect the row containing the school
    [self.signUpTable deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.signUpTable endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDateCellID) {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.signUpTable indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.signUpTable cellForRowAtIndexPath:targetedCellIndexPath];
    
    // update the cell's date string
    cell.detailTextLabel.text = [itemsArray objectAtIndex:targetedCellIndexPath.row];
}

-(void)updateChosenSchool:(NSString *)school {
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.signUpTable indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.signUpTable cellForRowAtIndexPath:targetedCellIndexPath];
    
    // update the cell's date string
    cell.detailTextLabel.text = school;
}

-(void)selectItem {
    [self displayInlineDatePickerForRowAtIndexPath:[NSIndexPath indexPathForRow:schoolRow inSection:0]];
}


-(UITextField*) makeTextField: (NSString*)placeholder {
    UITextField *tf = [[UITextField alloc] init];
    tf.placeholder = placeholder ;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.adjustsFontSizeToFitWidth = YES;
    return tf ;
}

-(void)dismissKeyboard {
    if([nameBox isFirstResponder]) {
        [nameBox resignFirstResponder];
    }
    if ([emailBox isFirstResponder]) {
        [emailBox resignFirstResponder];
    }
    if([passwordBox isFirstResponder]) {
        [passwordBox resignFirstResponder];
    }
    
    [UIView animateWithDuration:0.3f animations:^ {
        self.scrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
    }];
    [self.scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
}


// To get rid of the section header for the tableview
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (void)myNotificationMethod:(NSNotification*)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    self.scrollView.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height -keyboardFrameBeginRect.size.height);
    /*
    [UIView animateWithDuration:0.3f animations:^ {
        self.scrollView.frame = CGRectMake(0, 0, 320, 480-keyboardFrameBeginRect.size.height);
    }]; 
     */
    [scrollView setContentOffset:CGPointMake(0, 55) animated:YES];
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
            [self selectItem]; // [self signup:textField];
            break;
            
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *testString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    testString = [testString stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // NSArray *fields = [NSArray arrayWithObjects:testString,emailBox.text,passwordBox.text,nil];
    //[self testFields:[NSArray arrayWithObjects:testString,emailBox.text,passwordBox.text,nil]];
    
    //NSString *otherField = @"";
    //NSString *otherOtherField = @"";
    
    if ([textField isEqual:nameBox]) {
        [self testFields:[NSArray arrayWithObjects:testString, emailBox.text, passwordBox.text, nil]];
        //otherField = emailBox.text;
        //otherOtherField = passwordBox.text;
    }
    if ([textField isEqual:emailBox]) {
        [self testFields:[NSArray arrayWithObjects:testString, nameBox.text, passwordBox.text, nil]];
        //otherField = nameBox.text;
        //otherOtherField = passwordBox.text;
    }
    else {
        [self testFields:[NSArray arrayWithObjects:testString, nameBox.text, emailBox.text, nil]];
        //otherField = nameBox.text;
        //otherOtherField = emailBox.text;
    }
    /*
    if(testString.length != 0 && otherField.length != 0 && otherOtherField.length != 0) {
        signUpButton.enabled = YES;
        signUpButton.alpha = 1.0;
    }
    else {
        signUpButton.enabled = NO;
        signUpButton.alpha = 0.5;
    }
    */
    return YES;
}

-(void)testFields:(NSArray *)inputs {
    BOOL isValid = YES;
    for(NSString *input in inputs) {
        if (!input.length)
            isValid = NO;
    }
    
    if (isValid) {
        signUpButton.enabled = YES;
        signUpButton.alpha = 1.0;
    }
    else {
        signUpButton.enabled = NO;
        signUpButton.alpha = 0.5;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self hasInlineDatePicker]) {
        [self displayInlineDatePickerForRowAtIndexPath:[NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0]];
    }
}

#pragma mark - UIPickerView DataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [itemsArray count];
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [itemsArray objectAtIndex:row];
}

/*
//If the user chooses from the pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Let's print in the console what the user had chosen;
    NSLog(@"Chosen item: %@", [itemsArray objectAtIndex:row]);
}
 */



-(IBAction)signup:(id)sender {
    if([self validEmail:emailBox.text]) {
        PFUser *user = [PFUser user];
        user[@"name"] = nameBox.text;
        user.username = emailBox.text;
        user.email = emailBox.text;
        user.password = passwordBox.text;
        UITableViewCell *cell =[signUpTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        user[@"school"] = cell.detailTextLabel.text;
        [user setObject:[NSNumber numberWithInt:0] forKey:@"didditRanking"];
        
        UIImage *profilePic = [UIImage imageNamed:@"default-profile.png"];
        NSData *profilePicImageData = UIImageJPEGRepresentation(profilePic, 0.05f);
        PFFile *imageFile = [PFFile fileWithName:@"Default-Pic.png" data:profilePicImageData];
        [user setObject:imageFile forKey:@"profilepic"];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
                NSLog(@"Hooray");
                [self createUser:user];
                // [self performSegueWithIdentifier:@"Signing Up" sender:sender];
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
            [self getUserData:user];
        } else {
            NSLog(@"User with facebook logged in!");
            [self performSegueWithIdentifier:@"Signing Up" sender:facebookButton];
        }
    }];
}

-(void)getUserData:(PFUser *) user{
    
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
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

            NSString *schoolName = @"";
            for (FBGraphObject* edu in education) {
                if ([[edu objectForKey:@"type"] isEqualToString:@"College"]) {
                    schoolName = [[edu objectForKey:@"school"] objectForKey:@"name"];
                }
            }

            user[@"name"] = name;
            user[@"school"] = schoolName;
            [user setObject:[NSNumber numberWithInt:0] forKey:@"didditRanking"];
            
            [self createUser:user];
        }
    }];
}

-(void)createUser:(PFUser *) user {
    
    PFQuery *query = [PFQuery queryWithClassName:@"bukkitlist"];
    [query whereKey:@"name" equalTo:[user objectForKey:@"school"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            PFObject *schoolList = [PFObject objectWithClassName:@"bukkitlist"];
            [schoolList setObject:[user objectForKey:@"school"] forKey:@"name"];
            [schoolList saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                PFRelation *relation = [user relationforKey:@"lists"];
                [relation addObject:schoolList];
                [user setObject:schoolList forKey:@"defaultList"];
                
                PFObject *bukkitList = [self createListFor:[user objectForKey:@"name"] ofType:@"Bukkit List"];
                // [[user relationforKey:@"lists"] addObject:bukkitList];
                [user setObject:bukkitList forKey:@"bukkitList"];
                
                PFObject *didditList = [self createListFor:[user objectForKey:@"name"] ofType:@"Diddit List"];
                // [[user relationforKey:@"lists"] addObject:didditList];
                [user setObject:didditList forKey:@"didditList"];
                
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [self performSegueWithIdentifier:@"Signing Up" sender:facebookButton];
                    }
                    else{
                        NSLog(@"Error: %@ %@", error, [error userInfo]);  // Log details of the failure
                    }
                }];
            }];
        } else {
            // The find succeeded.
            PFRelation *relation = [user relationforKey:@"lists"];
            [relation addObject:object];
            [user setObject:object forKey:@"defaultList"];
            
            user[@"bukkitList"] = [self createListFor:[user objectForKey:@"name"] ofType:@"Bukkit List"];;
            user[@"didditList"] = [self createListFor:[user objectForKey:@"name"] ofType:@"Diddit List"];
            
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

-(PFObject *)createListFor:(NSString *)username ofType:(NSString *)typeName {
    PFObject *list = [PFObject objectWithClassName:@"bukkitlist"];
    NSArray *myArray = [username componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    NSString *stringName = [NSString stringWithFormat:@"%@'s %@", myArray[0], typeName];
    [list setObject:stringName forKey:@"name"];
    // [list setObject:[PFUser currentUser] forKey:@"creator"];
    return list;
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


#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:signUpTable]) {
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
