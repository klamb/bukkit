//
//  TopRatedViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/11/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "AddItemViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface AddItemViewController () <GKImagePickerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, strong) GKImagePicker *imagePicker;

-(IBAction)cancel:(id)sender;

@end


@implementation AddItemViewController

@synthesize cancelButton, uploadPhotoButton, titleField, bukkitList, delegate, takenImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
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
    if(titleField.text.length == 0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Empty Title Field"
                                                           message:@"You need to type in a title for this item."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [message show];
    } else {
        PFObject *bukkit = [PFObject objectWithClassName:@"bukkit"];
        [bukkit setObject:[NSNumber numberWithInt:0] forKey:@"ranking"];
        [bukkit setObject:titleField.text forKey:@"title"];
        [bukkit setObject:bukkitList forKey:@"list"];
        PFRelation *relation = [bukkit relationforKey:@"bukkit"];
        [relation addObject:[PFUser currentUser]];
        [self linkImageWithBukkit:bukkit];
    }
}

-(IBAction)didTapUploadPhotoButton:(id)sender {
    
    [titleField resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
    if(titleField)
        [actionSheet showInView:self.view];
}

-(void)linkImageWithBukkit:(PFObject *)bukkit {
    if(!self.takenImage) {
        takenImage = [UIImage imageNamed:@"hong-kong.png"];
    }
    
    NSData *imageData = UIImageJPEGRepresentation(takenImage, 0.05f);
    
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

- (BOOL)shouldStartUIImagePickerController:(CGSize) rect sourceTypeCamera:(BOOL) showCamera  {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO && showCamera == YES) {
        return NO;
    }
    
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = rect;
    
    if(showCamera) {
        self.imagePicker.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    } else {
        self.imagePicker.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
    // [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.takenImage = image;
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    self.takenImage = image;
    [self hideImagePicker];
}

- (void)hideImagePicker{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self shouldStartUIImagePickerController:CGSizeMake(320, 137) sourceTypeCamera:YES];
    } else if (buttonIndex == 1) {
        [self shouldStartUIImagePickerController:CGSizeMake(320, 137) sourceTypeCamera:NO];
    }
}



-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    // [self addItem:textField];
    [textField resignFirstResponder];
    
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
