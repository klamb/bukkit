//
//  CommentViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 11/17/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <Parse/Parse.h>

@protocol CommentViewDelegate;

@interface CommentViewController : UIViewController <UITextViewDelegate>

@property(nonatomic, assign) id <CommentViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) PFObject *bukkit;

-(IBAction)cancel:(id)sender;
-(IBAction)postComment:(id)sender;

@end

@protocol CommentViewDelegate <NSObject>

- (void)cancelAddingComment:(CommentViewController *)addCommentViewController;
- (void)addComment:(id)sender;

@end
