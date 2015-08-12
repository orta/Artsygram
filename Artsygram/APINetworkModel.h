#import <UIKit/UIKit.h>

@interface APINetworkModel : NSObject

- (void)getLatestGrams:(void (^)(NSArray *grams))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end
