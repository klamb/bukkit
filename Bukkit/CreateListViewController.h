//
//  CreateListViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 12/8/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateListDelegate;

@interface CreateListViewController : UIViewController <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property(nonatomic, assign) id <CreateListDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createButton;
@property (weak, nonatomic) IBOutlet UIButton *imageViewButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) UIImage *listImage;

-(IBAction)cancel:(id)sender;
-(IBAction)createList:(id)sender;
-(IBAction)addImageToList:(id)sender;

@end


@protocol CreateListDelegate <NSObject>

- (void)cancel:(CreateListViewController *)createListViewController;
- (void)createNewList:(id)sender;

@end
