//
//  PasscodeView.m
//  Sandbox
//


#import "PasscodeView.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]
#define HIGHLIGHT_COLOR RGBA(0,.5,1,.50)
#define DEFAULT_COLOR RGBA(0,0,0,.70)

@interface PasscodeView(Private)
- (void) logAttempt;
@end

@implementation PasscodeView

@synthesize delegate;

@synthesize titleView;
@synthesize subtitleLabel;
@synthesize passcodeCell1;
@synthesize passcodeCell2;
@synthesize passcodeCell3;
@synthesize passcodeCell4;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        maxattempts = NSUIntegerMax;
        [self resetView];
    }
    return self;
}

- (void)dealloc
{
    [passcodeCell1 release];
    [passcodeCell2 release];
    [passcodeCell3 release];
    [passcodeCell4 release];
    [titleView release];
    [subtitleLabel release];
    [super dealloc];
}

- (IBAction)cancel:(id)sender
{
    [UIView animateWithDuration:.3
                     animations:^(void) {
                         [sender setBackgroundColor:DEFAULT_COLOR];
                     }];
    [self resetView];
    
    if ([delegate respondsToSelector:@selector(passcodeViewDidCancel:)]) {
        [delegate passcodeViewDidCancel:self];
    }
}

- (IBAction)backspace:(id)sender
{
    [UIView animateWithDuration:.3
                     animations:^(void) {
                        [sender setBackgroundColor:DEFAULT_COLOR];
                     }];
    
    if (cursorPosition > 0) {
        userDigits[cursorPosition--] = -1;
        [self configureView];
    }
}

- (IBAction)inputNumber:(id)sender
{
    if (!didQueryForMaxAttempts) {
        if ([delegate respondsToSelector:@selector(maximumNumberOfAttempts:)]) {
            maxattempts = [delegate maximumNumberOfAttempts:self];
        }
        didQueryForMaxAttempts = YES;
    }
    
    [UIView animateWithDuration:.3
                     animations:^(void) {
                         [sender setBackgroundColor:DEFAULT_COLOR];
                     }];
    
    if (cursorPosition >= PASSCODE_LENGTH) {
        cursorPosition = 0;
    }
    
    UIButton* b = sender;
    userDigits[cursorPosition++] = [b tag]; // [[[b titleLabel] text] intValue];
    [self configureView];
    
    if (cursorPosition == PASSCODE_LENGTH) {
        [self logAttempt];
    }
}

- (void) logAttempt
{
    ++attempts;
    
    BOOL passcodeCorrect = [delegate passcodeView:self
                                 didEnterPasscode:[self userEntry]];
    
    if (!passcodeCorrect) {
        [self displayError];
        
        if ((maxattempts != NSUIntegerMax) && (attempts >= maxattempts)) {
            if ([delegate respondsToSelector:@selector(passcodeViewExceededMaximumNumberOfAttempts:)]) {
                [delegate passcodeViewExceededMaximumNumberOfAttempts:self];
            }
        }
    } else {
        if ([delegate respondsToSelector:@selector(passcodeView:didSucceedWithPasscode:)]) {
            [delegate passcodeView:self didSucceedWithPasscode:[self userEntry]];
        }
    }
}

- (IBAction)highlightButton:(id)sender
{
    [sender setBackgroundColor:HIGHLIGHT_COLOR];
}

- (NSString*) userEntry
{
    return [NSString stringWithFormat:@"%d%d%d%d", 
            userDigits[0], 
            userDigits[1], 
            userDigits[2], 
            userDigits[3]];
}

- (void) resetView
{
    passcodeCell1.text = @"";
    passcodeCell2.text = @"";
    passcodeCell3.text = @"";
    passcodeCell4.text = @"";
    [self resetUserEntry];
}

- (void) resetUserEntry
{
    userDigits[0] = -1;
    userDigits[1] = -1;
    userDigits[2] = -1;
    userDigits[3] = -1;
    cursorPosition = 0;
}

- (void) configureView
{
    passcodeCell1.text = @"";
    passcodeCell2.text = @"";
    passcodeCell3.text = @"";
    passcodeCell4.text = @"";
    
    for (int i=0; i!=PASSCODE_LENGTH; ++i) {
        NSString* v = (cursorPosition > i) ? [NSString stringWithFormat:@"%d", userDigits[i]] : @"";
        
        switch (i) {
            case 0:
                passcodeCell1.text = v;
                break;
            case 1:
                passcodeCell2.text = v;
                break;
            case 2:
                passcodeCell3.text = v;
                break;
            case 3:
                passcodeCell4.text = v;
                break;
                
            default:
                break;
        }
    }
}

- (void) displayError
{
    self.titleView.text = NSLocalizedString(@"Wrong Passcode", @"Wrong Passcode");
    self.titleView.backgroundColor = [UIColor redColor];
    self.titleView.textColor = [UIColor whiteColor];
    
    self.subtitleLabel.backgroundColor = [UIColor redColor];
    self.subtitleLabel.textColor = [UIColor whiteColor];
    
    if (maxattempts != NSUIntegerMax) {
        self.subtitleLabel.text = [NSString stringWithFormat:@"%d Attempts Left", maxattempts-attempts];
    }
}

- (NSString*) description
{
    return [self userEntry];
}

@end
