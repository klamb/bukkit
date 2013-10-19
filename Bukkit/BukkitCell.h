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

@interface BukkitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UIButton *didditButton;
@property (weak, nonatomic) IBOutlet UIButton *bukkitButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) PFObject *bukkit;
@property (nonatomic,weak) id <BukkitDelegate> delegate;

@end


@protocol BukkitDelegate <NSObject>
@required
-(void)bukkitCell:(BukkitCell *)bukkitCell didTapDiddit:(UIButton *)button;
-(void)bukkitCell:(BukkitCell *)bukkitCell didTapBukkit:(UIButton *)button;
-(void)bukkitCell:(BukkitCell *)bukkitCell didTapComment:(UIButton *)button;


@end