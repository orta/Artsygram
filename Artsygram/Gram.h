#import <Foundation/Foundation.h>

@interface Gram : NSObject

@property (copy) NSString *instagramAddress;
@property (strong) NSString *title;
@property (copy) NSString *instagramImageAddress;
@property (copy) NSString *instagramAvatarAddress;
@property (assign) NSInteger commentCount;
@property (assign) NSInteger heartCount;

+ (instancetype)stubbedGram;

@end
