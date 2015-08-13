#import <Foundation/Foundation.h>

@interface Gram : NSObject

@property (copy) NSString *instagramAddress;
@property (strong) NSString *title;
@property (copy) NSString *instagramImageAddress;
@property (copy) NSString *instagramAvatarAddress;

+ (instancetype)stubbedGram;

@end
