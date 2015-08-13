#import <UIKit/UIKit.h>
@class Tag, Artist;

@interface APINetworkModel : NSObject

- (void)getLatestTags:(void (^)(NSArray *tags))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

- (void)getGramsforTag:(Tag *)tag :(void (^)(NSArray *grams, NSString *nextAddress))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

- (void)getFreshGrams:(void (^)(NSArray *grams, NSString *nextAddress))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;


- (void)getGramsforAddress:(NSString *)address :(void (^)(NSArray *grams, NSString *nextAddress))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

- (void)getArtistDetailsForArtistURL:(NSString *)artistAddress :(void (^)(Artist *artist))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end
