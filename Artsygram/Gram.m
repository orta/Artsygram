#import "Gram.h"

@implementation Gram

+ (instancetype)stubbedGram
{
    Gram *gram = [[Gram alloc] init];
    gram.title = @"HIYA";
    gram.instagramAddress = @"";
    gram.instagramImageAddress = @"https://igcdn-photos-d-a.akamaihd.net/hphotos-ak-xfa1/t51.2885-15/11358050_407159022813203_1491883089_n.jpg";
    gram.instagramAvatarAddress = @"https://igcdn-photos-a-a.akamaihd.net/hphotos-ak-xpf1/t51.2885-19/10261180_1076514945699920_1370902945_a.jpg";
    return gram;
}

@end
