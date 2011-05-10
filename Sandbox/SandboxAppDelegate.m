//
//  SandboxAppDelegate.m
//  Sandbox
//


#import "SandboxAppDelegate.h"

@implementation SandboxAppDelegate


@synthesize window=_window;
@synthesize passcodeView=_passcodeView;
@synthesize backdrop=_backdrop;
@synthesize secureFileBrowser=_secureFileBrowser;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.secureFileBrowser = [[[SecureFileBrowser alloc] initWithNibName:@"SecureFileBrowser" bundle:nil] autorelease];
    
    [self.window makeKeyAndVisible];
    
    [self initLockdownUI];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    if (!isDead) {
        [self lockApp];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    if (!isDead) {
        [self.passcodeView resetView];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_secureFileBrowser release];
    [_backdrop release];
    [_passcodeView release];
    [_window release];
    [super dealloc];
}

#pragma mark PasscodeViewDelegate

- (void) initLockdownUI
{
    CGRect windowBounds = self.window.bounds;
    
    if (nil == self.passcodeView) {
        CGFloat windowWidth = CGRectGetMaxX(windowBounds);
        CGFloat windowHeight = CGRectGetMaxY(windowBounds);
        CGPoint windowCenter = CGPointMake(windowWidth/2., windowHeight/2.);
        
        self.passcodeView = [[[NSBundle mainBundle] loadNibNamed:@"PasscodeView" owner:nil options:nil] objectAtIndex:0];
        self.passcodeView.center = windowCenter;
        self.passcodeView.delegate = self;
    }
    
    if (nil == self.backdrop) {
        UIView* b = [[[UIView alloc] initWithFrame:windowBounds] autorelease];
        b.opaque = YES;
        b.backgroundColor = [UIColor blackColor];
        self.backdrop = b;
    }
}

- (void) deallocLockdownUI
{
    [self.passcodeView removeFromSuperview];
    self.passcodeView = nil;
    
    [self.backdrop removeFromSuperview];
    self.backdrop = nil;
}

- (void) lockApp
{
    [self initLockdownUI];
    self.backdrop.bounds = self.window.bounds;
    self.backdrop.frame = self.window.frame;
    [self.window addSubview:self.backdrop];
    
    [self.window addSubview:self.passcodeView];
}

- (void) unlockApp
{
    [UIView animateWithDuration:1
                     animations:^(void) {
                         [self.passcodeView removeFromSuperview];
                         self.backdrop.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self deallocLockdownUI];
                     }];
}

- (BOOL)passcodeView:(PasscodeView *)passcodeView didEnterPasscode:(NSString *)passcode
{
    if ([passcode isEqualToString:@"1234"]) {
        [self unlockApp];
        return YES;
    } else {
        return NO;
    }
}

-(void)passcodeViewDidCancel:(PasscodeView *)passcodeView
{
    NSLog(@"cancel");
}

- (void)passcodeView:(PasscodeView *)passcodeView didSucceedWithPasscode:(NSString *)passcode
{
    [self unlockApp];
}

- (NSUInteger)maximumNumberOfAttempts:(PasscodeView *)passcodeView
{
    return 3;
}

- (void)passcodeViewExceededMaximumNumberOfAttempts:(PasscodeView *)passcodeView
{
    CGSize ws = self.window.bounds.size;
    UIImageView* death = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"death.png"]];
    death.center = CGPointMake(ws.width / 2, ws.height / 2);
    [self.window addSubview:death];
    [death release];
    
    self.backdrop.backgroundColor = [UIColor redColor];
    
    [self.passcodeView removeFromSuperview];
    self.passcodeView = nil;
    
    isDead = YES;
}

@end
