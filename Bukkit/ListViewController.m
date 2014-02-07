//
//  ListViewController.m
//  Bukkit
//
//  Created by Kevin Lamb on 12/8/13.
//  Copyright (c) 2013 Kevin Lamb. All rights reserved.
//

#import "ListViewController.h"
#import "MainViewController.h"
#import "ListCell.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface ListViewController ()

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"bukkitlist";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 100;
    }
    
    return self;
}


- (PFQuery *)queryForTable {
    
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFRelation *lists = [[self.delegate getProfile] relationforKey:@"lists"];
    
    PFQuery *queryBukkitList = [lists query];
    
    queryBukkitList.limit = 100;
    
    return queryBukkitList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView sizeToFit];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = RGB(230, 230, 230);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
}

-(CGFloat)getTableViewHeight {
    [self.tableView layoutIfNeeded];
    return [self.tableView contentSize].height;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = RGB(230, 230, 230);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    if (indexPath.row >= self.objects.count && [[self.delegate getProfile].objectId isEqualToString:[PFUser currentUser].objectId]) {
        static NSString *CellIdentifier = @"addlistcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"Create New List";
        
        return cell;
    }
    
    ListCell *cell = (ListCell *)[tableView dequeueReusableCellWithIdentifier:@"listcell"];
    if (cell == nil) {
        cell = [[ListCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                 reuseIdentifier:@"listcell"];
    }
    
    cell.listTitle.text = [object objectForKey:@"name"];
    // cell.listSubtitle.text = @"The Official Bukkit List";
    
    PFFile *listImageFile = [object objectForKey:@"Image"];
    [listImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.listImageView.image = [UIImage imageWithData:imageData];
        }
    }];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row >= self.objects.count) {
        CreateListViewController *createListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateListViewController"];
        createListViewController.delegate = self;
        UINavigationController *createListNavController = [[UINavigationController alloc] initWithRootViewController:createListViewController];
        
        [self presentViewController:createListNavController animated:YES completion:nil];
    } else {
        MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        mainViewController.list = [self.objects objectAtIndex:indexPath.row];
        mainViewController.pushedView = YES;
        [self.navigationController pushViewController:mainViewController animated:YES];
    }
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.objects.count) {
        return nil;
    } else {
        return [super objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    }
}

#pragma mark - CreateListDelegate Methods

- (void)cancel:(CreateListViewController *)createListViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createNewList:(id)sender {
    [self loadObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
