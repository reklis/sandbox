//
//  PasscodeManagementViewController.m
//  tnsbodapp
//
//  Created by Steven Fusco on 5/12/11.
//  Copyright 2011 Cibo Technology, LLC. All rights reserved.
//

#import "PasscodeManagementViewController.h"
#import "TNSBODAppSettings.h"

@implementation PasscodeManagementViewController

@synthesize delegate;

@synthesize currentPasscode, newPasscode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [currentPasscode release];
    [newPasscode release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.currentPasscode = [TNSBODAppSettings appPasscode];
    
    if (!currentPasscode) {
        ++currentStep;
    }
    
    PasscodeView* pv = [[[NSBundle mainBundle] loadNibNamed:@"PasscodeView" owner:nil options:nil] objectAtIndex:0];
    pv.frame = self.view.frame;
    pv.bounds = self.view.bounds;
    pv.backgroundColor = [UIColor whiteColor];
    pv.delegate = self;
    pv.titleView.text = [self messageForStep:++currentStep];
    [self.view addSubview:pv];
}

- (void)viewDidUnload
{
    [self setCurrentPasscode:nil];
    [self setNewPasscode:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)messageForStep:(PasscodeManagementStep)step
{
    NSString* msg = nil;
    switch (currentStep) {
        case PasscodeManagementStep_EnterCurrentPasscode:
            msg = NSLocalizedString(@"Enter Current Passcode",@"Enter Current Passcode");
            break;
            
        case PasscodeManagementStep_EnterNewPasscode:
            msg = NSLocalizedString(@"Enter New Passcode",@"Enter New Passcode");
            break;
            
        case PasscodeManagementStep_EnterNewPasscodeAgain:
            msg = NSLocalizedString(@"Confirm New Passcode",@"Confirm New Passcode");
            break;
        
        case PasscodeManagementStep_Success:
            msg = NSLocalizedString(@"Passcode Changed", @"Passcode Changed");
            break;
            
        default:
            msg = @"";
            break;
    }

    return msg;
}

- (BOOL) passcodeView:(PasscodeView*)passcodeView didEnterPasscode:(NSString*)passcode
{
    BOOL ok = NO;
    
    switch (currentStep) {
        case PasscodeManagementStep_EnterCurrentPasscode:
            if (self.currentPasscode) {
                ok = [passcode isEqualToString:self.currentPasscode];
            } else {
                ok = YES;
            }
            break;
        
        case PasscodeManagementStep_EnterNewPasscode:
            self.newPasscode = passcode;
            ok = YES;
            break;
            
        case PasscodeManagementStep_EnterNewPasscodeAgain:
            ok = [passcode isEqualToString:self.newPasscode];
            break;
        
        default:
            ok = NO;
            break;
    }
    
    if (!ok) {
        passcodeView.subtitleLabel.text = [self messageForStep:currentStep];
    }
    
    return ok;
}

- (void) passcodeView:(PasscodeView*)passcodeView didSucceedWithPasscode:(NSString*)passcode
{
    ++currentStep;
    
    NSString* msg = [self messageForStep:currentStep];
    
    [passcodeView resetAttempts];
    
    if (
        (currentStep > PasscodeManagementStep_EnterCurrentPasscode) 
        && 
        (currentStep < PasscodeManagementStep_Success)
        )
    {
        passcodeView.titleView.text = msg;
        [passcodeView doSlideEffect];
    }
    
    if (currentStep == PasscodeManagementStep_Success) {
        [self saveChanges];
    }
}

- (void)passcodeViewDidCancel:(PasscodeView *)passcodeView
{
    if ([delegate respondsToSelector:@selector(passcodeManagerDidCancel:)]) {
        [delegate passcodeManagerDidCancel:self];
    }
}

- (void)saveChanges
{
    [TNSBODAppSettings setAppPasscode:self.newPasscode];
    
    if ([delegate respondsToSelector:@selector(passcodeManagerDidSucceed:)]) {
        [delegate passcodeManagerDidSucceed:self];
    }
}

@end
