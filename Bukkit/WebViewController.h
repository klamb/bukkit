//
//  WebViewController.h
//  Bukkit
//
//  Created by Kevin Lamb on 1/30/14.
//  Copyright (c) 2014 Kevin Lamb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebViewDelegate;

@interface WebViewController : UIViewController

@property(nonatomic, assign) id <WebViewDelegate> delegate;

@end

@protocol WebViewDelegate <NSObject>

- (void)back;

@end
