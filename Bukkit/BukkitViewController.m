//
//  BukkitViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "BukkitViewController.h"
#import "ProfileViewController.h"
#import "ActivityViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface BukkitViewController ()

@end

@implementation BukkitViewController

@synthesize delegate, numberOfBukkit, numberOfDiddit, titleBukkit, bukkit, imageView, bukkitButton, didditButton, bukkitTabButton, didditTabButton, commentTabButton, commentsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)awakeFromNib {
    [self setButton:self.commentTabButton];
    [self setButton:self.didditTabButton];
    [self setButton:self.bukkitTabButton];
}


-(void)setButton:(UIButton *)button {
    button.adjustsImageWhenHighlighted = NO;
    [button setSelected:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self checkForUserActivity:bukkit forButton:self.didditTabButton];
    [self checkForUserActivity:bukkit forButton:self.bukkitTabButton];
    
    commentsView.delegate = self;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
    [commentsView addGestureRecognizer:tapRecognizer];
    
    titleBukkit.text = [bukkit objectForKey:@"title"];
    
    [bukkitButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
    [didditButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0)];
    
    PFUser *creator = [bukkit objectForKey:@"createdBy"];
    if ([creator.objectId isEqualToString:[PFUser currentUser].objectId]) {
        UIBarButtonItem *deleteButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteItem:)];
        deleteButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = deleteButtonItem;
    }
    
    
    PFFile *userImageFile = [bukkit objectForKey:@"Image"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            [imageView setImage:image];
        }
    }];
    
    
    PFRelation *relationOfBukkitUsers = [bukkit relationforKey:@"bukkit"];
    [[relationOfBukkitUsers query] countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            if (count == 0) {
                [bukkitButton setTitle:@"Be the first" forState:UIControlStateNormal];
            } else if (count == 1){
                [bukkitButton setTitle:[NSString stringWithFormat:@"%i Person", count] forState:UIControlStateNormal];
            } else {
                [bukkitButton setTitle:[NSString stringWithFormat:@"%i People", count] forState:UIControlStateNormal];
            }
        }
    }];
    
    
    PFRelation *relationOfDidditUsers = [bukkit relationforKey:@"diddit"];
    [[relationOfDidditUsers query] countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if(!error) {
            if (count == 0) {
                [didditButton setTitle:@"Be the first" forState:UIControlStateNormal];
            } else if (count == 1){
                [didditButton setTitle:[NSString stringWithFormat:@"%i Person", count] forState:UIControlStateNormal];
            } else {
                [didditButton setTitle:[NSString stringWithFormat:@"%i People", count] forState:UIControlStateNormal];
            }
        }
    }];
    
    [self getComments];
    
}

