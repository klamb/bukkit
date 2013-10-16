//
//  TopRatedViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/11/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol AddItemDelegate;


@interface AddItemViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, assign) id <AddItemDelegate> delegate;
@property (weak, nonatomic) PFObject *bukkitList;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

@end

@protocol AddItemDelegate <NSObject>

- (void)cancelAddingItem:(AddItemViewController *)addItemController;
-(IBAction)addItem:(id)sender;

@end
