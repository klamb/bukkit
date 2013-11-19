//
//  BukkitViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CommentViewController.h"

@protocol BukkitViewDelegate <NSObject>

@end

@interface BukkitViewController : UIViewController <UITextViewDelegate, CommentViewDelegate>

@property(nonatomic, assign) id <BukkitViewDelegate> delegate;
@property(nonatomic, assign) PFObject *bukkit;

@property (weak, nonatomic) IBOutlet UILabel *titleBukkit;
@property (weak, nonatomic) IBOutlet UILabel *numberOfDiddit;
@property (weak, nonatomic) IBOutlet UILabel *numberOfBukkit;
@property (weak, nonatomic) IBOutlet UIButton *bukkitButton;
@property (weak, nonatomic) IBOutlet UIButton *didditButton;
@property (strong, nonatomic) IBOutlet UIButton *didditTabButton;
@property (strong, nonatomic) IBOutlet UIButton *bukkitTabButton;
@property (strong, nonatomic) IBOutlet UIButton *commentTabButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *commentsView;

-(IBAction)didTapBukkitButton:(id)sender;
-(IBAction)didTapDidditButton:(id)sender;

- (IBAction)didTapDidditTabButtonAction:(UIButton *)sender;
- (IBAction)didTapCommentTabButtonAction:(UIButton *)sender;
- (IBAction)didTapBukkitTabButtonAction:(UIButton *)sender;

@end
