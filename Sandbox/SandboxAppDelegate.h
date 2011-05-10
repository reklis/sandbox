//
//  SandboxAppDelegate.h
//  Sandbox
//


#import <UIKit/UIKit.h>

#import "PasscodeView.h"
#import "SecureFileBrowser.h"

@interface SandboxAppDelegate : NSObject
<UIApplicationDelegate,PasscodeViewDelegate>
{
@private
    BOOL isDead;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;

@property (nonatomic, retain) IBOutlet UIView* backdrop;
@property (nonatomic, retain) IBOutlet PasscodeView* passcodeView;
@property (nonatomic, retain) IBOutlet SecureFileBrowser* secureFileBrowser;

- (void) initLockdownUI;
- (void) lockApp;
- (void) unlockApp;

@end
