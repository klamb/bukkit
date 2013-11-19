//
//  BukkitViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 10/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "BukkitViewController.h"
#import "ActivityViewController.h"

@interface BukkitViewController ()

@end

@implementation BukkitViewController

@synthesize numberOfBukkit, numberOfDiddit, titleBukkit, bukkit, imageView, bukkitButton, didditButton, bukkitTabButton, didditTabButton, commentTabButton, commentsView;

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
    
    titleBukkit.text = [bukkit objectForKey:@"title"];
    
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
                numberOfBukkit.text = @"Be first to Bukkit";
            } else if (count == 1){
                numberOfBukkit.text = [NSString stringWithFormat:@"%i Person", count];
            } else {
                numberOfBukkit.text = [NSString stringWithFormat:@"%i People", count];
            }
        } else {
            // The request failed
        }
    }];
    
    
    PFRelation *relationOfDidditUsers = [bukkit relationforKey:@"diddit"];
    [[relationOfDidditUsers query] countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if(!error) {
            if (number == 0) {
                numberOfDiddit.text = @"Be first to Diddit";
            } else if (number == 1){
                numberOfDiddit.text = [NSString stringWithFormat:@"%i Person", number];
            } else {
                numberOfDiddit.text = [NSString stringWithFormat:@"%i People", number];
            }

        } else {
            
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
    
    NSString *userNameText = [[comment objectForKey:@"user"] objectForKey:@"username"];
    NSString *commentText = [comment objectForKey:@"text"];
    NSString *userAndCommentString = [NSString stringWithFormat:@"%@: %@ \n", userNameText, commentText];
    
    const CGFloat fontSize = 12;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    
    NSMutableAttributedString *userAndCommentArrString = [[NSMutableAttributedString alloc] initWithString:userAndCommentString];
    [userAndCommentArrString addAttribute:NSFontAttributeName value:boldFont range:NSMakeRange(0, userNameText.length+1)];
    
    return userAndCommentArrString;
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
    }
    
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
    UINavigationController *commentNavController = [[UINavigationController alloc] initWithRootViewController:addCommentViewController];
    
    [self presentViewController:commentNavController animated:YES completion:nil];
}

- (IBAction)didTapBukkitTabButtonAction:(UIButton *)sender {
    if(self.bukkitTabButton.selected) {
        [self.bukkitTabButton setSelected:NO];
    }
    else {
        [self.bukkitTabButton setSelected:YES];
    }
    
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
}

#pragma mark - CommentViewDelegate Methods

- (void)cancelAddingComment:(CommentViewController *)addCommentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addComment:(id)sender {
    [self getComments];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
