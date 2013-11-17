//
//  TopRatedViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/11/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "GKImagePicker.h"

@protocol AddItemDelegate;


@interface AddItemViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, assign) id <AddItemDelegate> delegate;
@property (weak, nonatomic) PFObject *bukkitList;
@property (strong, nonatomic) UIImage *takenImage;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadPhotoButton;

-(IBAction)didTapUploadPhotoButton:(id)sender;

@end

@protocol AddItemDelegate <NSObject>

- (void)cancelAddingItem:(AddItemViewController *)addItemController;
-(IBAction)addItem:(id)sender;

-(void)showUIPickerView:(AddItemViewController *)addItemController;

@end
