//
//  CommentViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 11/17/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

@synthesize cancelButton, textView, postButton, bukkit, mainListComment;

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    textView.text = @"Add a Comment...";
    textView.textColor = [UIColor lightGrayColor];
    textView.delegate = self;
    [textView becomeFirstResponder];
    
    [postButton setEnabled:NO];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if ([[self.textView text] length] != 0) {
        postButton.enabled = YES;
    } else {
        postButton.enabled = NO;
        self.textView.textColor = [UIColor lightGrayColor];
        self.textView.text = @"Add a Comment...";
        [self.textView resignFirstResponder];
    }
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    self.textView.text = @"";
    self.textView.textColor = [UIColor blackColor];
    return YES;
}

-(IBAction)cancel:(id)sender {
    [self.delegate cancelAddingComment:self];
}

-(IBAction)postComment:(id)sender {
    NSString *comment = [textView text];
    
    PFObject *commentObject = [PFObject objectWithClassName:@"Comment"];
    [commentObject setValue:comment forKey:@"text"]; // Set comment text
    [commentObject setValue:[PFUser currentUser] forKey:@"user"]; // Set who commented
    [commentObject setValue:bukkit forKey:@"bukkit"]; // Set bukkit
    
    [commentObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.delegate addComment:self toBukkit:bukkit];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
