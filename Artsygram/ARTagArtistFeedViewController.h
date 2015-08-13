#import <UIKit/UIKit.h>

@class Tag, APINetworkModel;

@interface ARTagArtistFeedViewController : UITableViewController

@property (nonatomic, strong) Tag *tag;
@property (nonatomic, strong) APINetworkModel *network;

@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLocationAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistFollowerCountLabel;


@end
