#import "ARTagArtistFeedViewController.h"
#import "APINetworkModel.h"
#import "ARGramTableViewCell.h"
#import <APLArrayDataSource/APLArrayDataSource.h>
#import <AFNetworking/UIKit+AFNetworking.h>
#import "Gram.h"
#import "Tag.h"
#import <AFWebViewController/AFWebViewController.h>

@interface ARTagArtistFeedViewController ()
@property (strong) APLArrayDataSource *dataSource;
@property (copy) NSString *selectedInstagramID;
@end

@implementation ARTagArtistFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 440;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _dataSource = [[APLArrayDataSource alloc] initWithItems:@[] cellIdentifier:@"gram" configureCellBlock:^(ARGramTableViewCell *cell, Gram *gram) {
       
        cell.gramTitleLabel.text = gram.title;
        
        NSURL *previewURL = [NSURL URLWithString:gram.instagramImageAddress];
        cell.gramPreviewImage.image = nil;
        [cell.gramPreviewImage setImageWithURL:previewURL];
        
        NSURL *avatarURL = [NSURL URLWithString:gram.instagramAvatarAddress];
        cell.gramAuthorPreviewImage.image = nil;
        [cell.gramAuthorPreviewImage setImageWithURL:avatarURL];
    }];
    self.tableView.dataSource = _dataSource;
    
    [self.network getGramsforTag:self.tag :^(NSArray *grams) {
        _dataSource.items = grams;
        [self.tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failed");
    }];

    [self.network getArtistDetailsForArtistURL:self.tag.artistAddress :^(id artist) {
        self.artistNameLabel.text = artist[@"name"];
        self.artistLocationAgeLabel = artist[@"hometown"];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Gram *gram = [self.dataSource itemAtIndexPath:indexPath];
    AFWebViewController *controller = [[AFWebViewController alloc] initWithAddress:gram.instagramAddress];
    [self.navigationController pushViewController:controller animated:YES];
}

- (APINetworkModel *)network
{
    return _network ?: [[APINetworkModel alloc] init];
}

@end
