//
//  PasscodeView.h
//  Sandbox
//


#import <UIKit/UIKit.h>

#define PASSCODE_LENGTH 4

@protocol PasscodeViewDelegate;

@interface PasscodeView : UIView
{
@private
    int userDigits[PASSCODE_LENGTH];
    NSUInteger cursorPosition;
    NSUInteger attempts;
    
    BOOL didQueryForMaxAttempts;
    NSUInteger maxattempts;
}

@property (readwrite,nonatomic,assign) id<PasscodeViewDelegate> delegate;

@property (nonatomic, retain) IBOutlet UILabel *titleView;
@property (nonatomic, retain) IBOutlet UILabel *subtitleLabel;
@property (nonatomic,retain) IBOutlet UITextField* passcodeCell1;
@property (nonatomic,retain) IBOutlet UITextField* passcodeCell2;
@property (nonatomic,retain) IBOutlet UITextField* passcodeCell3;
@property (nonatomic,retain) IBOutlet UITextField* passcodeCell4;

- (IBAction)cancel:(id)sender;
- (IBAction)backspace:(id)sender;
- (IBAction)inputNumber:(id)sender;
- (IBAction)highlightButton:(id)sender;

- (NSString*) userEntry;
- (void) resetUserEntry;

- (void) resetView;
- (void) configureView;
- (void) displayError;

- (void) resetAttempts;

@end



@protocol PasscodeViewDelegate <NSObject>

/** The delegate must return a pass/fail when a password is fully entered */
- (BOOL) passcodeView:(PasscodeView*)passcodeView didEnterPasscode:(NSString*)passcode;

@optional

/** number of maximum passcode attempts, if undefined the default is to allow all attempts (uint32 max value) */
- (NSUInteger) maximumNumberOfAttempts:(PasscodeView*)passcodeView;

/** called only when a max number of attempts is returned from the other delegate method, this may be called multiple times if the delegate does not remove the view or lock it down to stop user entry */
- (void) passcodeViewExceededMaximumNumberOfAttempts:(PasscodeView*)passcodeView;

/** called when the user enters a passcode that passes delegate validation, may be called multiple times if the delegate does not remove the view or lock it down to stop user entry */
- (void) passcodeView:(PasscodeView*)passcodeView didSucceedWithPasscode:(NSString*)passcode;

/** called when the user presses the cancel button */
- (void) passcodeViewDidCancel:(PasscodeView*)passcodeView;

@end
