#import "ARTagArtistFeedViewController.h"
#import "APINetworkModel.h"
#import "ARGramTableViewCell.h"
#import <APLArrayDataSource/APLArrayDataSource.h>
#import "Gram.h"
#import "Tag.h"
#import <AFWebViewController/AFWebViewController.h>
#import "ARScrollNavigationChief.h"
#import "AppViewController.h"

@interface ARTagArtistFeedViewController ()
@property (strong) APLArrayDataSource *dataSource;
@property (copy) NSString *selectedInstagramID;
@property (weak, nonatomic) IBOutlet UILabel *artistBioLabel;
@property (copy, nonatomic) NSString *nextAddress;
@property (assign, nonatomic) BOOL loading;
@end

@implementation ARTagArtistFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    NSString *searchTitle = [NSString stringWithFormat:@"#%@", self.tag.name];
    [AppViewController sharedInstance].searchQueryLabel.text = searchTitle;

    self.tableView.rowHeight = 400;
    [self.tableView registerNib:[UINib nibWithNibName:@"InstagramCell" bundle:nil] forCellReuseIdentifier:@"gram"];

    self.view.backgroundColor = [UIColor blackColor];
    
    _dataSource = [[APLArrayDataSource alloc] initWithItems:@[] cellIdentifier:@"gram" configureCellBlock:^(ARGramTableViewCell *cell, Gram *gram) {
        cell.gram = gram;
        
        NSInteger index = [self.dataSource.items indexOfObject:gram];
        if (index == _dataSource.items.count - 1) {
            [self loadMore];
        }
    }];
    self.tableView.dataSource = _dataSource;
    
    [self.network getGramsforTag:self.tag :^(NSArray *grams, NSString *next) {
        _dataSource.items = grams;
        self.nextAddress = next;
        [self.tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failed");
    }];

    [self.network getArtistDetailsForArtistURL:self.tag.artistAddress :^(id artist) {
        self.artistNameLabel.text = [artist[@"name"] uppercaseString];
        self.artistLocationAgeLabel.text = [NSString stringWithFormat:@"%@, born %@", artist[@"nationality"], artist[@"birthday"]];

        int followers = arc4random_uniform(9999);
        self.artistFollowerCountLabel.text = [NSString stringWithFormat:@"%@ followers", @(followers)];

        NSString *bio = [NSString stringWithFormat:@"Lorem ipsum dolor sit %@, consectetur adipiscing %@. Donec a %@ lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. ", artist[@"name"], artist[@"nationality"], artist[@"hometown"]];
        self.artistBioLabel.text = bio;


    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

    }];
}

- (void)loadMore
{
    if (self.loading || !self.nextAddress) return;
    self.loading = YES;
    
    [self.network getGramsforAddress:self.nextAddress :^(NSArray *grams, NSString *nextAddress) {
        NSArray *items = [self.dataSource.items arrayByAddingObjectsFromArray:grams];
        self.dataSource.items = items;
        [self.tableView reloadData];
        self.nextAddress = nextAddress;
        self.loading = NO;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        self.loading = NO;

    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Gram *gram = [self.dataSource itemAtIndexPath:indexPath];
    AFWebViewController *controller = [[AFWebViewController alloc] initWithAddress:gram.instagramAddress];
    [self.navigationController pushViewController:controller animated:YES];
    [[AppViewController sharedInstance] showNav:YES animated:YES];
}


- (APINetworkModel *)network
{
    return _network ?: [[APINetworkModel alloc] init];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [ARScrollNavigationChief.chief scrollViewDidScroll:scrollView];
}

@end
