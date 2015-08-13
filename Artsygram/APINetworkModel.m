#import "APINetworkModel.h"
#import <AFNetworking/AFNetworking.h>
#import <ObjectiveSugar/ObjectiveSugar.h>
#import <Artsy+Authentication/Artsy+Authentication.h>
#import "Gram.h"
#import "Tag.h"

@interface APINetworkModel ()
@property (strong) ArtsyAuthentication *auth;
@property (strong) ArtsyToken *token;

@end

@implementation APINetworkModel

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

//    https://github.com/artsy/eigen/blob/master/Makefile#L41
    _auth = [[ArtsyAuthentication alloc] initWithClientID:@"3a33d2085cbd1176153f99781bbce7c6" clientSecret:@"e750db60ac506978fc70"];
    [_auth getWeekLongXAppTrialToken:^(ArtsyToken *token, NSError *error) {
        _token = token;
    }];

    return self;
}

- (void)getGramsforTag:(Tag *)tag :(void (^)(NSArray *grams))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *address = [NSString stringWithFormat:@"https://gramophone-production.herokuapp.com/api/grams?tag=%@", tag.name];
    [manager GET:address parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *json) {
        
        NSArray *grams = json[@"_embedded"][@"grams"];
        success([grams map:^id(NSDictionary *dict) {
            Gram *gram = [[Gram alloc] init];
            gram.instagramAddress = dict[@"data"][@"link"];
            gram.instagramImageAddress = dict[@"data"][@"images"][@"standard_resolution"][@"url"];
            gram.instagramAvatarAddress = dict[@"data"][@"user"][@"profile_picture"];
            return gram;
        }]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(operation.request, operation.response, error, operation.responseObject);
    }];

    return;
}

- (void)getLatestTags:(void (^)(NSArray *tags))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://gramophone-production.herokuapp.com/api/tags.json" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *json) {

        NSArray *tags = json[@"_embedded"][@"tags"];
        success([tags map:^id(NSDictionary *dict) {
            Tag *tag = [[Tag alloc] init];
            tag.name = dict[@"name"];
            tag.slug = dict[@"id"];
            tag.artistAddress = dict[@"_links"][@"artist"][@"href"];
            return tag;
        }]);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(operation.request, operation.response, error, operation.responseObject);
    }];
}

- (void)getArtistDetailsForArtistURL:(NSString *)artistAddress :(void (^)(Artist *artist))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:artistAddress parameters:@{ @"X-Xapp-Token": self.token.token } success:^(AFHTTPRequestOperation *operation, NSDictionary *json) {
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(operation.request, operation.response, error, operation.responseObject);
    }];

}

@end