#import "ARInstagramFeedViewController.h"
#import "APINetworkModel.h"
#import "ARGramTableViewCell.h"
#import <APLArrayDataSource/APLArrayDataSource.h>
#import "Gram.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIKit+AFNetworking.h>

@interface ARInstagramFeedViewController ()
@property (strong) APINetworkModel *network;
@property (strong) APLArrayDataSource *dataSource;
@end

@implementation ARInstagramFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _network = [[APINetworkModel alloc] init];

    
    _dataSource = [[APLArrayDataSource alloc] initWithItems:@[] cellIdentifier:@"gram" configureCellBlock:^(ARGramTableViewCell *cell, Gram *gram) {
       
        cell.gramTitleLabel.text = gram.title;
        
        NSURL *previewURL = [NSURL URLWithString:gram.instagramImageAddress];
        [cell.gramPreviewImage setImageWithURL:previewURL];
        
        NSURL *avatarURL = [NSURL URLWithString:gram.instagramAvatarAddress];
        [cell.gramAuthorPreviewImage setImageWithURL:avatarURL];
    }];
    self.tableView.dataSource = _dataSource;
    
    [_network getLatestGrams:^(NSArray *grams) {
        _dataSource.items = grams;
        [self.tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failed");
    }];
}

//    ARGramTableViewCell *cell = (id) [tableView dequeueReusableCellWithIdentifier:@"gram"];


@end
