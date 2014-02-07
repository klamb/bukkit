//
//  UserActivityViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 11/5/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "UserActivityViewController.h"
#import "BukkitCell.h"
#import "AppDelegate.h"

@interface UserActivityViewController ()

@end

@implementation UserActivityViewController

@synthesize query;

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"bukkit";
        
        self.textKey = @"title";
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] resetNavigationBar:self.navigationController.navigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (PFQuery *)queryForTable {
    
    if (![PFUser currentUser]) {
        PFQuery *noUserQuery = [PFQuery queryWithClassName:self.parseClassName];
        [noUserQuery setLimit:0];
        return noUserQuery;
    }
    
    return query;
}

/*

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = self.objects.count;
    if (self.paginationEnabled)
        sections = sections + 1;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0f;
    }
    return 8.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section > self.objects.count) {
        return 0.0f;
    }
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > self.objects.count) {
        return 50.0f;   // Load More Section
    } else if (indexPath.section == 0) {
        return 30.0f;   // Segmented Control Section
    } else {
        return 175.0f;
    }
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    BukkitCell *cell = (BukkitCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BukkitCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:CellIdentifier];
    }
    
    // cell.delegate = self;
    cell.title.text = [object objectForKey:@"title"];
    cell.item = object;
    
    //[self checkForUserActivity:object forButton:cell.didditButton];
    // [self checkForUserActivity:object forButton:cell.bukkitButton];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
