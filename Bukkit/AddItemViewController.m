//
//  TopRatedViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/11/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "AddItemViewController.h"

@interface AddItemViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

-(IBAction)cancel:(id)sender;

@end


@implementation AddItemViewController

@synthesize cancelButton, uploadPhotoButton, titleField, bukkitList, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    titleField.delegate = self;
    
    //titleField.layer.cornerRadius=8.0f;
    titleField.layer.masksToBounds=YES;
    titleField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    titleField.layer.borderWidth= 0.7f;
}


-(IBAction)cancel:(id)sender {
    [self.delegate cancelAddingItem:self];
}

-(IBAction)addItem:(id)sender {
    
    PFObject *bukkit = [PFObject objectWithClassName:@"bukkit"];
    [bukkit setObject:[NSNumber numberWithInt:0] forKey:@"ranking"];
    [bukkit setObject:titleField.text forKey:@"title"];
    [bukkit setObject:bukkitList forKey:@"list"];
    PFRelation *relation = [bukkit relationforKey:@"bukkit"];
    [relation addObject:[PFUser currentUser]];
    [self linkImageWithBukkit:bukkit];
}

-(IBAction)didTapUploadPhotoButton:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
    if(titleField)
        [actionSheet showInView:self.view];
}

-(void)linkImageWithBukkit:(PFObject *)bukkit {
    UIImage *image = [UIImage imageNamed:@"hong-kong.png"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [bukkit setObject:imageFile forKey:@"Image"];
            [bukkit saveInBackgroundWithBlock:^(BOOL succeded, NSError *error) {
                PFRelation *relation = [[PFUser currentUser] relationforKey:@"bukkit"];
                [relation addObject:bukkit];
                [[PFUser currentUser] saveInBackground];
                [self.delegate addItem:self];
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //[self shouldStartCameraController];
    } else if (buttonIndex == 1) {
        // [self shouldStartPhotoLibraryPickerController];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    [self addItem:textField];
    [textField resignFirstResponder];
    
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
