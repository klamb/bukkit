//
//  BukkitCell.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/15/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol BukkitDelegate;

@interface BukkitCell : PFTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (strong, nonatomic) IBOutlet UIButton *didditButton;
@property (strong, nonatomic) IBOutlet UIButton *bukkitButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;

@property (weak, nonatomic) PFObject *bukkit;
@property (nonatomic,weak) id <BukkitDelegate> delegate;

- (IBAction)didTapDidditButtonAction:(UIButton *)sender;
- (IBAction)didTapCommentButtonAction:(UIButton *)sender;
- (IBAction)didTapBukkitButtonAction:(UIButton *)sender;

@end


@protocol BukkitDelegate <NSObject>
@required
-(void)bukkitCell:(BukkitCell *)bukkitCell didTapDiddit:(UIButton *)button;
-(void)bukkitCell:(BukkitCell *)bukkitCell didTapBukkit:(UIButton *)button;
-(void)bukkitCell:(BukkitCell *)bukkitCell didTapComment:(UIButton *)button;


@end