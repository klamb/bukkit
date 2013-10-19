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

@synthesize cancelButton, titleField, bukkitList, delegate;

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
}


-(IBAction)cancel:(id)sender {
    [self.delegate cancelAddingItem:self];
}

-(IBAction)addItem:(id)sender {
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"bukkitlist"];
    [query whereKey:@"name" equalTo:[[PFUser currentUser] objectForKey:@"school" ]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            
            if (objects.count == 0) {

            } else {
                for (PFObject *bukkitlist in objects) {
                    PFObject *bukkit = [PFObject objectWithClassName:@"bukkit"];
                    [bukkit setObject:[NSNumber numberWithInt:0] forKey:@"ranking"];
                    [bukkit setObject:titleField.text forKey:@"title"];
                    [bukkit setObject:bukkitlist forKey:@"list"];
                    [self linkImageWithBukkit:bukkit];
                }
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    [self.delegate addItem:self];
}

-(void)linkImageWithBukkit:(PFObject *)bukkit {
    UIImage *image = [UIImage imageNamed:@"hong-kong.png"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.png" data:imageData];
    
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [bukkit setObject:imageFile forKey:@"Image"];
            [bukkit saveInBackground];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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
