#import "ARTagsViewController.h"
#import "AppViewController.h"
#import "ARTagArtistFeedViewController.h"
#import <APLArrayDataSource/APLArrayDataSource.h>
#import "APINetworkModel.h"
#import "Tag.h"
#import "ARScrollNavigationChief.h"

@interface ARTagsViewController()
@property (strong) Tag *selectedTag;
@property (strong) APINetworkModel *network;
@property (strong) APLArrayDataSource *dataSource;
@end

@implementation ARTagsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // Clear the tag button labels so they don't flash before the data loads
    for( UIButton* tagButton in _trendingTags ) {
        [tagButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    _network = [[APINetworkModel alloc] init];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"tag"];
    _dataSource = [[APLArrayDataSource alloc] initWithItems:@[] cellIdentifier:@"tag" configureCellBlock:^(UITableViewCell *cell, Tag *tag) {
        cell.textLabel.text = tag.name;
    }];
    
    self.tableView.dataSource = _dataSource;
    
    [_network getLatestTags:^(NSArray *tags) {
        _dataSource.items = tags;
        [self.tableView reloadData];
        
        int index = 0; // hacky
        for( UIButton* tagButton in _trendingTags ) {
            [tagButton setTitle:[NSString stringWithFormat:@"#%@",[tags[index] name]] forState:UIControlStateNormal];
            [tagButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
            tagButton.tag = index;
            index++;
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failed");
    }];
}

- (void)buttonPressed:(UIButton *)button
{    
    _selectedTag = [self.dataSource.items objectAtIndex:button.tag];
    [self performSegueWithIdentifier:@"show_tag" sender:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedTag = [self.dataSource itemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"show_tag" sender:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AppViewController sharedInstance] showBackButton:NO animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[AppViewController sharedInstance] showBackButton:YES animated:YES];

    if ([segue.identifier isEqualToString:@"show_tag"]) {
        ARTagArtistFeedViewController *artistVC = segue.destinationViewController;
        artistVC.tag = self.selectedTag;
        artistVC.network = self.network;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [ARScrollNavigationChief.chief scrollViewDidScroll:scrollView];
}




@end
