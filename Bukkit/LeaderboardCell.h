//
//  LeaderboardCell.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/30/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeaderboardCellDelegate;

@interface LeaderboardCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *rankingText;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UIImageView *profilePic;
@property (nonatomic, weak) IBOutlet UIButton *didditPoints;

-(IBAction)didTapDidditButton:(id)sender;
@property (nonatomic,weak) id <LeaderboardCellDelegate> delegate;

@end

@protocol LeaderboardCellDelegate <NSObject>
@required
-(void)bukkitCell:(LeaderboardCell *)bukkitCell didTapDiddit:(UIButton *)button;

@end