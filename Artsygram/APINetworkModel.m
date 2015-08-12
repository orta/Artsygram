#import "APINetworkModel.h"
#import "Gram.h"

@interface APINetworkModel ()

@end

@implementation APINetworkModel

- (void)getLatestGrams:(void (^)(NSArray *grams))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    success(@[ [Gram stubbedGram]]);
    return;
}

@end