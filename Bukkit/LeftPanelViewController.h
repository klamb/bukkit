//
//  LeftPanelViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 10/1/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LeftPanelViewControllerDelegate <NSObject>

@end

@interface LeftPanelViewController : UIViewController

@property (nonatomic, assign) id<LeftPanelViewControllerDelegate> delegate;
@end
