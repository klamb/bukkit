//
//  CreateListViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 12/8/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <Parse/Parse.h>
#import "CreateListViewController.h"

@interface CreateListViewController ()

@end

@implementation CreateListViewController

@synthesize cancelButton, createButton, textView, imageViewButton;

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
    
    self.automaticallyAdjustsScrollViewInsets = NO; // To prevent the blank space at top of uitextview
    
    textView.text = @"Name your List...";
    textView.textColor = [UIColor lightGrayColor];
    textView.delegate = self;
    self.listImage = [UIImage imageNamed:@"default-list.png"];
    
    [createButton setEnabled:NO];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if ([[self.textView text] length] != 0) {
        createButton.enabled = YES;
    } else {
        createButton.enabled = NO;
        self.textView.textColor = [UIColor lightGrayColor];
        self.textView.text = @"Name your List...";
        [self.textView resignFirstResponder];
    }
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    self.textView.text = @"";
    self.textView.textColor = [UIColor blackColor];
    return YES;
}

-(IBAction)cancel:(id)sender {
    [self.delegate cancel:self];
}

-(IBAction)createList:(id)sender {
    NSString *comment = [textView text];
    
    PFObject *newList = [PFObject objectWithClassName:@"bukkitlist"];
    [newList setValue:comment forKey:@"name"]; // Set list name
    [newList setValue:@0 forKey:@"type"]; // Set the list type
    [newList setValue:[PFUser currentUser] forKey:@"creator"]; // Set creator of list
    
    NSData *imageData = UIImageJPEGRepresentation(self.listImage, 0.05f);
    PFFile *imageFile = [PFFile fileWithName:@"ListImage.png" data:imageData];
    
    [newList setObject:imageFile forKey:@"Image"];
    
    [newList saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[[PFUser currentUser] relationforKey:@"lists"] addObject:newList];
        [[PFUser currentUser] saveInBackground];
        [self.delegate createNewList:sender];
    }];
}

-(IBAction)addImageToList:(id)sender {
    
    if([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    } else if (buttonIndex == 1) {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.listImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.imageViewButton setBackgroundImage:self.listImage forState:UIControlStateNormal];
    [self.imageViewButton setTitle:@"" forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
