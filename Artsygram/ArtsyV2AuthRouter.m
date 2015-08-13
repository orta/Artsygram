#import "ArtsyV2AuthRouter.h"
#import <NSURL+QueryDictionary/NSURL+QueryDictionary.h>

@implementation ArtsyV2AuthRouter

- (NSURLRequest *)requestForXapp
{
    NSDictionary *params = @{ @"client_id" : self.clientID, @"client_secret" : self.clientSecret };
    NSURL *url = [NSURL URLWithString:@"https://api.artsy.net/api/tokens/xapp_token"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[url uq_URLByAppendingQueryDictionary:params]];
    req.HTTPMethod = @"POST";
    return req;
}

@end
