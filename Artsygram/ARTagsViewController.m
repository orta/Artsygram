#import "ARTagsViewController.h"
#import "ARTagArtistFeedViewController.h"
#import <APLArrayDataSource/APLArrayDataSource.h>
#import "APINetworkModel.h"
#import "Tag.h"

@interface ARTagsViewController()
@property (strong) Tag *selectedTag;
@property (strong) APINetworkModel *network;
@property (strong) APLArrayDataSource *dataSource;
@end

@implementation ARTagsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _network = [[APINetworkModel alloc] init];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"tag"];
    _dataSource = [[APLArrayDataSource alloc] initWithItems:@[] cellIdentifier:@"tag" configureCellBlock:^(UITableViewCell *cell, Tag *tag) {
        cell.textLabel.text = tag.name;
    }];
    
    self.tableView.dataSource = _dataSource;
    
    [_network getLatestTags:^(NSArray *tags) {
        _dataSource.items = tags;
        [self.tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failed");
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedTag = [self.dataSource itemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"show_tag" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show_tag"]) {
        ARTagArtistFeedViewController *artistVC = segue.destinationViewController;
        artistVC.tag = self.selectedTag;
    }
}

@end
