#import "AppViewController.h"
#import <UIView+BooleanAnimations/UIView+BooleanAnimations.h>
#import "ARScrollNavigationChief.h"

static void *ARNavigationControllerScrollingChiefContext = &ARNavigationControllerScrollingChiefContext;

@interface AppViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftSearchConstraint;

@end

@implementation AppViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    sharedInstance = self;

    [ARScrollNavigationChief.chief addObserver:self forKeyPath:@"allowsMenuButtons" options:NSKeyValueObservingOptionNew context:ARNavigationControllerScrollingChiefContext];

}

static AppViewController *sharedInstance;

+ (instancetype)sharedInstance
{
    return sharedInstance;
}

- (void)showNav:(BOOL)show animated:(BOOL)animates
{
    [UIView animateIf:animates duration:0.15 :^{
        self.backButton.alpha = show;
        self.searchBar.alpha = show;
    }];
}

- (void)showBackButton:(BOOL)show animated:(BOOL)animates
{
    [UIView animateIf:animates duration:0.15 :^{
        CGFloat x = -40 - (show * 28);
        self.leftSearchConstraint.constant = x;
        self.backButton.alpha = show;
        [self.view layoutSubviews];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    if (context == ARNavigationControllerScrollingChiefContext) {
        // All hail the chief
        ARScrollNavigationChief *chief = object;
        [self showNav:chief.allowsMenuButtons animated:YES];

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (IBAction)tappedBackButton:(id)sender
{
    for (id controller in self.childViewControllers) {
        if ([controller isKindOfClass:UINavigationController.class]) {
            
            UINavigationController *nav = controller;
            if (nav.viewControllers.count) {
                [nav popViewControllerAnimated:YES];
            }
        }
    }
}

@end
