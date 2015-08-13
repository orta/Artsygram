#import <UIKit/UIKit.h>

@interface AppViewController : UIViewController

+ (instancetype)sharedInstance;

- (void)showBackButton:(BOOL)show animated:(BOOL)animates;
- (void)showNav:(BOOL)show animated:(BOOL)animates;

@end
