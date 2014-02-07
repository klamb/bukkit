//
//  WebViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 1/30/14.
//  Copyright (c) 2014 Kevin Lamb. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    self.navigationItem.title = @"Terms and Conditions";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dimissWebView)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIWebView *webview =[[UIWebView alloc] initWithFrame:self.view.frame];
    NSString *url = @"http://www.bukkitapp.com/terms-conditions/";
    NSURL *nsurl = [NSURL URLWithString:url];
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:nsurl];
    [webview loadRequest:nsrequest];
    [self.view addSubview:webview];
}

-(void)dimissWebView {
    [self.delegate back];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
