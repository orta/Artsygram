#import "ARGramTableViewCell.h"
#import "Gram.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@interface ARGramTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *gramPreviewImage;
@property (weak, nonatomic) IBOutlet UIImageView *gramAuthorPreviewImage;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@end

@implementation ARGramTableViewCell



- (void)setGram:(Gram *)gram
{
    NSURL *previewURL = [NSURL URLWithString:gram.instagramImageAddress];
    self.gramPreviewImage.image = nil;
    [self.gramPreviewImage setImageWithURL:previewURL];

    NSURL *avatarURL = [NSURL URLWithString:gram.instagramAvatarAddress];
    self.gramAuthorPreviewImage.image = nil;
    [self.gramAuthorPreviewImage setImageWithURL:avatarURL];

    self.commentsLabel.text = [NSString stringWithFormat:@"%@ comments", @(gram.commentCount)];
    self.likesLabel.text = [NSString stringWithFormat:@"%@ like", @(gram.heartCount)];
    _gram = gram;
}

@end
