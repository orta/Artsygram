#import "APINetworkModel.h"
#import <AFNetworking/AFNetworking.h>
#import <ObjectiveSugar/ObjectiveSugar.h>
#import <Artsy+Authentication/Artsy+Authentication.h>
#import "Gram.h"
#import "Tag.h"
#import <Keys/ArtsyKeys.h>
#import "ArtsyV2AuthRouter.h"

@interface APINetworkModel ()
@property (strong) ArtsyAuthentication *auth;
@property (strong) ArtsyToken *token;
@property (strong) AFHTTPRequestOperationManager *requestManager;

@property (strong) NSString *nextTagURL;
@property (strong) NSString *nextFreshTagURL;

@end

@implementation APINetworkModel

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    _requestManager = [AFHTTPRequestOperationManager manager];

    ArtsyKeys *keys = [[ArtsyKeys alloc] init];
    _auth = [[ArtsyAuthentication alloc] initWithClientID:keys.artsyAPI2ClientKey clientSecret:keys.artsyAPI2ClientSecret];

    // We're using V2 API so need different auth routing
    _auth.router = [[ArtsyV2AuthRouter alloc] initWithClientID:keys.artsyAPI2ClientKey clientSecret:keys.artsyAPI2ClientSecret];

    [_auth getWeekLongXAppTrialToken:^(ArtsyToken *token, NSError *error) {
        if (error) {
            NSLog(@"Error logging in %@", error);
        }
        _token = token;

        [_requestManager.requestSerializer setValue:token.token forHTTPHeaderField:@"X-Xapp-Token"];
    }];

    return self;
}


- (void)getFreshGrams:(void (^)(NSArray *grams, NSString *nextAddress))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    [self getGramsforAddress:@"https://gramophone-production.herokuapp.com/api/grams" :success failure:failure];
}


- (void)getGramsforTag:(Tag *)tag :(void (^)(NSArray *grams, NSString *nextAddress))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    NSString *address = [NSString stringWithFormat:@"https://gramophone-production.herokuapp.com/api/grams?tag=%@", tag.name];
    [self getGramsforAddress:address :success failure:failure];
}

- (void)getGramsforAddress:(NSString *)address :(void (^)(NSArray *grams, NSString *nextAddress))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:address parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *json) {

        NSArray *grams = json[@"_embedded"][@"grams"];
        success([grams map:^id(NSDictionary *dict) {
            Gram *gram = [[Gram alloc] init];
            gram.instagramAddress = dict[@"data"][@"link"];
            gram.instagramImageAddress = dict[@"data"][@"images"][@"standard_resolution"][@"url"];
            gram.instagramAvatarAddress = dict[@"data"][@"user"][@"profile_picture"];
            gram.commentCount = [dict[@"data"][@"comments"][@"count"] integerValue];
            gram.heartCount = [dict[@"data"][@"likes"][@"count"] integerValue];
            return gram;
        }], json[@"_links"][@"next"][@"href"]);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(operation.request, operation.response, error, operation.responseObject);
    }];
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
    [self.requestManager GET:artistAddress parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *json) {
        success(json);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(operation.request, operation.response, error, operation.responseObject);
    }];

}

@end