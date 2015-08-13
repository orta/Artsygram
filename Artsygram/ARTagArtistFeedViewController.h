#import <UIKit/UIKit.h>

@class Tag, APINetworkModel;

@interface ARTagArtistFeedViewController : UITableViewController

@property (nonatomic, strong) Tag *tag;
@property (nonatomic, strong) APINetworkModel *network;

@end
