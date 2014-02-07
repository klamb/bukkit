//
//  PickerViewCell.h
//  Bukkit
//
//  Created by Kevin Lamb on 12/18/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewCellDelegate;

@interface PickerViewCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id<PickerViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIPickerView *schoolPickerView;

@property (strong, nonatomic) NSArray *schoolList;

@end

@protocol PickerViewCellDelegate <NSObject>
@required
-(void)updateChosenSchool:(NSString *)school;
-(void)selectItem;

@end