-(void)getComments {
    PFQuery *commentsQuery = [PFQuery queryWithClassName:@"Comment"];
    [commentsQuery whereKey:@"bukkit" equalTo:self.bukkit];
    [commentsQuery includeKey:@"user"];
    
    [commentsQuery findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (!error) {
            NSMutableAttributedString *allCommentsText = [[NSMutableAttributedString alloc] init];
            // Do something with the found objects
            for (PFObject *comment in comments) {
                NSMutableAttributedString *commentText = [self formatString:comment];
                [allCommentsText appendAttributedString:commentText];
                
            }
            commentsView.attributedText = allCommentsText;
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(NSMutableAttributedString *)formatString:(PFObject *) comment {
    PFUser *user = [comment objectForKey:@"user"];
    NSString *userNameText = [[comment objectForKey:@"user"] objectForKey:@"name"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:userNameText attributes:@{ @"isClickableUser" : @(YES), @"user" : user }];
    
    NSString *commentString = [NSString stringWithFormat:@": %@ \n", [comment objectForKey:@"text"]];
    
    NSAttributedString *commentAttrText = [[NSAttributedString alloc] initWithString:commentString];
    [attributedString appendAttributedString:commentAttrText];
    // NSString *userAndCommentString = [NSString stringWithFormat:@"%@: %@ \n", userNameText, commentText];
    
    const CGFloat fontSize = 13;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    
    NSMutableAttributedString *userAndCommentArrString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    [userAndCommentArrString addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0, userNameText.length+1)];
    [userAndCommentArrString addAttribute:NSForegroundColorAttributeName value:RGB(34, 158, 245) range:NSMakeRange(0, userNameText.length)];
    
    return userAndCommentArrString;
}

- (void)textTapped:(UITapGestureRecognizer *)recognizer {
    
    UITextView *textView = (UITextView *)recognizer.view;
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    
    // NSLog(@"%@", [textView.textStorage attributedSubstringFromRange:NSMakeRange(characterIndex, 1)]);
    
    if (characterIndex < textView.textStorage.length) {
        
        NSRange range;
        id value = [textView.textStorage attribute:@"isClickableUser" atIndex:characterIndex effectiveRange:&range];
        
        if (value) {
            NSLog(@"%@, %d, %d", value, range.location, range.length);
            PFUser *user = (PFUser *)[textView.textStorage attribute:@"user" atIndex:characterIndex effectiveRange:&range];
            ProfileViewController *profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
            profileViewController.profile = user;
            profileViewController.pushedView = YES;
            [self.navigationController pushViewController:profileViewController animated:YES];
        }
        else {
            NSLog(@"Nope");
        }
        
    }
    
}

-(void)checkForUserActivity:(PFObject *)object forButton:(UIButton *)button {
    PFRelation *relation = [object relationforKey:button.titleLabel.text.lowercaseString];
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            for (PFObject *user in objects) {
                if ([user.objectId isEqual:[PFUser currentUser].objectId]) {
                    [button setSelected:YES];
                }
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

-(IBAction)didTapBukkitButton:(id)sender {
    ActivityViewController *activityViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
    activityViewController.showDidditUsers = NO;
    activityViewController.selectedBukkit = bukkit;
    [self.navigationController pushViewController:activityViewController animated:YES];
}

-(IBAction)didTapDidditButton:(id)sender {
    ActivityViewController *activityViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
    activityViewController.showDidditUsers = YES;
    activityViewController.selectedBukkit = bukkit;
    [self.navigationController pushViewController:activityViewController animated:YES];
}


- (IBAction)didTapDidditTabButtonAction:(UIButton *)sender {
    if(self.didditTabButton.selected) {
        [self.didditTabButton setSelected:NO];
    }
    else {
        [self.didditTabButton setSelected:YES];
        if (self.bukkitTabButton.selected) {
            [self.bukkitTabButton setSelected:NO];
        }
    }
    
    [self.delegate updateBukkitCell:bukkit fromButton:sender];
    
    /*
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [self.bukkit relationforKey:@"diddit"];
    [[relation query] getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            [relation addObject:user];
            [bukkit incrementKey:@"ranking"];
            [bukkit saveInBackground];
            
            PFRelation *relationForUser = [user relationforKey:@"diddit"];
            [relationForUser addObject:bukkit];
            [user incrementKey:@"didditRanking"];
            [user saveInBackground];
        } else {
            [relation removeObject:user];
            [bukkit incrementKey:@"ranking" byAmount:[NSNumber numberWithInt:-1]];
            [bukkit saveInBackground];
            
            PFRelation *relationForUser = [user relationforKey:@"diddit"];
            [relationForUser removeObject:bukkit];
            [user incrementKey:@"didditRanking" byAmount:[NSNumber numberWithInt:-1]];
            [user saveInBackground];
        }
    }];
     */
}

- (IBAction)didTapCommentTabButtonAction:(UIButton *)sender {
    if(self.commentTabButton.selected) {
        [self.commentTabButton setSelected:NO];
    }
    else {
        [self.commentTabButton setSelected:YES];
    }
    
    CommentViewController *addCommentViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    addCommentViewController.delegate = self;
    addCommentViewController.bukkit = self.bukkit;
    addCommentViewController.mainListComment = NO;
    UINavigationController *commentNavController = [[UINavigationController alloc] initWithRootViewController:addCommentViewController];
    
    [self presentViewController:commentNavController animated:YES completion:nil];
}

- (IBAction)didTapBukkitTabButtonAction:(UIButton *)sender {
    if(self.bukkitTabButton.selected) {
        [self.bukkitTabButton setSelected:NO];
    }
    else {
        [self.bukkitTabButton setSelected:YES];
        if (self.didditTabButton.selected) {
            [self.didditTabButton setSelected:NO];
        }
    }
    
    [self.delegate updateBukkitCell:bukkit fromButton:sender];
    
    /*
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [bukkit relationforKey:@"bukkit"];
    [[relation query] getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            [relation addObject:user];
            [bukkit incrementKey:@"ranking"];
            [bukkit saveInBackground];
            
            PFRelation *relationForUser = [user relationforKey:@"bukkit"];
            [relationForUser addObject:bukkit];
            [user saveInBackground];
        } else {
            [relation removeObject:user];
            [bukkit incrementKey:@"ranking" byAmount:[NSNumber numberWithInt:-1]];
            [bukkit saveInBackground];
            
            PFRelation *relationForUser = [user relationforKey:@"bukkit"];
            [relationForUser removeObject:bukkit];
            [user saveInBackground];
        }
    }];
     */
}


-(void)deleteItem:(id)sender {
    [self.bukkit deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.delegate deletedItem];
    }];
}

-(IBAction)reportContentAction:(UIButton *)sender {
    UIAlertView *reportMessage = [[UIAlertView alloc] initWithTitle:@"Report Content"
                                                            message:@"Do you think this item is against the terms and conditions of Bukkit?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Report"
                                                  otherButtonTitles:@"Cancel", nil];
    [reportMessage show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        PFObject *flaggedContent = [PFObject objectWithClassName:@"FlaggedContent"];
        flaggedContent[@"reporter"] = [PFUser currentUser];
        flaggedContent[@"flaggedItem"] = self.bukkit;
        [flaggedContent saveInBackground];
        
        UIAlertView *reportMessage = [[UIAlertView alloc] initWithTitle:@"Report Content"
                                                                message:@"Your file was reported"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
        [reportMessage show];
    }
}

#pragma mark - CommentViewDelegate Methods

- (void)cancelAddingComment:(CommentViewController *)addCommentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addComment:(id)sender toBukkit:(PFObject *)bukkit {
    [self getComments];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
