#import "AppViewController.h"

@interface AppViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation AppViewController

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
