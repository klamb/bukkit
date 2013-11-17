//
//  CommentViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 11/17/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "ViewController.h"

@protocol CommentViewDelegate;

@interface CommentViewController : ViewController

@property(nonatomic, assign) id <CommentViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

-(IBAction)cancel:(id)sender;

@end

@protocol CommentViewDelegate <NSObject>

- (void)cancelAddingComment:(CommentViewController *)addCommentViewController;
-(IBAction)addComment:(id)sender;

@end
